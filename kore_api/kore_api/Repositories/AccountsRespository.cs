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

        public IEnumerable<AccountVM> GetAccountsByOrgId(int orgID)
        {
            var query = from x in _context.Account
                        join y in _context.Organization on x.OrgId equals y.Id
                        where x.OrgId.Equals(orgID)
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

        public IEnumerable<AccountVM> GetAccountsByUser(int userID)
        {
            var query = from x in _context.Account
                        join y in _context.Organization on x.OrgId equals y.Id
                        join z in _context.Orgmembership on x.OrgId equals z.OrgId
                        where z.UserId.Equals(userID)
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

        public Task<Account> GetAccount(int id)
        {
            return _context.Account.FindAsync(id);
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

        public double GetProgressPercentage(int userID, int accountID)
        {
            var query = from x in _context.Taskmembership
                        join y in _context.Task on x.TaskId equals y.Id
                        where x.AccountId.Equals(accountID) && x.UserId.Equals(userID)
                        select new TaskVM
                        {
                            Id = x.Id,
                            TaskId = x.TaskId,
                            AccountId = x.AccountId,
                            UserId = x.UserId,
                            OrgId = x.OrgId,
                            DateCreated = x.DateCreated,
                            DateModified = x.DateModified,
                            Status = x.Status,
                            CreatedBy = x.CreatedBy,
                            ModifiedBy = x.ModifiedBy,
                            OwnerId = y.OwnerId,
                            TaskStatus = y.Status,
                            Description = y.Description,
                            DueDate = y.DueDate,
                            CompletedOn = y.CompletedOn,
                            Subject = y.Subject,
                            Department = y.Department
                        };

            var query2 = from x in _context.Taskmembership
                         join y in _context.Task on x.TaskId equals y.Id
                         where x.AccountId.Equals(accountID) && x.UserId.Equals(userID) && y.Status.Equals(1)
                         select new TaskVM
                         {
                             Id = x.Id,
                             TaskId = x.TaskId,
                             AccountId = x.AccountId,
                             UserId = x.UserId,
                             OrgId = x.OrgId,
                             DateCreated = x.DateCreated,
                             DateModified = x.DateModified,
                             Status = x.Status,
                             CreatedBy = x.CreatedBy,
                             ModifiedBy = x.ModifiedBy,
                             OwnerId = y.OwnerId,
                             TaskStatus = y.Status,
                             Description = y.Description,
                             DueDate = y.DueDate,
                             CompletedOn = y.CompletedOn,
                             Subject = y.Subject,
                             Department = y.Department
                         };

            if (query.Count() != 0 && query2.Count() != 0)
            {
                double result = query2.Count() / query.Count();
                return result;
            }
            else
            {
                return 0.0;
            }
        }
    }
}
