using kore_api.koredb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Task = kore_api.koredb.Task;

namespace kore_api.Repositories.Interfaces
{
    public interface ITasksRepository
    {
        IEnumerable<Task> GetTasks();
        Task GetTask();
        bool UpdateTask();
    }
}
