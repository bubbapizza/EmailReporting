using EmailReporting.Data;
using System.Text;

namespace EmailReporting
{
    internal class ReportBuilder
    {
        private ReportRepository Repository { get; }

        public ReportBuilder(ReportRepository repository)
        {
            Repository = repository;
        }

        public string GetMembershipReportHtml()
        {
            var memberMonths = Repository.GetMemberMonths();

            var members = memberMonths.GroupBy(x => x.MemberName);

            var builder = new StringBuilder();

            //create html table table and label columns
            var months = string.Join("", members.First().Select(x => $"<th>{x.YearMonth}</th>"));
            builder.Append($"<table style=\"font-family:sans-serif;font-size:12px\"><thead><tr><th style=\"text-align:left;\">Member Name</th>{months}</tr></thead><tbody>");

            foreach (var member in members)
            {
                //member name
                builder.Append($"<tr><td>{member.Key}</td>");

                foreach (var month in member)
                {
                    //shade future months grey
                    if (month.IsFuture)
                    {
                        builder.Append("<td style=\"background-color:#efefef;\">");
                    }
                    else
                    {
                        builder.Append("<td>");
                    }

                    //mark active memberships with blue dots
                    if (month.IsActive)
                    {
                        builder.Append("<div style=\"background-color:#2f7ae5;margin: 0px 4px;border-radius: 4px;height: 10px;\"></div>");
                    }

                    builder.Append("</td>");
                }

                builder.Append("</tr>");
            }
            builder.Append("</tbody></table>");

            return builder.ToString();
        }

    }
}
