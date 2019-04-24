using kore_api.koredb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace kore_api.ViewModels
{
    public class TaskVM : Taskmembership
    {
        public int OwnerId { get; set; }
        public int? TaskStatus { get; set; }
        public string Description { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? CompletedOn { get; set; }
        public string Subject { get; set; }
        public int? Department { get; set; }
    }
}
