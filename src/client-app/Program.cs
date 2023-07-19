using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Authentication;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;

namespace PersonalFinances.ClientApp
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            var builder = WebAssemblyHostBuilder.CreateDefault(args);
            builder.RootComponents.Add<App>("#app");
            builder.RootComponents.Add<HeadOutlet>("head::after");

            var client = new HttpClient { BaseAddress = new Uri(builder.HostEnvironment.BaseAddress) };
            var response = await client.GetAsync("/ClientConfiguration");
            builder.Configuration.AddJsonStream(response.Content.ReadAsStream());

            builder.Services.AddHttpClient("PersonalFinances.ServerAPI", client => client.BaseAddress = new Uri(builder.HostEnvironment.BaseAddress))
                .AddHttpMessageHandler<BaseAddressAuthorizationMessageHandler>();

            // Supply HttpClient instances that include access tokens when making requests to the server project
            builder.Services.AddScoped(sp => sp.GetRequiredService<IHttpClientFactory>().CreateClient("PersonalFinances.ServerAPI"));

            var foo = builder.Configuration.GetSection("ClientServerApi");

            builder.Services.AddMsalAuthentication(options =>
            {
                builder.Configuration.Bind("ClientAzureAd", options.ProviderOptions.Authentication);
                options.ProviderOptions.DefaultAccessTokenScopes.Add(builder.Configuration.GetSection("ClientServerApi")["Scopes"]);
            });



            await builder.Build().RunAsync();
        }
    }
}