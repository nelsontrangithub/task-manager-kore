using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using kore_api.Repositories.Interfaces;
using kore_api.ViewModels;

namespace kore_api.Repositories
{
	public class UserRepository : IUserRepository
	{
		private readonly koredbContext context;

		public UserRepository(koredbContext context) {
			this.context = context;
		}

		public bool CreateUser(UserVM userVM)
		{
			User user = new User
			{
				Email = userVM.Email,
				Name = userVM.Email,
				FirstName = userVM.FirstName,
				LastName = userVM.LastName
			};

			context.User.Add(user);
			context.SaveChanges();

			return true;
		}

		public User GetUser(int id)
		{
			throw new NotImplementedException();
		}

		public IEnumerable<User> GetUsers()
		{
			throw new NotImplementedException();
		}

		public bool UserExists()
		{
			throw new NotImplementedException();
		}
	}
}
