using System;
using System.Collections.Generic;

namespace Core2Service.Model
{
    public partial class Comments
    {
        public int CommentId { get; set; }
        public int? ParentId { get; set; }
        public int UserId { get; set; }
        public int? CourseId { get; set; }
        public int? ProviderId { get; set; }
        public string CommentType { get; set; }
        public int Rating { get; set; }
        public string Title { get; set; }
        public string Remarks { get; set; }
        public int? StarterCommentId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastUpdate { get; set; }
    }
}
