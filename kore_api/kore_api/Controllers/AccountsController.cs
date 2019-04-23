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
		[Authorize(Policy = "IsAdminOrAgent")]
		public Account Get(int id)
        {
            return _accountsRepository.GetAccount(id);
        }

        // POST: api/accounts/id
        // updates the status and date modified rows
        [HttpPost("{id}")]
		[Authorize(Policy = "IsAdmin")]
		public bool UpdateAccount(int id, [FromBody] int status)
        {
            return _accountsRepository.UpdateAccount(id, status);
        }
    }
}
