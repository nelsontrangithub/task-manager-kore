using kore_api.koredb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace kore_api.Repositories
{
    public interface IAccountsRepository
    {
        IEnumerable<Account> GetAccounts();
        Task<Account> GetAccount(int id);
        Task<bool> Update(int id, int status);
        Task<bool> Delete(int id);
    }
}
