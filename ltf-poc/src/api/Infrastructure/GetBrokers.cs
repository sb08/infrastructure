using api.Domain;
using MediatR;

namespace api.Infrastructure
{
    public class GetBrokersQuery : IRequest<List<Broker>>
    {
        public int Take { get; set; } = 10;
    }

    public class GetBrokersQueryHandler : IRequestHandler<GetBrokersQuery, List<Broker>>
    {
        private readonly IBrokerRepository<Broker> _repository;

        public GetBrokersQueryHandler(IBrokerRepository<Broker> repository)
        {
            _repository = repository;
        }

        public async Task<List<Broker>> Handle(GetBrokersQuery request, CancellationToken cancellationToken)
        {
            return await _repository.GetBrokers();
        }
    }
}
