namespace PersonalFinances.Abstractions
{
    public class ClientConfiguration
    {
        public AzureAd ClientAzureAd { get; set; } = new AzureAd();
        public ServerApi ClientServerApi { get; set; } = new ServerApi();

        public class AzureAd
        {
            public string ClientId { get; set; }
            public string Authority { get; set; }
        }

        public class ServerApi
        {
            public string BaseUrl { get; set; }
            public string Scopes { get; set; }
        }
    }
}