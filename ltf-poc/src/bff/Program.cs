using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Duende.Bff;
using Duende.Bff.Yarp;
using bff.Middleware;
using Microsoft.AspNetCore.Authorization;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.File("log.txt")
    .CreateBootstrapLogger();

Log.Information("Starting up");

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog();

builder.Host.UseSerilog((ctx, lc) => lc
    .WriteTo.Console(outputTemplate: "[{Timestamp:HH:mm:ss} {Level}] {SourceContext}{NewLine}{Message:lj}{NewLine}{Exception}{NewLine}")
    .Enrich.FromLogContext()
    .ReadFrom.Configuration(ctx.Configuration));

builder.Services.AddAuthorization();

builder.Services
    .AddBff(o => {
        o.EnableSessionCleanup = true;
        o.SessionCleanupInterval = TimeSpan.FromMinutes(5);
        o.ManagementBasePath = "/bff";
        o.BackchannelLogoutAllUserSessions = true;
        //o.AccessTokenManagementConfigureAction = x => x.User.RefreshBeforeExpiration = new TimeSpan(500);
    })
    .AddServerSideSessions()
    .AddRemoteApis();

//builder.Services
//    .AddReverseProxy()
//    .AddBffExtensions();

JwtSecurityTokenHandler.DefaultMapInboundClaims = false;
builder.Services
    .AddAuthentication(options =>
    {
        options.DefaultScheme = "Cookies";
        options.DefaultChallengeScheme = "oidc";
        options.DefaultSignOutScheme = "oidc";
    })
    .AddCookie("Cookies", options =>
    {
        options.ExpireTimeSpan = TimeSpan.FromHours(8);
        options.SlidingExpiration = false;
        options.Cookie.Name = "__Host-ng";
        options.Cookie.SameSite = SameSiteMode.Strict;
    })
    .AddOpenIdConnect("oidc", options =>
    {
        options.Authority = Environment.GetEnvironmentVariable("Authority");
        //options.Authority = "https://ltf-id-42901-dev.azurewebsites.net";
        options.ClientId = "js-host";
        options.ClientSecret = "secret";
        options.ResponseType = OpenIdConnectResponseType.Code;
        options.ResponseMode = "query";
        options.GetClaimsFromUserInfoEndpoint = true;
        options.MapInboundClaims = false;
        options.SaveTokens = true;
        options.Scope.Clear();
        options.Scope.Add("openid");
        options.Scope.Add("profile");
        options.Scope.Add("api1");
        options.Scope.Add("apim");
        options.Scope.Add("registration");
        options.Scope.Add("offline_access");
        options.GetClaimsFromUserInfoEndpoint = true;
    });

var apimUri = Environment.GetEnvironmentVariable("ApimUri");
Log.Information($"ApimUri is {apimUri}");

builder.Services
    .AddUserAccessTokenHttpClient("apiClient", configureClient: client =>
    {
        client.BaseAddress = new Uri(apimUri);
    });

var app = builder.Build();

app.UseHttpLogging();
app.UseSerilogRequestLogging();

app.UseMiddleware<ErrorLoggingMiddleware>();
app.UseAccessTokenForwarding();

app.UseDefaultFiles();
app.UseStaticFiles();

app.UseAuthentication();
app.UseRouting();
app.UseBff();
app.UseAuthorization();

app.UseEndpoints(endpoints =>
{
    endpoints.MapBffManagementEndpoints();
    //endpoints.MapBffReverseProxy();
    // Uncomment this for Controller support
    // endpoints.MapControllers()
    //     .AsBffApiEndpoint();

    endpoints.MapGet("/local/identity", LocalIdentityHandler)
        .AsBffApiEndpoint();

    var remoteUri = Environment.GetEnvironmentVariable("RemoteUri");
    Log.Information($"RemoteUri is {remoteUri}");

    endpoints.MapRemoteBffApiEndpoint("/remote", $"{remoteUri}/identity")
        .RequireAccessToken(TokenType.User);

    endpoints.MapRemoteBffApiEndpoint("/apim/identity", $"{apimUri}/identity")
        .RequireAccessToken(TokenType.User);

    endpoints.MapRemoteBffApiEndpoint("/apim/registration", $"{apimUri}/registration")
    .RequireAccessToken(TokenType.User);

    endpoints.MapRemoteBffApiEndpoint("/apim/registration-direct", $"{apimUri}/service-bus/registration")
    .RequireAccessToken(TokenType.User);

});

app.Run();

[Authorize]
static IResult LocalIdentityHandler(ClaimsPrincipal user)
{
    var name = user.FindFirst("name")?.Value ?? user.FindFirst("sub")?.Value;
    return Results.Json(new { message = "Local API Success!", user = name });
}