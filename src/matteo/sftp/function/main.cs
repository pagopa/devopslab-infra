using System;
using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.ApplicationInsights.Extensibility;

namespace PagoPA
{
  public class SftpStressTest
  {
    private readonly Options _options;
    private readonly ILogger<SftpStressTest> _log;
    private readonly TelemetryClient _telemetryClient;

    public SftpStressTest(IOptions<Options> options, ILogger<SftpStressTest> log, TelemetryConfiguration telemetryConfiguration)
    {
      log.LogDebug("[DEBUG] Init function..");
      _options = options.Value;
      _log = log;
      _telemetryClient = new TelemetryClient(telemetryConfiguration);
    }

    [FunctionName("SftpStressTest")]
    public async Task Run([TimerTrigger("%TIME_TRIGGER%")]TimerInfo timer, ExecutionContext executionContext)
    {
      _log.LogDebug("[DEBUG] Init telemetry context..");
      var availability = new AvailabilityTelemetry
      {
        Name = executionContext.FunctionName,
        RunLocation = _options.Region,
        Success = false,
      };

      availability.Context.Operation.ParentId = Activity.Current.SpanId.ToString();
      availability.Context.Operation.Id = Activity.Current.RootId;

      _log.LogDebug("[DEBUG] Start stopwatch..");
      var stopwatch = new Stopwatch();
      stopwatch.Start();

      try
      {
        using (var activity = new Activity("AvailabilityContext"))
        {
          activity.Start();
          availability.Id = Activity.Current.SpanId.ToString();

          _log.LogDebug("[DEBUG] Run business logic..");
          var test = new Test(1024L * 1024 * int.Parse(_options.FileSizeInMb));
          await test.RunAsync(_options, _log);
        }

        _log.LogInformation("[INFO] Success..");
        availability.Success = true;
      }
      catch (Exception ex)
      {
        _log.LogInformation("[INFO] Fail..");
        availability.Message = ex.Message;
        throw;
      }
      finally
      {
        _log.LogDebug("[DEBUG] Stop stopwatch..");
        stopwatch.Stop();

        _log.LogDebug("[DEBUG] Clean environment..");
        availability.Duration = stopwatch.Elapsed;
        availability.Timestamp = DateTimeOffset.UtcNow;
        _telemetryClient.TrackAvailability(availability);
        _telemetryClient.Flush();
      }
    }
  }
}
