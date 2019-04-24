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
				Name = userVM.FirstName + " " + userVM.LastName,
				FirstName = userVM.FirstName,
				LastName = userVM.LastName
			};

			context.User.Add(user);
			context.SaveChanges();

			return true;
		}
		public int GetUserId(string email)
		{
			var user = context.User.Where(u => u.Email == email).FirstOrDefault();
			return user.Id;
		}

		public IEnumerable<User> GetUsers()
		{
			return context.User.ToList();
		}

		public bool UserExists(string email)
		{
			if (context.User.Where(u => u.Email == email).FirstOrDefault() != null)
			{
				return true;
			}
			return false;
		}
	}
}
