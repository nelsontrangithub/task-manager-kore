using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

namespace kore_api.Util.Cognito
{
	public class CognitoGroupAuthorizationHandler : AuthorizationHandler<CognitoGroupAuthorizationRequirement>
	{
		protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, CognitoGroupAuthorizationRequirement requirement)
		{
			if (context.User.HasClaim(c => c.Type == "cognito:groups" && c.Value == requirement.CognitoGroup))
			{
				context.Succeed(requirement);
			}
			else
			{
				context.Fail();
			}

			return Task.CompletedTask;
		}
	}
}
