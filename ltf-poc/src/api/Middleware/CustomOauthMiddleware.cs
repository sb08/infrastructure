using Serilog;

namespace Api.Middleware;

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
        //if (context.Request.Headers is not null)
        //{
        //    foreach (var h in context.Request.Headers)
        //    {
        //        Log.Information($"*****{h.Key}  - {h.Value})");
        //    }
        //}
        //else
        //{ 
        //    Log.Warning("**** no headers! ****");
        //}

        var t = context.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
        Log.Information($"$$$$$$$$ ************ Authorization {t}");
        await _next(context);
    }
}
