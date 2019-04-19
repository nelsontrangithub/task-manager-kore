using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;

namespace kore_api.Repositories
{
    public class AccountsRespository : IAccountsRepository
    {
        private readonly koredbContext _context;
        
        public AccountsRespository(koredbContext context)
        {
            _context = context;
        }

        public Account GetAccount(int id)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<Account> GetAccounts()
        {
            var accounts = _context.Account.ToList();
            return accounts;
        }

        public bool UpdateAccount(int id, int status)
        {
            var account = _context.Account.Where(a => a.Id == id).FirstOrDefault();
            account.Status = status;
            account.DateModified = DateTime.Now;
            try
            {
                _context.Update(account);
                _context.SaveChanges();
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }
    }
}
