using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace api.Filters
{
    internal class MyDocumentFilter : IDocumentFilter
    {
        public void Apply(OpenApiDocument swaggerDoc, DocumentFilterContext context)
        {
            swaggerDoc.Servers = new List<OpenApiServer>() { new OpenApiServer() { Url = "https://ltf-api-8605-dev.azurewebsites.net" } };
        }
    }
}