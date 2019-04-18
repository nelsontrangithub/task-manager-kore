using System;
using System.Collections.Generic;

namespace kore_api.koredb
{
    public partial class Account
    {
        public Account()
        {
            Task = new HashSet<Task>();
            Taskmembership = new HashSet<Taskmembership>();
        }

        public int Id { get; set; }
        public int OrgId { get; set; }
        public string AccountName { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public int? Status { get; set; }
        public string Description { get; set; }
        public int? CreatedBy { get; set; }
        public int? ModifiedBy { get; set; }

        public Organization Org { get; set; }
        public ICollection<Task> Task { get; set; }
        public ICollection<Taskmembership> Taskmembership { get; set; }
    }
}
