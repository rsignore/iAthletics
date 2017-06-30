//#define SANDBOX

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using System.Text;

public partial class admin_Ad_Wizard_IPN : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        PayPalIPNHandler handler = new PayPalIPNHandler(Request.Form, Context);

        //Post back to either sandbox or live
        string strPayPal =
#if SANDBOX
            "https://www.sandbox.paypal.com/cgi-bin/webscr";
#else
            "https://www.paypal.com/cgi-bin/webscr";

#endif
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(strPayPal);

        //Set values for the request back
        req.Method = "POST";
        req.ContentType = "application/x-www-form-urlencoded";
        byte[] param = Request.BinaryRead(HttpContext.Current.Request.ContentLength);
        string strRequest = Encoding.ASCII.GetString(param);
        strRequest += "&cmd=_notify-validate";
        req.ContentLength = strRequest.Length;

        //for proxy
        //WebProxy proxy = new WebProxy(new Uri("http://url:port#"));
        //req.Proxy = proxy;

        //Send the request to PayPal and get the response
        StreamWriter streamOut = new StreamWriter(req.GetRequestStream(), System.Text.Encoding.ASCII);
        streamOut.Write(strRequest);
        streamOut.Close();
        StreamReader streamIn = new StreamReader(req.GetResponse().GetResponseStream());
        string strResponse = streamIn.ReadToEnd();
        streamIn.Close();

        if (strResponse == "VERIFIED")
        {
            //check the payment_status is Completed
            //check that txn_id has not been previously processed
            //check that receiver_email is your Primary PayPal email
            //check that payment_amount/payment_currency are correct
            //process payment

            // process the PayPal IPN notofication
            //
            
            handler.ProcessNotofication();
        }

        else
        {
            handler.LogError(strResponse);
            //log response/ipn data for manual investigation
        }
    }
}