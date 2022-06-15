using System;
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.ApplicationInsights.Extensibility;

[assembly: FunctionsStartup(typeof(PagoPA.Startup))]
namespace PagoPA
{
  public class Startup : FunctionsStartup
  {
    public override void Configure(IFunctionsHostBuilder builder)
    {
      builder.Services.AddOptions<Options>()
        .Configure<IConfiguration>((settings, configuration) =>
            {
            configuration.Bind(settings);
            });

      builder.Services.AddSingleton<TelemetryConfiguration>(sp =>
          {
          var telemetryConfiguration = new TelemetryConfiguration();
          telemetryConfiguration.ConnectionString = Environment.GetEnvironmentVariable("APPINSIGHTS_INSTRUMENTATIONKEY");
          telemetryConfiguration.TelemetryChannel = new InMemoryChannel();

          return telemetryConfiguration;
          });
    }
  }
}

