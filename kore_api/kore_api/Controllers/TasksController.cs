using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using kore_api.Repositories.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Task = kore_api.koredb.Task;

namespace kore_api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class TasksController : Controller
    {
        private readonly ITasksRepository _tasksRepository;

        public TasksController(ITasksRepository tasksRepository)
        {
            _tasksRepository = tasksRepository;
        }

        // GET: api/Tasks
        [HttpGet]
		[Authorize(Policy = "IsAdminOrAgent")]
		public IEnumerable<Task> GetTasks()
        {
            return _tasksRepository.GetTasks();
        }

        //GET: api/Tasks/user/5
        [HttpGet("user/{id}")]
        [Authorize(Policy = "IsAdminOrAgent")]
        public IActionResult GetUserAssignedTasks([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = _tasksRepository.GetUserAssignedTasks(id);

            if (result == null)
            {
                return NotFound();
            }

            return Ok(result);
        }


        // GET: api/Tasks/5
        [HttpGet("{id}")]
		[Authorize(Policy = "IsAdminOrAgent")]
		public async Task<IActionResult> GetTask([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var task = await _tasksRepository.GetTask(id);

            if (task == null)
            {
                return NotFound();
            }

            return Ok(task);
        }

        // PUT: api/Tasks/5
        [HttpPut("{id}")]
		[Authorize(Policy = "IsAdminOrAgent")]
		public async Task<IActionResult> PutTask([FromRoute] int id, [FromBody] int status)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _tasksRepository.Update(id, status);

            if (result == true)
            {
                return Ok(result);
            }

            return NoContent();
        }

        // PUT: api/Tasks/5
        [HttpPut("user/{id}")]
        [Authorize(Policy = "IsAdmin")]
        public async Task<IActionResult> AssignTask([FromRoute] int id, [FromBody] int userID)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _tasksRepository.AssignToUser(id, userID);

            if (result == true)
            {
                return Ok(result);
            }

            return NoContent();
        }

        // DELETE: api/Tasks/5
        //Admin only
        [HttpDelete("{id}")]
		[Authorize(Policy = "IsAdmin")]
		public async Task<IActionResult> DeleteTask([FromRoute] int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _tasksRepository.Delete(id);

            return Ok(result);
        }
    }
}