using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

namespace kore_api.Util.Cognito
{
	public class CognitoGroupAuthorizationHandler : AuthorizationHandler<CognitoGroupAuthorizationRequirement>
	{
		bool success;

		protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, CognitoGroupAuthorizationRequirement requirement)
		{
			success = false;

			foreach (string group in requirement.CognitoGroup)
			{
				if (context.User.HasClaim(c => c.Type == "cognito:groups" && c.Value == group))
				{
					success = true;
				}
			}

			if (success)
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
