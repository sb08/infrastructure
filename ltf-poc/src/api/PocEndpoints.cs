using Serilog;
using System.Security.Claims;

namespace api
{
    public class PocEndpoints
    {
        public static IResult HealthCheck()
        {
            return TypedResults.NoContent();
        }

        public static IResult Xml2Json()
        {
            return TypedResults.Ok();
        }

        public static IResult GetIdentity(ClaimsPrincipal user)
        {
            Log.Information("Returning identity to apim.");
            var name = user.FindFirst("name")?.Value ?? user.FindFirst("sub")?.Value;
            return Results.Json(new
            {
                message = "Remote API Success!",
                user = name
            });
        }
    }
}
