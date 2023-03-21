using api.Extensions;
using Serilog;

namespace api.Middleware
{
    public class ErrorLoggingMiddleware
    {
        private readonly RequestDelegate _next;

        public ErrorLoggingMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
                Log.Information($"{context.Response.GetRawBodyAsync().Result }");

            }
            catch (Exception e)
            {
                Log.Error($"{e}");
                throw;
            }
        }
    }
}
