using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using kore_api.Repositories.Interfaces;
using kore_api.ViewModels;
using Microsoft.EntityFrameworkCore;

namespace kore_api.Repositories
{
	public class UserRepository : IUserRepository
	{
		private readonly koredbContext _context;

		public UserRepository(koredbContext context) {
			_context = context;
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

			_context.User.Add(user);
			_context.SaveChanges();

			return true;
		}

		public int GetUserId(string email)
		{
			var user = _context.User.Where(u => u.Email == email).FirstOrDefault();
			return user.Id;
		}

        public async Task<User> GetUser(string username)
        {
            var user = await _context.User.Where(u => u.Email == username).FirstOrDefaultAsync();
            return user;
        }

		public IEnumerable<User> GetUsers()
		{
			return _context.User.ToList();
		}

        public IEnumerable<User> SearchUsersByEmail(string search)
        {
            var query = _context.User.Where(u => u.Email.Contains(search));
            return query;
        }

        public IEnumerable<User> UsersAssignedToTask(int taskId)
        {
            var query = from x in _context.Taskmembership
                        join y in _context.User on x.UserId equals y.Id
                        where x.TaskId.Equals(taskId)
                        select new User
                        {
                            Id = y.Id,
                            Email = y.Email,
                            Name = y.Name,
                            IconFileId = y.IconFileId,
                            IconFileUrl = y.IconFileUrl,
                            LastLogin = y.LastLogin,
                            DateCreated = y.DateCreated,
                            Status = y.Status,
                            FirstName = y.FirstName,
                            LastName = y.LastName,
                            Sid = y.Sid,
                        };
            return query;
        }

        public bool UserExists(string email)
		{
			if (_context.User.Where(u => u.Email == email).FirstOrDefault() != null)
			{
				return true;
			}
			return false;
		}
	}
}
