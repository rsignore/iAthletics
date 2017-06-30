//#define NORELAY

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections.Specialized;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Net;

/// <summary>
/// Summary description for PayPalIPNHandler
/// </summary>
public class PayPalIPNHandler
{
    // email settings
    //
    private static String EMAIL_ADDRESS = "mailer@appapro.com";
    private static String EMAIL_PASSWORD = "mailer";
    private static String SMTP_CLIENT =
#if NORELAY
    "smtpout.secureserver.net";
#else
 "relay-hosting.secureserver.net";
#endif

    private NameValueCollection _form;
    private HttpContext _context;

    public PayPalIPNHandler(NameValueCollection form, HttpContext context)
    {
        _form = form;
        _context = context;
    }

    public void ProcessNotofication()
    {
        // only process if payment_status is completed
        //
        string status = _form.Get("payment_status");

        if (status.CompareTo("Completed") == 0)
        {
            string txnId = _form.Get("txn_id");
            string adId = _form.Get("item_number");

            // if either if these items is null, theres a problem
            //
            if (txnId != null && adId != null)
            {
                ProcessAdTransaction(Convert.ToInt32(adId), txnId);
            }
            else
            {
                SendMessage("ERROR: Could not process notofication because the transaction or " +
                    "adId was missing.");
            }
        }
        else
        {
            // if people pay by check, the status can be pending, etc.
            //
            SendMessage("Received notofication with status " + status);
        }
    }

    private void ProcessAdTransaction(int adId, string txnId)
    {
        CssAd adToProcess = new CssAd(_context);

        if (adToProcess.getCssAd(adId))
        {
            if (!adToProcess.IsTransactionProcessed())
            {
                if (ProcessAd(adToProcess, txnId))
                {
                    SendMessage("Successfuly processed transaction");
                }
            }
            else
            {
                SendMessage("WARNING: Received duplicate transaction");
            }
        }
        else
        {
            SendMessage("ERROR: IPN could not be processed because of on invalid adId");
        }
    }

    private bool ProcessAd(CssAd adToProcess, string txnId)
    {
        bool retVal = false;

        if (adToProcess.IsUploadedBannerAd())
        {
            retVal = ProcessBannerAd(adToProcess, txnId);
        }
        else
        {
            retVal = ProcessBuildAd(adToProcess, txnId);
        }

        return retVal;
    }

    private bool ProcessBuildAd(CssAd adToProcess, string txnId)
    {
        bool retVal = false;

        if (SendBuildAdEmail(adToProcess))
        {
            retVal = adToProcess.RecordPayPalTransaction(txnId);
        }
        else
        {
            SendMessage("ERROR: Could not send build email");
        }

        return retVal;
    }

    // to process a banner ad, we want to copy the ad info to the application ads database
    // and upload the ad image. Also update the CssAds with the PayPal transaction.
    //
    private bool ProcessBannerAd(CssAd adToProcess, string txnId)
    {
        bool retVal = false;

        if (adToProcess.CopyToApplicationAds() > 0)
        {   
            retVal = adToProcess.RecordPayPalTransaction(txnId);
        }

        return retVal;
    }

    public void LogError(string strErr)
    {
        SendMessage("Unhandled response received(" + strErr + ")");
    }

    private void SendMessage(string msg)
    {
        // set up the outgoing mail message
        //
        MailMessage newAdMsg = new MailMessage();

        newAdMsg.From = new MailAddress("mailer@appapro.com");
        newAdMsg.Subject = "IPN Handler: " + msg;
        newAdMsg.To.Add("payments@appapro.com");
        newAdMsg.IsBodyHtml = true;

        newAdMsg.Body = "<b>" + msg + "</b><p>";

        for (int i = 0; i < _form.Keys.Count; i++)
        {
            newAdMsg.Body += _form.GetKey(i) + ": " + _form.GetValues(i)[0] + "<br>";
        }

        // set up the SMTP server. Use relay-hosting for the prod site on GoDaddy
        // and smtpout from when testing or debugging locally
        //
        SmtpClient mySmtp = new SmtpClient(SMTP_CLIENT);
        mySmtp.EnableSsl = false;
        mySmtp.UseDefaultCredentials = false;
        mySmtp.Credentials = new NetworkCredential(EMAIL_ADDRESS, EMAIL_PASSWORD);

        //send the message
        //
        try
        {
            mySmtp.Send(newAdMsg);
        }
        catch
        {
        }
    }

    private bool SendBuildAdEmail(CssAd adToProcess)
    {
        bool retVal = false;

        // set up the outgoing mail message
        //
        MailMessage newAdMsg = new MailMessage();

        newAdMsg.From = new MailAddress("mailer@appapro.com");
        newAdMsg.Subject = "New CSS Build Ad #" + adToProcess.cssAdId.ToString();
        newAdMsg.To.Add("payments@appapro.com");
        newAdMsg.IsBodyHtml = true;

        String businessInfo = String.Format("NEW ADVERTISER REGISTRATION<br><br>" +
            "Css Ad ID:         {0}<br>" +
            "App ID             {10}<br>" +
            "Business name:     {1}<br>" +
            "Business address:  {2}<br>" +
            "                   {3}<br>" +
            "                   {4}, {5}, {6}<br>" +
            "Contact Name:      {7}<br>" +
            "Email:             {8}<br>" +
            "Phone:             {9}<br>",
            adToProcess.cssAdId.ToString(),
            adToProcess.businessName,
            adToProcess.address1,
            adToProcess.address2,
            adToProcess.city, adToProcess.state, adToProcess.zip,
            adToProcess.contactName,
            adToProcess.contactEmail,
            adToProcess.phone, adToProcess.appId);

        String adInfo = "<br><b>Ad Details:</b><br><br>";

        adInfo += String.Format("Line 1: {0}<br>" +
            "Line 2: {1}<br>" +
            "Line 3: {2}<br>" +
            "Instructions: {3}<br><br>",
            adToProcess.firstLine,
            adToProcess.secondLine,
            adToProcess.thirdLine,
            adToProcess.instructions);

        if (adToProcess.uploadedImageUrl != null && adToProcess.uploadedImageUrl.Length > 0)
        {
            adInfo += String.Format("Use image: <img src=\"{0}\"><br>" +
                "Image Url: {0}<br>",
                adToProcess.uploadedImageUrl);
        }


        adInfo += String.Format("Link URL: {0}", adToProcess.linkUrl);

        newAdMsg.Body = businessInfo + adInfo;

        // set up the SMTP server. Use relay-hosting for the prod site on GoDaddy
        // and smtpout from when testing or debugging locally
        //
        SmtpClient mySmtp = new SmtpClient(SMTP_CLIENT);
        mySmtp.EnableSsl = false;
        mySmtp.UseDefaultCredentials = false;
        mySmtp.Credentials = new NetworkCredential(EMAIL_ADDRESS, EMAIL_PASSWORD);

        //send the message
        //
        try
        {
            mySmtp.Send(newAdMsg);
            retVal = true;
        }
        catch
        {
        }

        return retVal;
    } 
}