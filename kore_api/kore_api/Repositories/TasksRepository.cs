using kore_api.koredb;
using kore_api.Repositories.Interfaces;
using kore_api.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Task = kore_api.koredb.Task;

namespace kore_api.Repositories
{
    public class TasksRepository : ITasksRepository
    {
        private readonly koredbContext _context;

        public TasksRepository(koredbContext context)
        {
            _context = context;
        }

        // Get all tasks
        public IEnumerable<Task> GetTasks()
        {
            return _context.Task;
        }

        // Get all taskmemberships
        public IEnumerable<TaskVM> GetTaskMemberships()
        {
            var query = from x in _context.Taskmembership
                        join y in _context.Task on x.TaskId equals y.Id
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

            return query;
        }

        //Get tasks by accountID
        public IEnumerable<TaskVM> GetTasksByAccount(int accountID)
        {
            var query = from x in _context.Taskmembership
                        join y in _context.Task on x.TaskId equals y.Id
                        where x.AccountId.Equals(accountID)
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

            return query;
        }

        //returns the number of tasks in an account
        public int GetNumberOfTasks(int accountID)
        {
            var query = from x in _context.Taskmembership
                        join y in _context.Task on x.TaskId equals y.Id
                        where x.AccountId.Equals(accountID)
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

            return query.Count();
        }

        //Get tasks by accountID
        public IEnumerable<TaskVM> GetTasksByAccountUser(int accountID, int userID)
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

            return query;
        }

        //Get tasks assigned to a user
        public IEnumerable<TaskVM> GetUserAssignedTasks(int userID)
        {
            var query = from x in _context.Taskmembership
                        join y in _context.Task on x.TaskId equals y.Id
                        where x.UserId.Equals(userID)
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

            return query;
        }

        //Get task by ID
        public Task<Task> GetTask(int id)
        {
            var task = _context.Task.FindAsync(id);
            return task;
        }

        //Get task by OwnerID
        public IEnumerable<Task> GetTaskByOwner(int userID)
        {
            return _context.Task.Where(t => t.OwnerId == userID);
        }

        public async Task<bool> Update(int id, int status)
        {
            var result = await _context.Task.Where(t => t.Id == id).FirstOrDefaultAsync();

            try
            {
                result.Status = status;
                _context.Update(result);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        //Assign a task to a user
        public async Task<bool> AssignToUser(int id, int userID)
        {
            var task = await _context.Task.Where(t => t.Id == id).FirstOrDefaultAsync();

            if (task == null)
            {
                return false;
            }

            var taskMembership = new Taskmembership
            {
                TaskId = task.Id,
                AccountId = task.AccountId,
                UserId = userID,
                OrgId = task.OrgId,
                DateCreated = DateTime.Now,
                DateModified = DateTime.Now,
                Status = 0,
                CreatedBy = task.OwnerId,
                ModifiedBy = task.OwnerId
            };

            try
            {
                _context.Taskmembership.Add(taskMembership);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        //Delete a task (admin only)
        public async Task<bool> Delete(int id)
        {
            var task = await _context.Task.FindAsync(id);

            if (task == null)
            {
                return false;
            }

            try
            {
                _context.Task.Remove(task);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public bool TaskExists(int id)
        {
            return _context.Task.Any(e => e.Id == id);
        }
    }
}
