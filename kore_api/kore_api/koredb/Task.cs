using System;
using System.Collections.Generic;

namespace kore_api.koredb
{
    public partial class Task
    {
        public Task()
        {
            Taskmembership = new HashSet<Taskmembership>();
        }

        public int Id { get; set; }
        public int OwnerId { get; set; }
        public int? AccountId { get; set; }
        public int? OrgId { get; set; }
        public string Subject { get; set; }
        public int? TaskType { get; set; }
        public int? Department { get; set; }
        public string Description { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? CompletedOn { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public int? Status { get; set; }
        public int? CreatedBy { get; set; }
        public int? ModifiedBy { get; set; }

        public Account Account { get; set; }
        public Organization Org { get; set; }
        public User Owner { get; set; }
        public ICollection<Taskmembership> Taskmembership { get; set; }
    }
}
