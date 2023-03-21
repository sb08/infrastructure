using api.Domain;
using api.Messages;
using Azure.Messaging.ServiceBus;
using MediatR;
using Microsoft.Extensions.Azure;
using Serilog;
using System.Text.Json;

namespace api.Infrastructure
{
    public class CreateRegistrationCommand : IRequest<Registration>
    {

        public CreateRegistrationCommand(Registration registration)
        {
            Registration = registration;
        }

        public Registration Registration { get; }
    }

    public class CreateRegistrationCommandHandler : IRequestHandler<CreateRegistrationCommand, Registration>
    {
        private readonly IBrokerRepository<Broker> _repository;
        private readonly ServiceBusClient _serviceBusClient;
        private readonly ServiceBusSender _sender;
        const string topic = "registration";

        public CreateRegistrationCommandHandler(IBrokerRepository<Broker> repository, IAzureClientFactory<ServiceBusClient> serviceBusClientFactory)
        {
            _repository = repository;
            _serviceBusClient = serviceBusClientFactory.CreateClient("ltf-servicebus");
            _sender = _serviceBusClient.CreateSender(topic);
        }

        public async Task<Registration> Handle(CreateRegistrationCommand command, CancellationToken cancellationToken)
        {
            Log.Information($"Registration create request recieved. {JsonSerializer.Serialize(command.Registration)}");
            var broker = new Broker(command.Registration.FirstName, command.Registration.LastName, command.Registration.Email, command.Registration.UserType);
            var response = await _repository.AddAsync(broker);
            var m = new ServiceBusMessage(JsonSerializer.Serialize(response));
            await _sender.SendMessageAsync(m, cancellationToken);
            Log.Information($"Broker {broker.LastName} due dilligence messages published.");
            return command.Registration;
        }
    }
}