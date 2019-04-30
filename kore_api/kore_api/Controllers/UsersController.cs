using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using kore_api.Repositories.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace kore_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IUserRepository _userRepository;

        public UsersController(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        /// <summary>
        /// Gets all Users.
        /// </summary>
        // GET: api/User
        [HttpGet]
        [Authorize(Policy = "IsAdminOrAgent")]
        public IEnumerable<User> GetTasks()
        {
            return _userRepository.GetUsers();
        }

        /// <summary>
        /// Get User by Username
        /// </summary>
        [HttpGet]
        [Authorize(Policy = "IsAdminOrAgent")]
        [Route("api/getUser/{username}")]
        public async Task<IActionResult> GetUser([FromRoute] string username)
        {
            var result = await _userRepository.GetUser(username);
            if (result == null)
            {
                return NotFound();
            }
            return Ok(result);
        }

        /// <summary>
        /// Search user by email/username
        /// </summary>
        [HttpGet]
        [Authorize(Policy = "IsAdminOrAgent")]
        [Route("api/search/{username}")]
        public IEnumerable<User> SearchUser([FromRoute] string username)
        {
            var result = _userRepository.SearchUsersByEmail(username);
            return result;
        }
    }
}