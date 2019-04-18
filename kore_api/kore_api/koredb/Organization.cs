using System;
using System.Collections.Generic;

namespace kore_api.koredb
{
    public partial class Organization
    {
        public Organization()
        {
            Account = new HashSet<Account>();
            Task = new HashSet<Task>();
            Taskdepartment = new HashSet<Taskdepartment>();
            Taskmembership = new HashSet<Taskmembership>();
            Tasktype = new HashSet<Tasktype>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public int? Status { get; set; }
        public int? CreatedBy { get; set; }
        public int? ModifiedBy { get; set; }

        public ICollection<Account> Account { get; set; }
        public ICollection<Task> Task { get; set; }
        public ICollection<Taskdepartment> Taskdepartment { get; set; }
        public ICollection<Taskmembership> Taskmembership { get; set; }
        public ICollection<Tasktype> Tasktype { get; set; }
    }
}
