using System.Text.Json;
using api.Messages;
using Azure.Messaging.ServiceBus;
using Serilog;

namespace api;

public class Worker : BackgroundService
{
    public Worker()
    {
        Log.Information("Service bus processor.");
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        Log.Information("processing service bus messages.");
        var sbConnectionString = Environment.GetEnvironmentVariable("SbConnectionString");
        const string topic = "registration";
        const string subscription = "registration";

        var clientOptions = new ServiceBusClientOptions
        {
            TransportType = ServiceBusTransportType.AmqpWebSockets
        };

        var client = new ServiceBusClient(sbConnectionString, clientOptions);
        var processor = client.CreateProcessor(topic, subscription, new ServiceBusProcessorOptions());
        var sender = client.CreateSender(topic);
        try
        {
            processor.ProcessMessageAsync += MessageHandler;
            processor.ProcessErrorAsync += ErrorHandler;

            await processor.StartProcessingAsync(stoppingToken);
            Thread.Sleep(1000);

            // prefer using processor over receiver: var  receiver = client.CreateReceiver(topic, subscription);
            // while (!stoppingToken.IsCancellationRequested)
            // {
            // var message = await receiver.ReceiveMessageAsync(TimeSpan.FromMilliseconds(10), stoppingToken);
            // await receiver.CompleteMessageAsync(message, stoppingToken);
            // Thread.Sleep(1000);
            // }
        }
        catch (Exception ex)
        {
            Log.Information($"{ex}");
            throw;
        }
        // finally
        // {
        //     await processor.StopProcessingAsync(stoppingToken);
        //     await processor.DisposeAsync();
        //     await client.DisposeAsync();
        // }
    }

    async Task MessageHandler(ProcessMessageEventArgs args)
    {
        var body = args.Message.Body.ToString();
        var r = JsonSerializer.Deserialize<Registration>(body);
        var amqpMessage = args.Message.GetRawAmqpMessage();
        // amqpMessage.Body.TryGetData()

        if (r != null)
        {
            Log.Information($"Received: {r.Email} from registration subscription at {r.Date}.");
            Log.Information($"Message body: {body}");
            Log.Information($"Message body json: {JsonSerializer.Serialize(r)}");
        // business logic & persist to data layer here using DI
        // CompleteMessageAsync method not needed by default
        }
        await args.CompleteMessageAsync(args.Message);
    }

    Task ErrorHandler(ProcessErrorEventArgs args)
    {
        Console.WriteLine(args.Exception.ToString());
        return Task.CompletedTask;
    }
}
