using Duende.IdentityServer;
using Duende.IdentityServer.Models;
using IdentityModel;
using static System.Formats.Asn1.AsnWriter;

namespace identity;

public static class Config
{
    public static IEnumerable<IdentityResource> IdentityResources =>
        new List<IdentityResource>
        {
            new IdentityResources.OpenId(),
            new IdentityResources.Profile(),
            new IdentityResource()
            {
                Name = "verification",
                UserClaims = new List<string>
                {
                    JwtClaimTypes.Email,
                    JwtClaimTypes.EmailVerified
                }
            }
        };

    public static IEnumerable<ApiScope> ApiScopes =>
        new List<ApiScope>
        {
            new ApiScope("api1", "test"),
            new ApiScope("registration", "registration"),
            new ApiScope("apim", "api management")
        };

    public static IEnumerable<Client> Clients =>
        new List<Client>
        {
            new Client
            {
                ClientId = "js-host",
                ClientName = "BffJavascriptWebsite",
                ClientSecrets = { new Secret("secret".Sha256()) },
                AllowedGrantTypes = GrantTypes.Code,
                RedirectUris = { Environment.GetEnvironmentVariable("BffRedirectUri") },
                PostLogoutRedirectUris = { Environment.GetEnvironmentVariable("BffPostLogoutRedirectUri") },
                BackChannelLogoutUri = Environment.GetEnvironmentVariable("BffBackChannelLogoutUri"),
                BackChannelLogoutSessionRequired = true,
                AllowOfflineAccess = true,
                AllowedScopes = new List<string>
                {
                    IdentityServerConstants.StandardScopes.OpenId,
                    IdentityServerConstants.StandardScopes.Profile,
                    "api1",
                    "registration",
                    "apim"
                }
            },
            new Client
            {
                ClientId = "js",
                ClientName = "JavaScript Client",
                AllowedGrantTypes = GrantTypes.Code,
                RequireClientSecret = false,
                RedirectUris = { Environment.GetEnvironmentVariable("JsRedirectUri") },
                PostLogoutRedirectUris = { Environment.GetEnvironmentVariable("JsPostLogoutRedirectUri") },
                BackChannelLogoutUri = Environment.GetEnvironmentVariable("JsBackChannelLogoutUri"),
                AllowedCorsOrigins = { Environment.GetEnvironmentVariable("JsAllowedCorsOrigin") },

                AllowedScopes =
                {
                    IdentityServerConstants.StandardScopes.OpenId,
                    IdentityServerConstants.StandardScopes.Profile,
                    "api1",
                    "registration",
                    "apim"
                }
            }
        };

    //https://stackoverflow.com/questions/62930426/missing-aud-claim-in-access-token
    public static IEnumerable<ApiResource> ApiResources =>
        new List<ApiResource>
        {
            //GetApir("api1"),
            GetApir("apim")
        };

    private static ApiResource GetApir(string scope)
    {
        return new ApiResource(scope)
        {
            UserClaims =
            {
                JwtClaimTypes.Audience
            },
            Scopes = new List<string>
            {
                scope
            }
        };
    }
}
