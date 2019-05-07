using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace kore_api.koredb
{
    public partial class koredbContext : DbContext
    {
        public koredbContext()
        {
        }

        public koredbContext(DbContextOptions<koredbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Account> Account { get; set; }
        public virtual DbSet<File> File { get; set; }
        public virtual DbSet<Organization> Organization { get; set; }
        public virtual DbSet<Orgmembership> Orgmembership { get; set; }
        public virtual DbSet<Task> Task { get; set; }
        public virtual DbSet<Taskdepartment> Taskdepartment { get; set; }
        public virtual DbSet<Taskmembership> Taskmembership { get; set; }
        public virtual DbSet<Tasktype> Tasktype { get; set; }
        public virtual DbSet<User> User { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                string ConnectionString = null;
                if (Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Development")
                {
                    ConnectionString = "server=localhost;port=3306;user=root;password=password;database=koredb";
                }
                else if (Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Production")
                {
                    ConnectionString = "server=koretaskmanagerrdsmysqlinstance.cya4cpibjenz.us-east-2.rds.amazonaws.com;port=3306;user=koreadmin;password=koressd2019;database=koredb";
                }
                if(ConnectionString != null)
                    optionsBuilder.UseMySQL(ConnectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Account>(entity =>
            {
                entity.ToTable("account", "koredb");

                entity.HasIndex(e => e.OrgId)
                    .HasName("FK_Organization_Account");

                entity.Property(e => e.Id).HasColumnType("int(11)");

                entity.Property(e => e.AccountName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedBy).HasColumnType("int(11)");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.Description)
                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.ModifiedBy).HasColumnType("int(11)");

                entity.Property(e => e.OrgId).HasColumnType("int(11)");

                entity.Property(e => e.Status).HasColumnType("int(11)");

                entity.HasOne(d => d.Org)
                    .WithMany(p => p.Account)
                    .HasForeignKey(d => d.OrgId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Organization_Account");
            });

            modelBuilder.Entity<File>(entity =>
            {
                entity.ToTable("file", "koredb");

                entity.Property(e => e.FileId)
                    .HasMaxLength(50)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.AccountId)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedBy)
                    .HasMaxLength(200)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedById).HasColumnType("int(11)");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.FileKey)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.FileName)
                    .HasMaxLength(200)
                    .IsUnicode(false);

                entity.Property(e => e.Location)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.MimeType)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Size).HasColumnType("int(11)");

                entity.Property(e => e.Status).HasColumnType("int(11)");

                entity.Property(e => e.TaskId)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Title)
                    .HasMaxLength(200)
                    .IsUnicode(false);

                entity.Property(e => e.Url)
                    .HasMaxLength(200)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Organization>(entity =>
            {
                entity.ToTable("organization", "koredb");

                entity.Property(e => e.Id).HasColumnType("int(11)");

                entity.Property(e => e.CreatedBy).HasColumnType("int(11)");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.ModifiedBy).HasColumnType("int(11)");

                entity.Property(e => e.Name)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Status).HasColumnType("int(11)");
            });

            modelBuilder.Entity<Orgmembership>(entity =>
            {
                entity.HasKey(e => new { e.UserId, e.OrgId });

                entity.ToTable("orgmembership", "koredb");

                entity.HasIndex(e => e.UserId)
                    .HasName("FK_User_Membership_idx");

                entity.HasIndex(e => new { e.OrgId, e.UserId })
                    .HasName("OrgId_UserId_UNIQUE")
                    .IsUnique();

                entity.Property(e => e.UserId).HasColumnType("int(11)");

                entity.Property(e => e.OrgId).HasColumnType("int(11)");

                entity.Property(e => e.CreatedBy).HasColumnType("int(11)");

                entity.Property(e => e.Enabled)
                    .HasColumnType("int(1)")
                    .HasDefaultValueSql("1");

                entity.Property(e => e.JoinedOn).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.ModifiedBy).HasColumnType("int(11)");

                entity.HasOne(d => d.Org)
                    .WithMany(p => p.Orgmembership)
                    .HasForeignKey(d => d.OrgId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Organization_Membership");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Orgmembership)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_User_Membership");
            });

            modelBuilder.Entity<Task>(entity =>
            {
                entity.ToTable("task", "koredb");

                entity.HasIndex(e => e.AccountId)
                    .HasName("FK_Account_Task_idx");

                entity.HasIndex(e => e.OrgId)
                    .HasName("FK_Organization_Task");

                entity.HasIndex(e => e.OwnerId)
                    .HasName("FK_User_Task_idx");

                entity.Property(e => e.Id).HasColumnType("int(11)");

                entity.Property(e => e.AccountId).HasColumnType("int(11)");

                entity.Property(e => e.CreatedBy).HasColumnType("int(11)");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.Department).HasColumnType("int(11)");

                entity.Property(e => e.Description)
                    .HasMaxLength(500)
                    .IsUnicode(false);

                entity.Property(e => e.ModifiedBy).HasColumnType("int(11)");

                entity.Property(e => e.OrgId).HasColumnType("int(11)");

                entity.Property(e => e.OwnerId).HasColumnType("int(11)");

                entity.Property(e => e.Status).HasColumnType("int(11)");

                entity.Property(e => e.Subject)
                    .HasMaxLength(200)
                    .IsUnicode(false);

                entity.Property(e => e.TaskType).HasColumnType("int(11)");

                entity.HasOne(d => d.Account)
                    .WithMany(p => p.Task)
                    .HasForeignKey(d => d.AccountId)
                    .HasConstraintName("FK_Account_Task");

                entity.HasOne(d => d.Org)
                    .WithMany(p => p.Task)
                    .HasForeignKey(d => d.OrgId)
                    .HasConstraintName("FK_Organization_Task");

                entity.HasOne(d => d.Owner)
                    .WithMany(p => p.Task)
                    .HasForeignKey(d => d.OwnerId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_User_Task");
            });

            modelBuilder.Entity<Taskdepartment>(entity =>
            {
                entity.ToTable("taskdepartment", "koredb");

                entity.HasIndex(e => new { e.OrgId, e.DepartmentName })
                    .HasName("idx_taskdepartment_unique_orgid_department")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnType("int(11)");

                entity.Property(e => e.CreatedBy).HasColumnType("int(11)");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DepartmentName)
                    .IsRequired()
                    .HasMaxLength(120)
                    .IsUnicode(false);

                entity.Property(e => e.ModifiedBy).HasColumnType("int(11)");

                entity.Property(e => e.OrgId).HasColumnType("int(11)");

                entity.HasOne(d => d.Org)
                    .WithMany(p => p.Taskdepartment)
                    .HasForeignKey(d => d.OrgId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Organization_TaskDepartment");
            });

            modelBuilder.Entity<Taskmembership>(entity =>
            {
                entity.ToTable("taskmembership", "koredb");

                entity.HasIndex(e => e.AccountId)
                    .HasName("FK_Account_TaskMembership_idx");

                entity.HasIndex(e => e.OrgId)
                    .HasName("FK_Organization_TaskMembership");

                entity.HasIndex(e => e.UserId)
                    .HasName("FK_User_TaskMembership_idx");

                entity.HasIndex(e => new { e.TaskId, e.UserId })
                    .HasName("UNIQUE_TaskId_UserId")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnType("int(11)");

                entity.Property(e => e.AccountId).HasColumnType("int(11)");

                entity.Property(e => e.CreatedBy).HasColumnType("int(11)");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.ModifiedBy).HasColumnType("int(11)");

                entity.Property(e => e.OrgId).HasColumnType("int(11)");

                entity.Property(e => e.Status).HasColumnType("int(11)");

                entity.Property(e => e.TaskId).HasColumnType("int(11)");

                entity.Property(e => e.UserId).HasColumnType("int(11)");

                entity.HasOne(d => d.Account)
                    .WithMany(p => p.Taskmembership)
                    .HasForeignKey(d => d.AccountId)
                    .HasConstraintName("FK_Account_TaskMembership");

                entity.HasOne(d => d.Org)
                    .WithMany(p => p.Taskmembership)
                    .HasForeignKey(d => d.OrgId)
                    .HasConstraintName("FK_Organization_TaskMembership");

                entity.HasOne(d => d.Task)
                    .WithMany(p => p.Taskmembership)
                    .HasForeignKey(d => d.TaskId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Task_TaskMembership");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Taskmembership)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK_User_TaskMembership");
            });

            modelBuilder.Entity<Tasktype>(entity =>
            {
                entity.ToTable("tasktype", "koredb");

                entity.HasIndex(e => new { e.OrgId, e.Name })
                    .HasName("idx_tasktype_unique_orgid_tasktype")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnType("int(11)");

                entity.Property(e => e.CreatedBy).HasColumnType("int(11)");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.DateModified).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.ModifiedBy).HasColumnType("int(11)");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(120)
                    .IsUnicode(false);

                entity.Property(e => e.OrgId).HasColumnType("int(11)");

                entity.HasOne(d => d.Org)
                    .WithMany(p => p.Tasktype)
                    .HasForeignKey(d => d.OrgId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Organization_tasktype");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("user", "koredb");

                entity.HasIndex(e => e.Sid)
                    .HasName("SID_UNIQUE")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnType("int(11)");

                entity.Property(e => e.DateCreated).HasDefaultValueSql("CURRENT_TIMESTAMP");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(256)
                    .IsUnicode(false);

                entity.Property(e => e.FirstName)
                    .IsRequired()
                    .HasMaxLength(256)
                    .IsUnicode(false);

                entity.Property(e => e.IconFileId)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.IconFileUrl)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(256)
                    .IsUnicode(false);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(256)
                    .IsUnicode(false);

                entity.Property(e => e.Sid)
                    .HasColumnName("SID")
                    .HasMaxLength(36)
                    .IsUnicode(false);

                entity.Property(e => e.Status).HasColumnType("int(11)");
            });
        }
    }
}
