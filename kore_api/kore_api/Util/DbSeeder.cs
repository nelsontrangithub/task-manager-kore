using kore_api.koredb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace kore_api.Util
{
    public static class DbSeeder
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

            var orgs = new Organization[]
            {
                new Organization
                {
                    Id = 1,
                    Name = "Coca Cola",
                    DateCreated = DateTime.Now,
                    Status = 1
                },
                new Organization
                {
                    Id = 2,
                    Name = "Pepsi",
                    DateCreated = DateTime.Now,
                    Status = 1
                }
            };
            foreach (Organization o in orgs)
            {
                context.Organization.Add(o);
            }
            context.SaveChanges();
            var accounts = new Account[]
            {
                new Account
                {
                    Id = 1,
                    OrgId = 1,
                    AccountName = "Real Madrid Contract",
                    DateCreated = DateTime.Now,
                    Status = 1,
                    Description = "Offical stadium beverage contract"
                },
                new Account
                {
                    Id = 2,
                    OrgId = 2,
                    AccountName = "Barcelona FC Contract",
                    DateCreated = DateTime.Now,
                    Status = 1,
                    Description = "Offical stadium beverage contract"
                }
            };
            foreach (Account o in accounts)
            {
                context.Account.Add(o);
            }
            context.SaveChanges();

            var taskTypes = new Tasktype[]
            {
                new Tasktype
                {
                    Id = 1,
                    OrgId = 1,
                    Name = "Misc.",
                    DateCreated = DateTime.Now,
                }
            };
            foreach (Tasktype item in taskTypes)
            {
                context.Tasktype.Add(item);
            }
            context.SaveChanges();

            var tasks = new koredb.Task[]
            {
                new koredb.Task
                {
                    Id = 1,
                    OwnerId = 1,
                    AccountId = 1,
                    OrgId = 1,
                    TaskType = 1,
                    Description = "Determine number of beverage stalls",
                    DueDate = DateTime.Now.AddDays(20),
                    DateCreated = DateTime.Now,
                    Status = 1                    
                },
                new koredb.Task
                {
                    Id = 2,
                    OwnerId = 2,
                    AccountId = 2,
                    OrgId = 2,
                    TaskType = 1,
                    Description = "Determine supply quality",
                    DueDate = DateTime.Now.AddDays(20),
                    DateCreated = DateTime.Now,
                    Status = 1
                }
            };
            foreach (koredb.Task t in tasks)
            {
                context.Task.Add(t);
            }
            context.SaveChanges();

            var orgmemberships = new Orgmembership[]
            {
                new Orgmembership
                {
                    UserId = 1,
                    OrgId = 1,
                    Enabled = 1,
                    JoinedOn = DateTime.Now,
                    CreatedBy = 1
                },
                new Orgmembership
                {
                    UserId = 2,
                    OrgId = 2,
                    Enabled = 2,
                    JoinedOn = DateTime.Now,
                    CreatedBy = 2
                }
            };
            foreach (Orgmembership t in orgmemberships)
            {
                context.Orgmembership.Add(t);
            }
            context.SaveChanges();

            var taskmemberships = new Taskmembership[]
            {
                new Taskmembership
                {
                    Id = 1,
                    TaskId = 1,
                    AccountId = 1,
                    UserId = 1,
                    OrgId = 1,
                    DateCreated = DateTime.Now
                },
                new Taskmembership
                {
                    Id = 2,
                    TaskId = 2,
                    AccountId = 2,
                    UserId = 2,
                    OrgId = 2,
                    DateCreated = DateTime.Now
                }
            };
            foreach (Taskmembership item in taskmemberships)
            {
                context.Taskmembership.Add(item);
            }
            context.SaveChanges();

            var taskdepts = new Taskdepartment[]
            {
                new Taskdepartment
                {
                    Id = 1,
                    OrgId = 1,
                    DepartmentName = "Marketing",
                    DateCreated = DateTime.Now,
                },
                new Taskdepartment
                {
                    Id = 2,
                    OrgId = 2,
                    DepartmentName = "Sales",
                    DateCreated = DateTime.Now
                }
            };
            foreach (Taskdepartment item in taskdepts)
            {
                context.Taskdepartment.Add(item);
            }
            context.SaveChanges();
        }

    }
}
