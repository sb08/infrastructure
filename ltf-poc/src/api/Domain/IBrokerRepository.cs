namespace api.Domain
{
    public interface IBrokerRepository<Broker>
    {
        public Task<List<Broker>> GetBrokers();
        Task<Broker> AddAsync(Broker broker);
    }
}