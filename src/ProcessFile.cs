using System;
using System.IO;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace Contoso
{
    public class ProcessFile
    {
        [FunctionName("ProcessFile")]
        public void Run([BlobTrigger("documents/{name}", Connection = "StrDocument")]Stream myBlob, string name, ILogger log)
        {
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");
        }
    }
}
