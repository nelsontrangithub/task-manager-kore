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
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class AccountsController : Controller
    {
        private readonly koredbContext _context;

        public AccountsController(koredbContext context)
        {
            _context = context;
        }

        // GET: api/accounts
        [HttpGet]
        public IEnumerable<Account> GetAll()
        {
            AccountsRespository accRepo = new AccountsRespository(_context);
            var accounts = accRepo.GetAccounts();
            return accounts;
        }

        // GET: api/accounts/id
        [HttpGet("{id}")]
        public Account Get(int id)
        {
            return new AccountsRespository(_context).GetAccount(id);
        }

        // POST: api/accounts/id
        // updates the status and date modified rows
        [HttpPost("{id}")]
        public bool UpdateAccount(int id, [FromBody] int status)
        {
            return new AccountsRespository(_context).UpdateAccount(id, status);
        }

    }
}
