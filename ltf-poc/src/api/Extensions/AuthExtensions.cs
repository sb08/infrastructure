using System.Net.Http;
using System.Security.Authentication;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;

namespace AuthServiceAPI.Extensions;

public static class AuthExtensions
{
    public static IServiceCollection AddAuthServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddAuthentication("Bearer")
            .AddJwtBearer("Bearer", o =>
            {
                o.Authority = Environment.GetEnvironmentVariable("Authority");
                o.Audience = "apim";
                o.TokenValidationParameters.ValidateAudience = false;

                //o.RequireHttpsMetadata = true;
                //o.BackchannelHttpHandler = new HttpClientHandler
                //{
                //    SslProtocols = SslProtocols.Tls12 | SslProtocols.Tls11 | SslProtocols.Tls
                //};
            });

        services.AddAuthorization(o =>
            o.AddPolicy("ApiScope", policy =>
            {
                policy.RequireAuthenticatedUser();
                policy.RequireClaim("scope", "apim");
            })
        );

        return services;
    }

}