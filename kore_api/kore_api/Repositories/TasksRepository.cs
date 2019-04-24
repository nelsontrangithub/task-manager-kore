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

        public Task<Task> GetTask(int id)
        {
            var task = _context.Task.FindAsync(id);
            return task;
        }

        public Task<Task> GetTaskByOwner(int userID)
        {
            return _context.Task.Where(t => t.OwnerId == userID).FirstOrDefaultAsync();
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

        public async Task<bool> AssignToUser(int id, int userID)
        {
            var task = await _context.Taskmembership.Where(t => t.Id == id).FirstOrDefaultAsync();

            if (task == null)
            {
                return false;
            }

            try
            {
                task.UserId = userID;
                _context.Update(task);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

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
