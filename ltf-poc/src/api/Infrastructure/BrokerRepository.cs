using api.Domain;
using api.Messages;
using Microsoft.EntityFrameworkCore;
using Serilog;
using System.Reflection.Metadata.Ecma335;

namespace api.Infrastructure
{

    public class BrokerRepository : IBrokerRepository<Broker>
    {
        private readonly ApiContext _dbContext;

        public BrokerRepository(ApiContext dbContext)
        {
            _dbContext = dbContext;
        }
        public async Task<Broker> AddAsync(Broker broker)
        {
            _dbContext.Brokers.Add(broker);
            await _dbContext.SaveChangesAsync();
            Log.Information($"Broker {broker.LastName} persisted (Id {broker.Id})");
            return broker;
        }

        public async Task<List<Broker>> GetBrokers()
        {
            return await _dbContext.Brokers.ToListAsync();
        }
    }
}