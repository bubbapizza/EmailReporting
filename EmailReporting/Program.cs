using EmailReporting;
using EmailReporting.Data;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Configuration;

namespace EmailReporting
{
    class Program
    {

        private ReportBuilder Builder { get; }
        public Program(ReportBuilder builder)
        {
            Builder = builder;
        }

        public void Run(string[] args)
        {
            try
            {
                var membershipReport = Builder.GetMembershipReportHtml();
                Console.WriteLine(membershipReport);
                EmailHelper.SendToDirectors("Membership Status Report", membershipReport);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                EmailHelper.SendError(ex);
            }
        }

        #region boilerplate
        static void Main(string[] args)
        {
            var host = CreateHostBuilder(args).Build();
            host.Services.GetRequiredService<Program>().Run(args);
        }
        public static IHostBuilder CreateHostBuilder(string[] args)
        {
            string projectPath = AppDomain.CurrentDomain.BaseDirectory.Split(new String[] { @"bin\" }, StringSplitOptions.None)[0];

            IConfigurationRoot configuration = new ConfigurationBuilder()
               .SetBasePath(projectPath)
               .AddJsonFile("appsettings.json")
               .Build();
            string connectionString = configuration.GetConnectionString("DefaultConnection");

            var host = Host.CreateDefaultBuilder(args).ConfigureServices(services =>
            {
                services.AddTransient<ReportBuilder>();
                services.AddTransient(x => new ReportRepository(connectionString));
                services.AddTransient<Program>();
            });
            return host;
        }
        #endregion 
    }
}