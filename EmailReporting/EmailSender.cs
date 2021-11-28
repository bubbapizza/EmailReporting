using MailKit.Net.Smtp;
using MimeKit;

namespace EmailReporting
{
    internal static class EmailHelper
    {

        internal static void SendError(Exception ex)
        {
            var error = "<h2>" + ex.Message +"</h2>" + "<p>" + ex.StackTrace?.Replace("\n","<br/>") + "</p>";

            SendEmail("Error in reporting", error, "IT", "nsteel@metamakers.org");
        }

        public static void SendToDirectors(string subject, string body)
        {
            SendEmail(subject, body, "Directors", "nsteel@metamakers.org");
        }

        private static void SendEmail(string subject, string body, string toName, string toEmail)
        {

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("M2C Reporting", "sysadmin@wiki.metamakers.org"));
            message.To.Add(new MailboxAddress(toName, toEmail));
            message.Subject = subject;

            message.Body = new TextPart("html")
            {
                Text = body
            };

            using (var client = new SmtpClient())
            {
                client.Connect("mail.metamakers.org", 25);
                client.Send(message);
                client.Disconnect(true);
            }
        }

    }
}
