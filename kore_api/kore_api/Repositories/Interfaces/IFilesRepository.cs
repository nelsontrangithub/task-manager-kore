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
<<<<<<< HEAD

        IEnumerable<File> GetFilesByTaskId(string taskId);

=======
        IEnumerable<File> GetFilesByTaskId(string taskId);
>>>>>>> 07db628f7b63e81c48d9007fbfbf4dfd42527ffa
        Task<bool> Create(File file);
        Task<bool> Update(string id, File file);
        Task<File> Delete(string id);
        Task<bool> FileExists(string id);

    }


}
