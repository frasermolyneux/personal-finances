using System;
using System.IO;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace PersonalFinances.FuncApp
{
    public class IngestBarclaysFromBlob
    {
        private readonly ILogger _logger;

        public IngestBarclaysFromBlob(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<IngestBarclaysFromBlob>();
        }

        [Function("IngestBarclaysFromBlob")]
        public void Run([BlobTrigger("barclays-in/{name}", Connection = "appdata_connectionstring")] string myBlob, string name)
        {
            _logger.LogInformation($"C# Blob trigger function Processed blob\n Name: {name} \n Data: {myBlob}");
        }
    }
}
