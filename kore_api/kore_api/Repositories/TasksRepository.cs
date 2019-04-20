using kore_api.koredb;
using kore_api.Repositories.Interfaces;
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

        public koredb.Task GetTask()
        {
            throw new NotImplementedException();
        }

        //// Get all tasks assigned to user
        //public async Task<Taskmembership> GetTasks(int userID)
        //{
        //    var result = await _context.Taskmembership
        //        .Include(i => i.Task)
        //        .Where(i => i.UserId == userID).SingleOrDefaultAsync();

        //    return result;
        //}

        // Get all tasks assigned to user
        public IQueryable<IEnumerable<Taskmembership>> GetTasks(int userID)
        {
            //var result = _context.Taskmembership.Include(w => w.Task)
            //    .Where(i => i.UserId == userID).ToList();
            var result = _context.Task.Include(i => i.Taskmembership).Select(i => i.Taskmembership.Where(p => p.UserId == userID));
            return result;
        }

        public bool UpdateTask()
        {
            throw new NotImplementedException();
        }
    }
}
