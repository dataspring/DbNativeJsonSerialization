using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Core1dot1Service.Options;
using Microsoft.Extensions.Configuration;

namespace Core1dot1Service.Model
{
    public partial class CommentContext : DbContext
    {
        //private readonly ConnectionConfig _connectionString;
        private readonly string _connectionString;

        public virtual DbSet<CommentSnapShots> CommentSnapShots { get; set; }
        public virtual DbSet<Comments> Comments { get; set; }
        public virtual DbSet<CoursesAlt> Courses { get; set; }
        public virtual DbSet<Users> Users { get; set; }

        public CommentContext(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("DefaultConnection");
        }


        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
            // warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
            optionsBuilder.UseSqlServer(_connectionString);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            modelBuilder.Entity<CommentSnapShots>(entity =>
            {
                entity.HasKey(e => e.SnapShotId)
                    .HasName("PK_CommentSnapShot");

                entity.Property(e => e.CommentType)
                    .IsRequired()
                    .HasMaxLength(20);

                entity.Property(e => e.CreatedDate).HasDefaultValueSql("getdate()");

                entity.Property(e => e.FirstRemarks).HasMaxLength(2048);

                entity.Property(e => e.FirstTitle).HasMaxLength(256);

                entity.Property(e => e.LastRemarks).HasMaxLength(2048);

                entity.Property(e => e.LastTitle).HasMaxLength(256);

                entity.Property(e => e.LastUpdate).HasDefaultValueSql("getdate()");
            });

            modelBuilder.Entity<Comments>(entity =>
            {
                entity.HasKey(e => e.CommentId)
                    .HasName("PK_Comments");

                entity.Property(e => e.CommentType)
                    .IsRequired()
                    .HasMaxLength(20);

                entity.Property(e => e.CreatedDate).HasDefaultValueSql("getdate()");

                entity.Property(e => e.LastUpdate).HasDefaultValueSql("getdate()");

                entity.Property(e => e.Remarks).HasMaxLength(2048);

                entity.Property(e => e.Title).HasMaxLength(256);
            });

            modelBuilder.Entity<CoursesAlt>(entity =>
            {
                entity.HasKey(e => e.CourseId)
                    .HasName("PK_CoursesAlt");

                entity.Property(e => e.Description).HasMaxLength(256);

                entity.Property(e => e.LastUpdate).HasColumnType("datetime");
            });

            modelBuilder.Entity<Users>(entity =>
            {
                entity.HasKey(e => e.UserId)
                    .HasName("PK_dbo.Users");

                entity.HasIndex(e => e.UserName)
                    .HasName("UserNameIndex")
                    .IsUnique();

                entity.Property(e => e.DisplayName).HasMaxLength(100);

                entity.Property(e => e.Email).HasMaxLength(256);

                entity.Property(e => e.FirstName).HasMaxLength(100);

                entity.Property(e => e.LastName).HasMaxLength(100);

                entity.Property(e => e.LastUpdated).HasColumnType("datetime");

                entity.Property(e => e.UserName)
                    .IsRequired()
                    .HasMaxLength(256);
            });

        }
    }
}