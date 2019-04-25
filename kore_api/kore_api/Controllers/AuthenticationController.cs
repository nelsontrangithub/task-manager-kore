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

		private const string _defaultRole = "Agent";
		private const string _poolId = "us-east-2_G26JTdg5h";
		private const string _clientId = "6fba0vhhhemve6bq3sm5evd0do";
        private readonly RegionEndpoint _region = RegionEndpoint.USEast2;

		public AuthenticationController(IUserRepository _userRepository)
		{
			this._userRepository = _userRepository;
		}

        /// <summary>
        /// Register a User
        /// </summary>
        [HttpPost]
        [Route("api/register")]
        public async Task<ActionResult<string>> Register(UserVM user)
        {
            var cognito = new AmazonCognitoIdentityProviderClient(_region);

            var signUpRequest = new SignUpRequest
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
			signUpRequest.UserAttributes.Add(emailAttribute);
            

			var addToGroupRequest = new AdminAddUserToGroupRequest
			{
				GroupName = _defaultRole,
				Username = user.Username,
				UserPoolId = _poolId
			};

			var signUpResponse = await cognito.SignUpAsync(signUpRequest);
			var addToGroupResponse = await cognito.AdminAddUserToGroupAsync(addToGroupRequest);

			if (signUpResponse.HttpStatusCode == HttpStatusCode.OK)
			{
				_userRepository.CreateUser(user);
			}

            return Ok();
        }

        /// <summary>
        /// Sign in with 'admin@kore.com' and 'P@ssw0rd!'
        /// </summary>
        [HttpPost]
        [Route("api/signin")]
        public async Task<ActionResult<string>> SignIn(UserVM user)
        {
            var cognito = new AmazonCognitoIdentityProviderClient(_region);

            var request = new AdminInitiateAuthRequest
            {
                UserPoolId = _poolId,
                ClientId = _clientId,
                AuthFlow = AuthFlowType.ADMIN_NO_SRP_AUTH
            };

            request.AuthParameters.Add("USERNAME", user.Username);
            request.AuthParameters.Add("PASSWORD", user.Password);

			if (!_userRepository.UserExists(user.Username))
			{
				return NotFound("User not found");
			}
			var response = await cognito.AdminInitiateAuthAsync(request);

            return Ok(response.AuthenticationResult.IdToken);
        }

        /// <summary>
        /// Get User by Username
        /// </summary>
        [HttpGet]
        [Route("api/getUser")]
        public async Task<IActionResult> GetUser(string username, string password)
        {
            var result = await _userRepository.GetUser(username, password);
            if (result == null)
            {
                return NotFound();
            }
            return Ok(result);
        }
    }
}
