using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using kore_api.koredb;
using kore_api.Repositories.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace kore_api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class FilesController : ControllerBase
    {
        private readonly IFilesRepository _filesRepository;

        public FilesController(IFilesRepository filesRepository)
        {
            _filesRepository = filesRepository;
        }


        // GET: api/Files
        [HttpGet]
        [Authorize(Policy = "IsAdminOrAgent")]
        public IEnumerable<File> GetFile()
        {
            return _filesRepository.GetFiles();
        }

        // GET: api/Files/task/7
        [HttpGet("task/{taskId}")]
        [Authorize(Policy = "IsAdminOrAgent")]
        public IEnumerable<File> GetFilesByTaskId(string taskId)
        {
            return _filesRepository.GetFilesByTaskId(taskId);
        }

        // GET: api/Files/5
        [HttpGet("{id}")]
        [Authorize(Policy = "IsAdminOrAgent")]
        public async Task<IActionResult> GetFile([FromRoute] string id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var file = await _filesRepository.GetFile(id);

            if (file == null)
            {
                return NotFound();
            }

            return Ok(file);
        }

        // PUT: api/Files/5
        [HttpPut("{id}")]
        [Authorize(Policy = "IsAdminOrAgent")]
        public async Task<IActionResult> PutFile([FromRoute] string id, [FromBody] File file)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _filesRepository.Update(id, file);

            if (result == true)
            {
                return Ok(result);
            }

            return NoContent();
        }

        // POST: api/Files
        [HttpPost]
        [Authorize(Policy = "IsAdminOrAgent")]
        public async Task<IActionResult> PostFile([FromBody] File file)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }


            if (_filesRepository.FileExists(file.FileId))
            {
                var result = await _filesRepository.Update(file.FileId, file);
                if (result == true)
                {
                    return Ok(file);
                }
            }
            else
            {
                var result = await _filesRepository.Create(file);
                if (result == true)
                {
                    return CreatedAtAction("GetFile", new { id = file.FileId }, file);
                }
            }
            

            return new StatusCodeResult(StatusCodes.Status409Conflict);
        }

        // DELETE: api/Files/5
        [HttpDelete("{id}")]
        [Authorize(Policy = "IsAdminOrAgent")]
        public async Task<IActionResult> DeleteFile([FromRoute] string id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _filesRepository.Delete(id);
            if (result == null)
            {
                return NotFound();
            }

            return Ok(result);
        }
    }
}