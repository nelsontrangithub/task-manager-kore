﻿using kore_api.koredb;
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

        public Task<bool> FileExists(string id)
        {
            throw new NotImplementedException();
        }

        public Task<File> GetFile(string id)
        {
            return _context.File.FindAsync(id);
        }

        public IEnumerable<File> GetFiles()
        {
            return _context.File;
        }

        public async Task<bool> Update(string id, File file)
        {
            if (id != file.FileId)
            {
                return false;
            }

            _context.Entry(file).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                return false;
            }
            return false;
        }
    }
}