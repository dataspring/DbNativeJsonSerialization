using System;
using System.Collections.Generic;

namespace Core1dot1Service.Model
{
    public partial class Users
    {
        public int UserId { get; set; }
        public string DisplayName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public Guid Uuid { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public DateTime LastUpdated { get; set; }
    }
}
