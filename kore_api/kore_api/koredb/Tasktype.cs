using System;
using System.Collections.Generic;

namespace kore_api.koredb
{
    public partial class Tasktype
    {
        public int Id { get; set; }
        public int OrgId { get; set; }
        public string Name { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public int? CreatedBy { get; set; }
        public int? ModifiedBy { get; set; }

        public Organization Org { get; set; }
    }
}
