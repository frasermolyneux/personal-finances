using Microsoft.AspNetCore.Mvc;

using PersonalFinances.Abstractions;

namespace PersonalFinances.WebApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ClientConfigurationController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public ClientConfigurationController(IConfiguration configuration)
        {
            this.configuration = configuration;
        }

        [HttpGet]
        public async Task<ClientConfiguration> Get()
        {
            return new ClientConfiguration
            {
                ClientAzureAd = new ClientConfiguration.AzureAd
                {
                    ClientId = configuration["ClientAzureAd:ClientId"],
                    Authority = configuration["ClientAzureAd:Authority"]
                },
                ClientServerApi = new ClientConfiguration.ServerApi
                {
                    BaseUrl = configuration["ClientServerApi:BaseUrl"],
                    Scopes = configuration["ClientServerApi:Scopes"]
                }
            };
        }
    }
}