using EmailReporting.Data.DTO;
using Dapper;
using MySql.Data.MySqlClient;
using Microsoft.Extensions.Configuration;

namespace EmailReporting.Data
{
    internal class ReportRepository
    {
        private string ConnectionString { get; }

        public ReportRepository(string connectionString)
        {
            ConnectionString = connectionString;
        }

        public MemberMonth[] GetMemberMonths()
        {
            using (var connection = new MySqlConnection(ConnectionString))
            {
                var script = GetScript("GetMemberMonths");
                var results = connection.Query<MemberMonth>(script);
                return results.ToArray();
            }
        }

        internal string GetScript(string scriptName)
        {
            var resourceName = $"EmailReporting.Data.Scripts.{scriptName}.sql";
            var assem = this.GetType().Assembly;
            using (Stream stream = assem.GetManifestResourceStream(resourceName))
            {
                using (var reader = new StreamReader(stream))
                {
                    return reader.ReadToEnd();
                }
            }
        }

    }
}
