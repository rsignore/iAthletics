using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;

public partial class apex_TriviaAnswer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        // set up the outgoing mail message
        //
        MailMessage triviaAnswerMsg = new MailMessage();

        triviaAnswerMsg.From = new MailAddress("noreply@appapro.com");
        triviaAnswerMsg.Subject = "Apex Trivia Answer";
        triviaAnswerMsg.To.Add("apextriviaanswer@robertpsignore.com");

        triviaAnswerMsg.Body = String.Format("{0}, at email address {1}, " +
            "submitted the following answer to this week's trivia question:\n\n" +
            "{2}", EntryName.Text, EntryEmail.Text, EntryAnswer.Text);

        // set up the SMTP crap
        //
        SmtpClient mySmtp = new SmtpClient("relay-hosting.secureserver.net");
        mySmtp.EnableSsl = false;
        mySmtp.UseDefaultCredentials = false;
        mySmtp.Credentials = new NetworkCredential("robert.p.signore@appapro.com", "professor");
        //mySmtp.Port = 1;

        //send the message
        //
        try
        {
            mySmtp.Send(triviaAnswerMsg);
        }
        catch
        {
            Response.Redirect("TriviaNotEmailed.html");
        }

        Response.Redirect("TriviaThankYou.html");

    }
}