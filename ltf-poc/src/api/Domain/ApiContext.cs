using Microsoft.EntityFrameworkCore;

namespace api.Domain
{
    public class ApiContext : DbContext
    {
        public ApiContext(DbContextOptions<ApiContext> options)
        : base(options)
        {
        }
        //protected override void OnConfiguring (DbContextOptionsBuilder optionsBuilder)
        //{
        //    optionsBuilder.UseInMemoryDatabase(databaseName: "BrokersDb");
        //}
        public DbSet<Broker> Brokers { get; set; }
    }
}
