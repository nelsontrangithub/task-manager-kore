using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace kore_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountsController : ControllerBase
    {
        private koredbContext context;

        public AccountsController(koredbContext context)
        {
            this.context = context;
        }

        // GET: api/Accounts
        [HttpGet]
        public IEnumerable<Account> Get()
        {
            var accounts = context.Account.ToList();

            return accounts;
        }

        [HttpPost("{id}")]
        public bool UpdateStatus(int id, [FromBody] int status)
        {
            var account = context.Account.Where(a => a.Id == id).FirstOrDefault();
            account.Status = status;
            account.DateModified = DateTime.Now;
            try
            {
                context.Update(account);
                context.SaveChanges();
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }
    }
}
