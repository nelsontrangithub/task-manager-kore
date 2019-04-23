using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Amazon;
using Amazon.CognitoIdentityProvider;
using Amazon.CognitoIdentityProvider.Model;
using kore_api.Repositories;
using kore_api.Repositories.Interfaces;
using kore_api.ViewModels;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace kore_api.Controllers
{
    [ApiController]
    public class AuthenticationController : ControllerBase
    {
		private readonly IUserRepository _userRepository;

        private const string _clientId = "6fba0vhhhemve6bq3sm5evd0do";
        private readonly RegionEndpoint _region = RegionEndpoint.USEast2;

		public AuthenticationController(IUserRepository _userRepository)
		{
			this._userRepository = _userRepository;
		}

        [HttpPost]
        [Route("api/register")]
        public async Task<ActionResult<string>> Register(UserVM user)
        {
            var cognito = new AmazonCognitoIdentityProviderClient(_region);

            var request = new SignUpRequest
            {
                ClientId = _clientId,
                Password = user.Password,
                Username = user.Username
            };

            var emailAttribute = new AttributeType
            {
                Name = "email",
                Value = user.Email
            };
            request.UserAttributes.Add(emailAttribute);

            var response = await cognito.SignUpAsync(request);

			if (response.HttpStatusCode == HttpStatusCode.OK)
			{
				_userRepository.CreateUser(user);
			}

            return Ok();
        }

        [HttpPost]
        [Route("api/signin")]
        public async Task<ActionResult<string>> SignIn(UserVM user)
        {
            var cognito = new AmazonCognitoIdentityProviderClient(_region);

            var request = new AdminInitiateAuthRequest
            {
                UserPoolId = "us-east-2_G26JTdg5h",
                ClientId = _clientId,
                AuthFlow = AuthFlowType.ADMIN_NO_SRP_AUTH
            };

            request.AuthParameters.Add("USERNAME", user.Username);
            request.AuthParameters.Add("PASSWORD", user.Password);

            var response = await cognito.AdminInitiateAuthAsync(request);

            return Ok(response.AuthenticationResult.IdToken);
        }
    }
}
