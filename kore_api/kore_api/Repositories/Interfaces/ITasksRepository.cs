using kore_api.koredb;
using kore_api.ViewModels;
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
        IEnumerable<TaskVM> GetTaskMemberships();
        IEnumerable<TaskVM> GetTasksByAccount(int accountID);
        IEnumerable<TaskVM> GetUserAssignedTasks(int userID);
        Task<Task> GetTask(int id);
        IEnumerable<Task> GetTaskByOwner(int userID);
        Task<bool> AssignToUser(int id, int userID);
        Task<bool> Update(int id, int status);
        Task<bool> Delete(int id);
        bool TaskExists(int id);
    }
}
