using System;
using System.Collections.Generic;

namespace Core1dot1Service.Model
{
    public partial class CommentSnapShots
    {
        public int SnapShotId { get; set; }
        public int CourseId { get; set; }
        public int UserId { get; set; }
        public string CommentType { get; set; }
        public int FirstCommentId { get; set; }
        public string FirstTitle { get; set; }
        public string FirstRemarks { get; set; }
        public int FirstRating { get; set; }
        public int LastCommentId { get; set; }
        public string LastTitle { get; set; }
        public string LastRemarks { get; set; }
        public int LastRating { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastUpdate { get; set; }
    }
}
