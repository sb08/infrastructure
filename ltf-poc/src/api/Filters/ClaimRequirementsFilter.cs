using api.Extensions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Nodes;

namespace api.Filters;

/// <summary>
///     Validates required claims. Ctor parameter is space delimeted string. 
/// </summary>
[AttributeUsage(AttributeTargets.Method, AllowMultiple = true, Inherited = true)]
public class ClaimRequirements : Attribute, IAuthorizationFilter
{
    private readonly IEnumerable<string> _claims;

    public ClaimRequirements(string claims) => _claims = claims.Split(" ").Select(s => s);

    public void OnAuthorization(AuthorizationFilterContext context)
    {
        Log.Information($"Auth Header: {context.HttpContext.Request.Headers["Authorization"]}");

        bool valid = true;
        var req = context.HttpContext.Request.GetRawBodyAsync().Result;
        var data = JsonNode.Parse(req).AsObject();

        foreach (var claim in _claims)
        {
            if (claim.Equals("sub"))
            {
                var subject = context.HttpContext.User.Identities?.SelectMany(s => s.Claims)?.Where(w => w.Type == "sub")?.First().Value;
                if (subject is not null)
                {
                    data.TryGetPropertyValue("userName", out var node);
                    var username = node.GetValue<string>();
                    if (!subject.Equals(username))
                    {
                        Log.Warning($"Required claim sub {context.HttpContext.User.Claims.Where(w => w.Type == "sub").First()?.Value} not equal to request body userName {username}.");
                        valid = false;
                    }
                }
                else
                {
                    Log.Warning($"Required claim sub is missing.");
                    valid = false;
                }
            }
        }

        if (!valid)
        {
            Log.Warning($"Returning unauthorized result.");
            context.Result = new UnauthorizedResult();
        }

        Log.Information($"Required claims validated.");
    }
}

