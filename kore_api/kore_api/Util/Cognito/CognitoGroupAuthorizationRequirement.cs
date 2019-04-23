using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

namespace kore_api.Util.Cognito
{
	public class CognitoGroupAuthorizationRequirement: IAuthorizationRequirement
	{
		public string CognitoGroup { get; set; }

		public CognitoGroupAuthorizationRequirement(string cognitoGroup)
		{
			CognitoGroup = cognitoGroup;
		}
	}
}
