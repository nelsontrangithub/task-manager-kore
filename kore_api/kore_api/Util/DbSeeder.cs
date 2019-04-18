using kore_api.koredb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace kore_api.Util
{
    public class DbSeeder
    {
        public static void Initialize(koredbContext context)
        {
            context.Database.EnsureCreated();

            ////Look for any users.
            //if (context.ApplicationUsers.Any())
            //    {
            //        return;   // DB has been seeded
            //    }

            var users = new User[]
            {
                new User
                {
                       Id = 1,
                       Email = "admin@kore.com",
                       Name = "Joe Smith",
                       DateCreated = DateTime.Now,
                       Status = 1,
                       FirstName = "Joe",
                       LastName = "Smith"
                },
                new User
                {
                       Id = 2,
                       Email = "user@kore.com",
                       Name = "Anne Smith",
                       DateCreated = DateTime.Now,
                       Status = 1,
                       FirstName = "Joe",
                       LastName = "Smith"
                }
            };
            foreach (User s in users)
            {
                context.User.Add(s);
            }
            context.SaveChanges();
        }
    }
}
