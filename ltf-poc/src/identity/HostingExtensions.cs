using Duende.IdentityServer.Models;
using Duende.IdentityServer.Services;
using IdentityModel;
using Serilog;

namespace identity;

internal static class HostingExtensions
{
    public static WebApplication ConfigureServices(this WebApplicationBuilder builder)
    {
        builder.Services.AddRazorPages();

        builder.Services.AddIdentityServer(o =>
        {
            o.Authentication.CoordinateClientLifetimesWithUserSession = true;
            o.Authentication.CookieSlidingExpiration = true;
            o.Authentication.CookieLifetime = TimeSpan.FromMinutes(10);
            o.ServerSideSessions.UserDisplayNameClaimType = JwtClaimTypes.Name;
            o.ServerSideSessions.RemoveExpiredSessions = true;
            o.ServerSideSessions.RemoveExpiredSessionsFrequency = TimeSpan.FromMinutes(2);
            o.ServerSideSessions.ExpiredSessionsTriggerBackchannelLogout = true;
        }) 
            .AddInMemoryIdentityResources(Config.IdentityResources)
            .AddInMemoryApiScopes(Config.ApiScopes)
            .AddInMemoryApiResources(Config.ApiResources)
            .AddInMemoryClients(Config.Clients)
            .AddTestUsers(TestUsers.Users)
            .AddBackChannelLogoutService<DefaultBackChannelLogoutService>();

        return builder.Build();
    }
    
    public static WebApplication ConfigurePipeline(this WebApplication app)
    { 
        app.UseSerilogRequestLogging();
        if (app.Environment.IsDevelopment())
            app.UseDeveloperExceptionPage();
        app.UseStaticFiles();
        app.UseRouting();
        app.UseIdentityServer();
        app.UseAuthorization();
        app.MapRazorPages().RequireAuthorization();
        return app;
    }
}
