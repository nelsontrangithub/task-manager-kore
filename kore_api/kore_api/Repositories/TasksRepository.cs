using kore_api.koredb;
using kore_api.Repositories.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace kore_api.Repositories
{
    public class TasksRepository : ITasksRepository
    {
        public koredb.Task GetTask()
        {
            throw new NotImplementedException();
        }

        public IEnumerable<koredb.Task> GetTasks()
        {
            throw new NotImplementedException();
        }

        public bool UpdateTask()
        {
            throw new NotImplementedException();
        }
    }
}
