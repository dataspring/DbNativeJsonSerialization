﻿using System;
using System.Collections.Generic;

namespace Core1dot1Service.Model
{
    public partial class CoursesAlt
    {
        public int CourseId { get; set; }
        public int ProviderId { get; set; }
        public string Description { get; set; }
        public DateTime LastUpdate { get; set; }
    }
}
