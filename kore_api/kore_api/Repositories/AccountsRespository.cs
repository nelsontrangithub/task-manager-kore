using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using kore_api.ViewModels;
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

        //public IEnumerable<Account> GetAccounts()
        //{
        //    var accounts = _context.Account.ToList();
        //    return accounts;
        //}

        public IEnumerable<AccountVM> GetAccounts()
        {
            var query = from x in _context.Account
                        join y in _context.Organization on x.OrgId equals y.Id
                        select new AccountVM
                        {
                            Id = x.Id,
                            OrgId = x.OrgId,
                            OrgName = y.Name,
                            AccountName = x.AccountName,
                            DateCreated = x.DateCreated,
                            DateModified = x.DateModified,
                            Status = x.Status,
                            Description = x.Description,
                            CreatedBy = x.CreatedBy,
                            ModifiedBy = x.ModifiedBy
                        };
            return query;
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
