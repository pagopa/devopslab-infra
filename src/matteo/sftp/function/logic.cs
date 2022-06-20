using System;
using System.IO;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.Runtime.Serialization;
using Microsoft.Extensions.Logging;
using Renci.SshNet;

namespace PagoPA
{
  public class Test
  {
    private long filesize;
    private string filename;
    private Random rnd;

    private FileStream uploadFs;
    private FileStream downloadFs;
    private string uploadChecksum;
    private string downloadChecksum;

    public Test(long filesize)
    {
      DateTimeOffset now = (DateTimeOffset)DateTime.UtcNow;

      this.filesize = filesize;
      this.filename = now.ToString("yyyyMMddHHmmssfff");
      this.rnd = new Random();
    }

    public async Task RunAsync(Options options, ILogger log)
    {
      using (var sha = SHA256.Create())
      {
        using (uploadFs = new FileStream(Path.GetTempFileName(), FileMode.Create))
        {
          CreateDummyFile(uploadFs, filesize);
          uploadChecksum = GetHash(sha, uploadFs, log);

          var connectionInfo = new ConnectionInfo(
              options.SftpHost,
              options.SftpUsername,
              new PasswordAuthenticationMethod(options.SftpUsername, options.SftpPassword)
          );
          // new PrivateKeyAuthenticationMethod("rsa.key"));

          uploadFs.Position = 0;
          using (var client = new SftpClient(connectionInfo))
          {
            log.LogDebug("[DEBUG] Connecting via SFTP..");
            client.Connect();
            log.LogDebug($"[DEBUG] Uploading {filename} file..");
            client.UploadFile(uploadFs, filename);
            log.LogDebug($"[DEBUG] Downloading {filename} file..");

            using (downloadFs = new FileStream(Path.GetTempFileName(), FileMode.Create))
            {
              client.DownloadFile(filename, downloadFs);

              downloadChecksum = GetHash(sha, downloadFs, log);

              downloadFs.Close();
              uploadFs.Close();
            }

            client.Disconnect();
          }
        }
      }

      if (uploadChecksum != downloadChecksum)
      {
        throw new CorruptedFileException();
      }
    }

    private void CreateDummyFile(FileStream fs, long size)
    {
      fs.Seek(size, SeekOrigin.Begin);
      byte[] vals = new byte[1];
      rnd.NextBytes(vals);
      fs.WriteByte(vals[0]);
    }

    private string GetHash(SHA256 client, FileStream file, ILogger log)
    {
      file.Position = 0;
      byte[] hashBytes = client.ComputeHash(file);
      var hash = BitConverter.ToString(hashBytes).Replace("-", String.Empty);

      log.LogInformation($"[INFO] Checksum: {hash}");

      return hash;
    }
  }

  [Serializable()]
  public class CorruptedFileException : Exception
  {
    public CorruptedFileException() : base() {}
  }
}
