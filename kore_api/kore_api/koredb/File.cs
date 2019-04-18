using System;
using System.Collections.Generic;

namespace kore_api.koredb
{
    public partial class File
    {
        public string FileId { get; set; }
        public string AccountId { get; set; }
        public string TaskId { get; set; }
        public string Title { get; set; }
        public string MimeType { get; set; }
        public int? Size { get; set; }
        public string FileName { get; set; }
        public string Location { get; set; }
        public string FileKey { get; set; }
        public string Url { get; set; }
        public int? Status { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public string CreatedBy { get; set; }
        public int? CreatedById { get; set; }
    }
}
