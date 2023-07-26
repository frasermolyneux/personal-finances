using System;
using System.IO;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace PersonalFinances.FuncApp
{
    public class IngestMonzoFromBlob
    {
        private readonly ILogger _logger;

        public IngestMonzoFromBlob(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<IngestMonzoFromBlob>();
        }

        [Function("IngestMonzoFromBlob")]
        public void Run([BlobTrigger("monzo-in/{name}", Connection = "appdata_connectionstring")] string myBlob, string name)
        {
            _logger.LogInformation($"C# Blob trigger function Processed blob\n Name: {name} \n Data: {myBlob}");
        }
    }
}
