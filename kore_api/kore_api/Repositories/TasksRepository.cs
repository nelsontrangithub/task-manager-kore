using kore_api.koredb;
using kore_api.Repositories.Interfaces;
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

        public Task<Task> GetTask(int id)
        {
            var task = _context.Task.FindAsync(id);
            return task;
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
