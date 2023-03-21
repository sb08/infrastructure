using System.Collections;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Serilog;

namespace bff.Middleware;

public static class CustomTokenMiddlewareExtensions
{
    public static IApplicationBuilder UseAccessTokenForwarding(this IApplicationBuilder builder)
    {
        return builder.UseMiddleware<CustomOauthMiddleware>();
    }
}

public class CustomOauthMiddleware
{
    private readonly RequestDelegate _next;

    public CustomOauthMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        var t = context.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
        Log.Information($"***** Authorization {t}");
        await _next(context);
    }
}
