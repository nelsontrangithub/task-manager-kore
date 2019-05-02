using kore_api.koredb;
using kore_api.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace kore_api.Repositories
{
    public class FilesRepository : IFilesRepository
    {
        private readonly koredbContext _context;

        public FilesRepository(koredbContext context)
        {
            _context = context;
        }

        public async Task<bool> Create(File file)
        {
            _context.File.Add(file);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                return false;
            }
            return true;
        }

        public async Task<File> Delete(string id)
        {
            var file = await _context.File.FindAsync(id);
            _context.File.Remove(file);
            await _context.SaveChangesAsync();
            return file;
        }

        public bool FileExists(string id)
        {
            if (_context.File.Where(f => f.FileId == id).FirstOrDefault() != null)
            {
                return true;
            }
            return false;
        }

        public Task<File> GetFile(string id)
        {
            return _context.File.FindAsync(id);
        }

        public IEnumerable<File> GetFiles()
        {
            return _context.File;
        }

        public IEnumerable<File> GetFilesByTaskId(string taskId)
        {
            return _context.File.Where(f => f.TaskId == taskId);
        }

        public async Task<bool> Update(string id, File file)
        {
            if (id != file.FileId)
            {
                return false;
            }

            //_context.Entry(file).State = EntityState.Modified;

            var _file = _context.File.Where(f => f.FileId == id).FirstOrDefault();
            _file.Title = file.Title;

            _context.File.Update(_file);

            try
            {
                await _context.SaveChangesAsync();
                return true;
            }
            catch (DbUpdateConcurrencyException)
            {
                return false;
            }
        }
    }
}
