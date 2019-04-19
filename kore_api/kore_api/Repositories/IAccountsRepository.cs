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
        Account GetAccount(int id);
        bool UpdateAccount(int id, int status);
    }
}
