using System;
using System.Collections.Generic;

namespace kore_api.koredb
{
    public partial class User
    {
        public User()
        {
            Orgmembership = new HashSet<Orgmembership>();
            Task = new HashSet<Task>();
            Taskmembership = new HashSet<Taskmembership>();
        }

        public int Id { get; set; }
        public string Email { get; set; }
        public string Name { get; set; }
        public string IconFileUrl { get; set; }
        public string IconFileId { get; set; }
        public DateTime? LastLogin { get; set; }
        public DateTime DateCreated { get; set; }
        public int? Status { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Sid { get; set; }

        public ICollection<Orgmembership> Orgmembership { get; set; }
        public ICollection<Task> Task { get; set; }
        public ICollection<Taskmembership> Taskmembership { get; set; }
    }
}
