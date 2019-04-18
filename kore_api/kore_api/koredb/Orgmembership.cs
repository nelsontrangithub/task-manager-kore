using System;
using System.Collections.Generic;

namespace kore_api.koredb
{
    public partial class Orgmembership
    {
        public int UserId { get; set; }
        public int OrgId { get; set; }
        public int Enabled { get; set; }
        public DateTime JoinedOn { get; set; }
        public DateTime? DateCreated { get; set; }
        public DateTime? DateModified { get; set; }
        public int? CreatedBy { get; set; }
        public int? ModifiedBy { get; set; }

        public Organization Org { get; set; }
        public User User { get; set; }
    }
}
