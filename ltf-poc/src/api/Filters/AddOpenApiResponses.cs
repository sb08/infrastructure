using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace api.Filters
{
    public class AddOpenApiResponses : IOperationFilter
    {
        public void Apply(OpenApiOperation operation, OperationFilterContext context)
        {
            operation.Responses.Add("204", new OpenApiResponse { Description = "No Content" });
            operation.Responses.Add("401", new OpenApiResponse { Description = "Not authenticated" });
            operation.Responses.Add("403", new OpenApiResponse { Description = "Access token does not have the required scope" });
        }
    }
}
