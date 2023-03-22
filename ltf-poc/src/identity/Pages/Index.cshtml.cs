using System.Reflection;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace identity.Pages.Home;

[AllowAnonymous]
public class Index : PageModel
{
    public string Version;
    public string DotnetCoreVersion;

    public void OnGet()
    {
        DotnetCoreVersion = typeof(Microsoft.AspNetCore.Authorization.AuthorizationMiddleware).Assembly.GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion.Split('+').First();
        Version = typeof(Duende.IdentityServer.Hosting.IdentityServerMiddleware).Assembly.GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion.Split('+').First();
    }
}