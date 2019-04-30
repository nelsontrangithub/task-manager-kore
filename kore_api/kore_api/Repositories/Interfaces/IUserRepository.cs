using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using kore_api.ViewModels;

namespace kore_api.Repositories.Interfaces
{
	public interface IUserRepository
	{
		IEnumerable<User> GetUsers();
		int GetUserId(string email);
        Task<User> GetUser(string username);
        bool CreateUser(UserVM userVM);
		bool UserExists(string email);
        IEnumerable<User> SearchUsersByEmail(string search);

    }
}
