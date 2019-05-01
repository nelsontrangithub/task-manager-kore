using kore_api.koredb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace kore_api.Repositories.Interfaces
{
    public interface IFilesRepository
    {
        IEnumerable<File> GetFiles();
        Task<File> GetFile(string id);
        IEnumerable<File> GetFilesByTaskId(string taskId);
        Task<bool> Create(File file);
        Task<bool> Update(string id, File file);
        Task<File> Delete(string id);
        Task<bool> FileExists(string id);
    }
}
