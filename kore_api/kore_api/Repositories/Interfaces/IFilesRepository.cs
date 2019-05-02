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
<<<<<<< HEAD
        Task<bool> FileExists(string id);

=======
        bool FileExists(string id);
>>>>>>> 233f602f7aa169b4fe4ba2c28b49dc0cc155d514
    }


}
