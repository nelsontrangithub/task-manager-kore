using System;
using System.Collections.Generic;

namespace kore_api.koredb
{
    public partial class Taskmembership
    {
        public int Id { get; set; }
        public int TaskId { get; set; }
        public int? AccountId { get; set; }
        public int? UserId { get; set; }
        public int? OrgId { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public int? Status { get; set; }
        public int? CreatedBy { get; set; }
        public int? ModifiedBy { get; set; }

        public Account Account { get; set; }
        public Organization Org { get; set; }
        public Task Task { get; set; }
        public User User { get; set; }
    }
}
