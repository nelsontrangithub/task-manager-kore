using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using kore_api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace kore_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountsController : Controller
    {
        private readonly IAccountsRepository _accountsRepository;

        public AccountsController(IAccountsRepository accountsRepository)
        {
            _accountsRepository = accountsRepository;
        }

        // GET: api/account
        [HttpGet]
		[Authorize(Policy = "IsAdminOrAgent")]
		public IEnumerable<Account> GetAll()
        {
            return _accountsRepository.GetAccounts();
        }

        // GET: api/accounts/id
        [HttpGet("{id}")]
<<<<<<< HEAD
		[Authorize(Policy = "IsAdminOrAgent")]
		public Account Get(int id)
=======
        [Authorize(Policy = "IsAgent,IsAdmin")]
        public async Task<IActionResult> Get([FromRoute] int id)
>>>>>>> 7194884ec1c2d6a4c1ff58f00ecb28ea918ff428
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _accountsRepository.GetAccount(id);

            if (result == null)
            {
                return NotFound();
            }

            return Ok(result);
        }


        // PUT: api/Accounts/5
        [HttpPut("{id}")]
        [Authorize(Policy = "IsAdmin")]
        public async Task<IActionResult> PutTask([FromRoute] int id, [FromBody] int status)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _accountsRepository.Update(id, status);

            if (result == true)
            {
                return Ok(result);
            }

            return NoContent();
        }

        // DELETE: api/Accounts/5
        //Admin only
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAccount([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _accountsRepository.Delete(id);

            return Ok(result);
        }
    }
}
