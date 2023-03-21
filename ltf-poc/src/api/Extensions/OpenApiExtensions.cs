using Microsoft.Extensions.DependencyInjection;
using api.Filters;
using Microsoft.OpenApi.Models;
using System;
using Microsoft.Extensions.Options;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace api.Extensions;

public static class OpenApiExtensions
{
    public static void AddSwagger(this IServiceCollection services)
    {
        services.AddSwaggerGen(c =>
        {
            //c.EnableAnnotations();
            c.UseAllOfToExtendReferenceSchemas();
            c.SwaggerDoc("v1", new OpenApiInfo { Title = "API", Version = "v1" });
            c.AddSecurityDefinition("BearerAuth", new OpenApiSecurityScheme
            {
                Type = SecuritySchemeType.Http,
                Scheme = "bearer",
                Description = "bearer token",
                BearerFormat = "JWT"
            });
            c.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                {
                    new OpenApiSecurityScheme
                    {
                        Reference = new OpenApiReference
                        {
                            Type = ReferenceType.SecurityScheme,
                            Id = "BearerAuth",
                        }
                    },
                    Array.Empty<string>()
                }
            });
            c.DocumentFilter<MyDocumentFilter>();
            //c.OperationFilter<AddOpenApiResponses>();
        });
    }
}
