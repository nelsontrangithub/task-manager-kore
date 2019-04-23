using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using Microsoft.EntityFrameworkCore;

namespace kore_api.Repositories
{
    public class AccountsRespository : IAccountsRepository
    {
        private readonly koredbContext _context;
        
        public AccountsRespository(koredbContext context)
        {
            _context = context;
        }

        public Task<Account> GetAccount(int id)
        {
            return _context.Account.FindAsync(id);
        }

        public IEnumerable<Account> GetAccounts()
        {
            var accounts = _context.Account.ToList();
            return accounts;
        }

        public async Task<bool> Update(int id, int status)
        {
            var result = await _context.Account.Where(t => t.Id == id).FirstOrDefaultAsync();

            try
            {
                result.Status = status;
                result.DateModified = DateTime.Now;
                _context.Update(result);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public async Task<bool> Delete(int id)
        {
            var account = await _context.Account.FindAsync(id);

            if (account == null)
            {
                return false;
            }

            try
            {
                _context.Account.Remove(account);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}
