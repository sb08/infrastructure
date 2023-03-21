using api;
using api.Domain;
using api.Extensions;
using api.Filters;
using api.Infrastructure;
using api.Messages;
using api.Middleware;
using Api.Middleware;
using AuthServiceAPI.Extensions;
using Azure.Messaging.ServiceBus;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpLogging;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Azure;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Primitives;
using Microsoft.Net.Http.Headers;
using Microsoft.OpenApi.Models;
using Serilog;
using System;
using System.Diagnostics;
using System.IdentityModel.Tokens.Jwt;
using System.Reflection;
using System.Security.Claims;

Log.Logger = new LoggerConfiguration()
    .WriteTo.File("log.txt")
    .CreateBootstrapLogger();

var builder = WebApplication.CreateBuilder(args);
builder.Host.UseSerilog();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwagger();
builder.Services.AddMediatR(typeof (PocEndpoints).GetTypeInfo().Assembly);
builder.Services.AddAuthServices(builder.Configuration);
builder.Services.AddDbContext<ApiContext>(o => o.UseInMemoryDatabase("BrokersDb"));

builder.Services.AddAzureClients(c =>
{
    c.AddServiceBusClient(Environment.GetEnvironmentVariable("SbConnectionString"))
      .WithName("ltf-servicebus")
      .ConfigureOptions(o =>
      {
          o.TransportType = ServiceBusTransportType.AmqpWebSockets;
          o.RetryOptions.Delay = TimeSpan.FromMilliseconds(50);
          o.RetryOptions.MaxDelay = TimeSpan.FromSeconds(5);
          o.RetryOptions.MaxRetries = 3;
      });
});

builder.Services.AddScoped<IBrokerRepository<Broker>, BrokerRepository>();
builder.Services.AddHostedService<Worker>();

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(
        policy =>
        {
            policy.WithOrigins(Environment.GetEnvironmentVariable("AllowedCorsOrigins").Split(" ").ToString());
        });
});

builder.Services.AddHttpLogging(o =>
{
    o.LoggingFields = HttpLoggingFields.All;
    o.RequestHeaders.Add(HeaderNames.Accept);
    o.RequestHeaders.Add(HeaderNames.ContentType);
    o.RequestHeaders.Add(HeaderNames.ContentDisposition);
    o.RequestHeaders.Add(HeaderNames.ContentEncoding);
    o.RequestHeaders.Add(HeaderNames.ContentLength);
    o.MediaTypeOptions.AddText("application/json");
    o.RequestBodyLogLimit = 4096;
    o.ResponseBodyLogLimit = 4096;
});

var app = builder.Build();

app.UseHttpLogging();
app.UseSerilogRequestLogging();
app.UseAccessTokenForwarding();
app.UseHttpsRedirection();
app.UseCors(o
    => o.SetIsOriginAllowed(x => _ = true).AllowAnyMethod().AllowAnyHeader().AllowCredentials()
    );
//app.UseMiddleware<ErrorLoggingMiddleware>();

JwtSecurityTokenHandler.DefaultInboundClaimTypeMap.Clear();

app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthentication();
app.UseAuthorization();

app.MapGet("/healthcheck", () =>
{
    return Results.NoContent();
})
.WithName("HealthCheck");

app.MapGet("/identity", IdentityHandler)
    .WithOpenApi(operation =>
    {
        operation.OperationId = "GetIdentity";
        operation.Description = "Gets the users claims from access token.";
        operation.Summary = "Gets the user details.";
        operation.Tags = new List<OpenApiTag>()
            { new OpenApiTag() { Name = "Identity" } };
        return operation;
    })
    .AddEndpointFilter(async (c, n) =>
    {
        Log.Information("Incoming.");
        StringValues at;
        c.HttpContext.Request.Headers.TryGetValue("Authorization", out at);
        if (string.IsNullOrEmpty(at))
            return Results.Unauthorized();
        Log.Information("Authorised.");
        var result = await n(c);
        Log.Information("Request fullfilled.");
        return result;
    })
    .RequireAuthorization("ApiScope")
.WithName("identity");

app.MapPost("/registration", async (Registration r, IMediator mediator) =>

    {
        var response = await mediator.Send(new CreateRegistrationCommand(r));
        return Results.Accepted("/registration/999", response);
    })
    .WithOpenApi(operation =>
    {
        operation.OperationId = "CreateRegistration";
        operation.Description = "Initiates a the user registration process.";
        operation.Summary = "Create a user.";
        operation.Tags = new List<OpenApiTag>()
            { new OpenApiTag() { Name = "Registration" } };
        return operation;
    })
    .AddEndpointFilter(async (c, n) =>
    {
        StringValues at;
        c.HttpContext.Request.Headers.TryGetValue("Authorization", out at);
        if (string.IsNullOrEmpty(at))
            return Results.Unauthorized();
        var result = await n(c);
        return result;
    })
    .RequireAuthorization("ApiScope")
    .WithName("registration");

app.MapGet("/brokers", async (IMediator mediator) =>
{
    var response = await mediator.Send(new GetBrokersQuery());
    return Results.Ok(response);
})
    .WithOpenApi(operation =>
    {
        operation.OperationId = "Get Registered Brokers";
        operation.Description = "Gets the users registered as brokers.";
        operation.Summary = "Gets list of brokers.";
        operation.Tags = new List<OpenApiTag>()
            { new OpenApiTag() { Name = "Brokers" } };
        return operation;
    })
    .AddEndpointFilter(async (c, n) =>
    {
        Log.Information("Incoming.");
        StringValues at;
        c.HttpContext.Request.Headers.TryGetValue("Authorization", out at);
        if (string.IsNullOrEmpty(at))
            return Results.Unauthorized();
        Log.Information("Authorised.");
        var result = await n(c);
        Log.Information("Request fullfilled.");
        return result;
    })
    .RequireAuthorization("ApiScope")
.WithName("brokers");

app.Run();

[Authorize]
[ClaimRequirements("sub")]
static IResult IdentityHandler(ClaimsPrincipal user)
{
    Log.Information("IdentityHandler");
    var list = from c in user.Claims select new { c.Type, c.Value };
    Log.Information(list.ToString());
    return Results.Json(from c in user.Claims select new { c.Type, c.Value });
    //var name = user.FindFirst("name")?.Value ?? user.FindFirst("sub")?.Value;
    //Log.Information($"IdentityHandler: {new { message = "Remote API Success!", user = name }.ToString()}");
    //return Results.Json(new { message = "Remote API Success!", user = name });
}