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
		User GetUser(int id);
		bool CreateUser(UserVM userVM);
		bool UserExists();
	}
}
