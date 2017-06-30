
//#define SANDBOX
//#define NORELAY

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Net.Mail;
using System.Net;
using System.Collections.Specialized;
using System.Data.SqlClient;

public partial class _Default : System.Web.UI.Page
{
    private static int AD_TYPE_UPLOAD = 1;
    private static int AD_TYPE_BUILD = 2;

    private static String PAYPAL_SANDBOX = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=EG543R4Y48PRE";
    private static String PAYPAL_LIVE = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=D6HSNEGQQMLN2";
    
    private static String NOT_AN_IMAGE = "The file you selected is not an image. Please select an image file of type .PNG, .JPG, .GIF, or .BMP.";

    private static String SMTP_CLIENT =
#if NORELAY
    "smtpout.secureserver.net";
#else
    "relay-hosting.secureserver.net";  
#endif

    private static String EMAIL_ADDRESS = "mailer@appapro.com";
    private static String EMAIL_PASSWORD = "mailer";
    private static String IMAGE_RELITIVE_URL = "~/images/uploads/";
    private static String YOUR_AD_HERE_IMAGE_URL = "~/images/yourAdHere.png";
    private static String YOUR_BUSINESS_CARD_IMAGE_URL = "~/images/yourBusinessCardOrLogo.png";

    protected void Page_Load(object sender, EventArgs e)
    {
        // hide all error panels. They would get turned on during  event handling
        //
        StepUploadErrorPanel.Visible = false;
        StepBuildErrorPanel.Visible = false;

        // see if the AdWizard is being called to renew an existing ad. If that is the case then load the data
        // for the renewAd attatched to the session
        //
        CssAd renewAd = (CssAd)Session["renewAd"];
        if (renewAd != null)
        {
            Session["renewAd"] = null;
            LoadControlsFromRenewAd(renewAd);
        }
    }


    private void LoadControlsFromRenewAd(CssAd ad)
    {
        // busiess address
        //
        BusinessName.Text = ad.businessName;
        Address1.Text = ad.address1;
        Address2.Text = ad.address2;
        City.Text = ad.city;

        // the renewing state must be set after the combo box loads its values
        //
        Session["renewState"] = ad.state;
        Zip.Text = ad.zip;

        // contact info
        //
        ContactName.Text = ad.contactName;
        Email1.Text = ad.contactEmail;
        PhoneNumber.Text = ad.phone;

        // set the default to an uploaded banner ad
        //
        UploadRadio.Checked = true;

        // link URL
        //
        Url.Text = ad.linkUrl;

        // save the attached bitmap opject that came from the database as a temp file in the
        // uploads directory
        //
        UploadedBannerImage.ImageUrl = IMAGE_RELITIVE_URL + SaveUploadedImage(ad.bmpImg, "renew.png");
    }

    protected void Step2NextBtn_Click(object sender, EventArgs e)
    {
        if (UploadRadio.Checked)
        {
            Session["adType"] = AD_TYPE_UPLOAD;
            AdCreateWizard.SetActiveView(StepUpload);
        }
        else
        {
            Session["adType"] = AD_TYPE_BUILD;
            AdCreateWizard.SetActiveView(StepBuild);
        }

        // rebind the ad types drop-down just in case the user moved back
        //
        AdDurationCombo.DataBind();
    }
    protected void Step4BackButton_Click(object sender, EventArgs e)
    {
        // do the same thing as the forward button in step 2
        //
        this.Step2NextBtn_Click(sender, e);
    }
    protected void UploadBannerButton_Click(object sender, EventArgs e)
    {
        String fileName = "None";

        // Before attempting to save the file, verify
        // that the FileUpload control contains a file.
        //
        if (this.FileUploadBanner.HasFile)
        {
            // is the file an image file?
            //
            if (FileUploadBanner.PostedFile.ContentType.StartsWith("image"))
            {
                // read the file in and create a bitmap out of it so we can validate the
                // file size. the ad must have WxH of 320x50
                //
                HttpPostedFile file = FileUploadBanner.PostedFile;

                try
                {
                    // create a bitmap with the image data
                    //
                    Bitmap img = new Bitmap(file.InputStream, false);
                    Bitmap bannerImg;

                    // if the uploaded image is already 320x50 thne just us it
                    // otherwise create a new image with the proper dimentions
                    // 
                    if (img.Width == 320 && img.Height == 50)
                    {
                        bannerImg = img;
                    }
                    else
                    {
                        bannerImg = new Bitmap(img, new Size(320, 50));
                    }

                    // save this bitmap in the uploads directory
                    //
                    fileName = SaveUploadedImage(bannerImg, FileUploadBanner.FileName);

                    // set the banner image on the page to the 
                    // newly uploaded image
                    //
                    UploadedBannerImage.ImageUrl = IMAGE_RELITIVE_URL + fileName;

                    StepUploadErrorPanel.Visible = false;

                    // turn the next button on
                    //
                    StepBannerNextButton.Enabled = true;
                }
                catch (System.ArgumentException)    // thrown by Bitmap trying to create
                {                                   // a bitmap from the uploaded image
                    // the HTTP wrapper said it's an image, but I can not open it.
                    //
                    StepUploadError.Text = NOT_AN_IMAGE;
                    StepUploadErrorPanel.Visible = true;
                }
                catch (System.Exception ea)    // thrown when converting the bitmap to 320x50
                {                        
                    // the HTTP wrapper said it's an image, but I can not open it.
                    //
                    StepUploadError.Text = ea.Message + "filename:" + fileName;
                    //StepUploadError.Text = "Could not convert the image to 320 pixels wide by 50 pixels high.";
                    StepUploadErrorPanel.Visible = true;
                }
            }
            else
            {
                // wrong file type
                //
                StepUploadError.Text = NOT_AN_IMAGE;
                StepUploadErrorPanel.Visible = true;
            }
        }
        else
        {
            // no file attached
            //
            StepUploadError.Text = "Click the Browse... button to select the banner ad file on " +
                "your computer. Then click the upload button to load ad below.";
            StepUploadErrorPanel.Visible = true;
        }
    }

    String SaveUploadedImage(Bitmap img, String oldFileName)
    {
        // change the file name extension to .PNG since that is the file type we'll use.
        String[] fileNameParts = oldFileName.Split('.');
        String fileName = fileNameParts[0] + ".png";

        // Specify the path to save the uploaded file to.
        string savePath = Request.PhysicalApplicationPath + "images\\uploads\\";

        // Get the name of the file to upload.
        //string fileName = FileUploadBanner.FileName;

        // Create the path and file name to check for duplicates.
        string pathToCheck = savePath + fileName;

        // Create a temporary file name to use for checking duplicates.
        string tempfileName = "";

        // Check to see if a file already exists with the
        // same name as the file to upload.        
        if (System.IO.File.Exists(pathToCheck))
        {
            int counter = 2;
            while (System.IO.File.Exists(pathToCheck))
            {
                // if a file with this name already exists,
                // prefix the filename with a number.
                tempfileName = counter.ToString() + fileName;
                pathToCheck = savePath + tempfileName;
                counter++;
            }

            fileName = tempfileName;
        }

        // Append the name of the file to upload to the path.
        savePath += fileName;

        // Call the SaveAs method to save the uploaded
        // file to the specified directory.
        //
        img.Save(savePath, System.Drawing.Imaging.ImageFormat.Png);

        // return the name of the file saved w/o a path
        //
        return fileName;
    }


    protected void StepBannerNextButton_PreRender(object sender, EventArgs e)
    {
        // turn the next step button on if there is an image in it OTHER THAN
        // the youradhere.png image
        //
        StepBannerNextButton.Enabled = UploadedBannerImage.ImageUrl.CompareTo(YOUR_AD_HERE_IMAGE_URL) != 0;
    }
    protected void GotoAdBuilderButton_Click(object sender, EventArgs e)
    {
        // the user is having trouble uploading a 320x50 banner image that looks good. 
        // redirect them to the ad builder
        //
        BuildRadio.Checked = true;
        UploadRadio.Checked = false;

        AdCreateWizard.SetActiveView(StepBuild);
    }

    protected void UploadBuildImage_Click(object sender, EventArgs e)
    {
        // Before attempting to save the file, verify
        // that the FileUpload control contains a file.
        //
        if (this.FileUploadBuild.HasFile)
        {
            // is the file an image file?
            //
            if (FileUploadBuild.PostedFile.ContentType.StartsWith("image"))
            {
                HttpPostedFile file = FileUploadBuild.PostedFile;

                try
                {
                    // create a bitmap with the image data
                    //
                    Bitmap img = new Bitmap(file.InputStream, false);

                    // save this bitmap in the uploads directory
                    //
                    String fileName = SaveUploadedImage(img, FileUploadBuild.FileName);

                    // set the build image on the page to the newly uploaded image
                    //
                    BuildImage.ImageUrl = "~/images/uploads/" + fileName;

                    // find the optimal size to display the image given the
                    // origional bitmap's size and the constraint we specify for the control
                    //
                    OptimizeImageSize(BuildImage, img, new Size(320, 182));

                    StepBuildErrorPanel.Visible = false;

                }
                catch (System.ArgumentException)    // thrown by Bitmap trying to create
                {                                   // a bitmap from the uploaded image
                    // the HTTP wrapper said it's an image, but I can not open it.
                    //
                    StepBuildError.Text = NOT_AN_IMAGE;
                    StepBuildErrorPanel.Visible = true;
                }
            }
            else
            {
                // wrong file type
                //
                StepBuildError.Text = NOT_AN_IMAGE;
                StepBuildErrorPanel.Visible = true;
            }
        }
        else
        {
            // no file attached
            //
            StepUploadError.Text = "Click the Browse... button to select the banner ad file on " +
                "your computer. Then click the upload button to load ad below.";
            StepUploadErrorPanel.Visible = true;
        }
    }

    void OptimizeImageSize(System.Web.UI.WebControls.Image ctrl, Bitmap img, Size constraint)
    {
        double factor = 1.0;

        // is either the height or the width ofthe image greater than the constraints
        //
        if(img.Width > constraint.Width || img.Height > constraint.Height)
        {
            // calculate both factors
            //
            double factorHeight = ((double)constraint.Height) / ((double)img.Height);
            double factorWidth = ((double)constraint.Width) / ((double)img.Width);

            // take the smaller of the 2
            //
            factor = factorHeight < factorWidth ? factorHeight : factorWidth;
        }

        ctrl.Width = (Unit)((double)img.Width * factor);
        ctrl.Height = (Unit)((double)img.Height * factor);
    }

    protected void ReviewMultiView_Load(object sender, EventArgs e)
    {
        if (UploadRadio.Checked)
        {
            ReviewMultiView.SetActiveView(ReviewUpload);
        }
        else
        {
            ReviewMultiView.SetActiveView(ReviewBuild);
        }

        if (Url.Text != null && Url.Text.Length > 0)
        {
            LabelUrl.Text = Url.Text;
        }
        else
        {
            LabelUrl.Text = "-none-";
        }
    }

    protected void ReviewAndSubmit_Load(object sender, EventArgs e)
    {
        LabelBusinessName.Text = BusinessName.Text;
        LabelAddress1.Text = Address1.Text;

        if (Address2.Text == null || Address2.Text.Length == 0)
        {
            LabelAddress2.Visible = false;
        }
        else
        {
            LabelAddress2.Text = Address2.Text;
            LabelAddress2.Visible = true;
        }

        LabelCity.Text = City.Text;
        LabelState.Text = State.Text;
        LabelZip.Text = Zip.Text;

        LabelContactName.Text = ContactName.Text;
        LabelEmail.Text = Email1.Text;
        LabelPhone.Text = PhoneNumber.Text;

        AcceptCheckError.Visible = false;
    }

    protected void ReviewUpload_Load(object sender, EventArgs e)
    {

            LabelBannerAd.ImageUrl = UploadedBannerImage.ImageUrl;
            if (AdDurationCombo.SelectedIndex > -1)
            {
                DateTime startTime;

                if(DateTime.TryParse(AdStartDate.Text, out startTime))
                {
                    // display the start date of the ad
                    //
                    LabelAdStartDate.Text = AdStartDate.Text;

                    //display the end date of the ad
                    //
                    DateTime adEndDate = CalcualteAdEndDate(startTime,
                        Convert.ToInt32(AdDurationCombo.SelectedItem.Value));
                    LabelAdEndDate.Text = adEndDate.ToString();

                    //display the ad type
                    //
                    String adTypeAndCost = AdDurationCombo.SelectedItem.Text;
                    int indexOpenParen = adTypeAndCost.IndexOf("(");
                    int indexCloseParen = adTypeAndCost.IndexOf(")");

                    LabelAdType.Text = adTypeAndCost.Substring(0, indexOpenParen - 1);

                    // display the ad price
                    //
                    LabelAdCost.Text = adTypeAndCost.Substring(indexOpenParen + 1,
                        indexCloseParen - indexOpenParen - 1);
                }
            }
    }

    protected void ReviewBuild_Load(object sender, EventArgs e)
    {
        if (BuildImage.ImageUrl.CompareTo(YOUR_BUSINESS_CARD_IMAGE_URL) != 0)
        {
            LabelBuildImage.ImageUrl = BuildImage.ImageUrl;
            LabelBuildImage.Width = BuildImage.Width;
            LabelBuildImage.Height = BuildImage.Height;

            LabelNoBuildImage.Visible = false;
            LabelBuildImage.Visible = true;
        }
        else
        {
            LabelNoBuildImage.Visible = true;
            LabelBuildImage.Visible = false;
        }

        LabelFirstLine.Text = FirstLine.Text;
        LabelSecondLine.Text = SecondLine.Text;
        LabelThirdLine.Text = ThirdLine.Text;
        LabelInstructions.Text = Instructions.Text;
    }
    protected void ClearButton_Click(object sender, EventArgs e)
    {
        BuildImage.ImageUrl = YOUR_BUSINESS_CARD_IMAGE_URL;
        BuildImage.Width = 320;
        BuildImage.Height = 182;
    }

    protected int InsertAdInDatabase()
    {
        CssAd ad = new CssAd(Context);

        // busiess address
        //
        ad.businessName = BusinessName.Text;
        ad.address1 = Address1.Text;
        ad.address2 = Address2.Text;
        ad.city = City.Text;
        ad.state = State.Text;
        ad.zip = Zip.Text;

        // contact info
        //
        ad.contactName = ContactName.Text;
        ad.contactEmail = Email1.Text;
        ad.phone = PhoneNumber.Text;

        // ad builder type (build or upload)
        //
        if (UploadRadio.Checked == true)
        {
            // take the leading ~/ off of the url. We need to format the email with the
            // full url since the email will be read outside of the ASP.NET environment
            //
            Uri imageUrl = new Uri(Request.Url, "../../" + UploadedBannerImage.ImageUrl.Substring(2));

            ad.uploadedBannerUrl = imageUrl.ToString();
        }
        else
        {
            ad.firstLine = FirstLine.Text;
            ad.secondLine = SecondLine.Text;
            ad.thirdLine = ThirdLine.Text;
            ad.instructions = Instructions.Text;

            if (BuildImage.ImageUrl.CompareTo(YOUR_BUSINESS_CARD_IMAGE_URL) != 0)
            {
                Uri imageUrl = new Uri(Request.Url, "../../" + BuildImage.ImageUrl.Substring(2));

                ad.uploadedImageUrl = imageUrl.ToString();
            }
        }

        // link URL
        //
        ad.linkUrl = Url.Text;

        ad.appId = (int)Session["AppIdParam"];

        // store the ad rate informaion
        //
        int adRateId = Convert.ToInt32(AdDurationCombo.SelectedItem.Value);
        ad.cssAdRate = adRateId;
        
        // set the begin and end dates of the ad
        //
        DateTime startDate = Convert.ToDateTime(LabelAdStartDate.Text);
        ad.adStartDate = startDate;
        ad.adEndDate = Convert.ToDateTime(LabelAdEndDate.Text);
        
        return ad.InsertNew();
    }

    private DateTime CalcualteAdEndDate(DateTime startDate, int adRateId)
    {
        DateTime retVal;
        string conStr = (string)Application["DB_CONNECTION_STRING"];
        string qry = "SELECT AdDurationMonths FROM CssAdRates WHERE AdRateId = @adRateId";
        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(qry, con);

        try
        {
           
            cmd.Parameters.AddWithValue("adRateId", (object)adRateId);

            // execute the query
            //
            con.Open();
            int adMonthDuration = (int)cmd.ExecuteScalar();

            retVal = startDate.AddMonths(adMonthDuration);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            con.Close();
        }

        return retVal;
    }

    protected void Submit_Click(object sender, ImageClickEventArgs e)
    {
        if (Accept.Checked == false)
        {
            AcceptCheckError.Visible = true;
            return;
        }
        else
        {
            int adId = InsertAdInDatabase();
//            EmailNewAd(adId);
            GetPayPalPayment(adId);
        }
    }

    protected void GetPayPalPayment(int adId)
    {        
        String payPalUrl = 
#if SANDBOX
            PAYPAL_SANDBOX; 
#else
            PAYPAL_LIVE;
#endif

        // rm = 2: call the return URL using the POST method
        //
        // os0 = appId
        // item_numer is the adId
        //
        payPalUrl += "&on0=appId&rm=2" +
            "&item_number=" + adId.ToString() +
            "&os0=" + Session["AppIdParam"].ToString();

        // add the ad cost and the item name to the paypal string
        //
        payPalUrl += "&amount=" + LabelAdCost.Text.Substring(1);
        payPalUrl += "&item_name=" + LabelAdType.Text;

        // add the return URL and the cancel URL to the string too.
        //
        Uri returnURL = new Uri(Request.Url, "PayPalReturn.aspx");
        Uri cancelURL = new Uri(Request.Url, "PayPalCancel.aspx");

        payPalUrl += "&return=" + returnURL.ToString() +
            "&cancel_return=" + cancelURL.ToString();

        // set the IPN callback
        //
        Uri ipnURL = new Uri(Request.Url, "IPN.aspx");
        payPalUrl += "&notify_url=" + ipnURL.ToString();

        // call paypal and get money!
        //
        Response.Redirect(payPalUrl, true);
    }

    protected void EmailNewAd(int adId)
    {
        // set up the outgoing mail message
        //
        MailMessage newAdMsg = new MailMessage();

        String appName = "Unknown";
        if (Session["appName"] != null)
        {
            appName = (string)Session["appName"];
        }

        newAdMsg.From = new MailAddress("mailer@appapro.com");
        newAdMsg.Subject = "New ad #" + adId.ToString() + " for " + appName;
        newAdMsg.To.Add("community.advertising@appapro.com");
        newAdMsg.IsBodyHtml = true;

        String businessInfo = String.Format("NEW ADVERTISER REGISTRATION<br><br>" +
            "Ad ID:             {0}<br>" +
            "Application:       {10}<br><br>" +
            "Business name:     {1}<br>" +
            "Business address:  {2}<br>" +
            "                   {3}<br>" +
            "                   {4}, {5}, {6}<br>" +
            "Contact Name:      {7}<br>" +
            "Email:             {8}<br>" +
            "Phone:             {9}<br>",
            adId.ToString(),
            BusinessName.Text,
            Address1.Text,
            Address2.Text,
            City.Text, State.Text, Zip.Text,
            ContactName.Text,
            Email1.Text,
            PhoneNumber.Text, appName);


        String adInfo = "<br><b>Ad Details:</b><br><br>";

        if (UploadRadio.Checked == true)
        {
            // take the leading ~/ off of the url. We need to format the email with the
            // full url since the email will be read outside of the ASP.NET environment
            //
            Uri imgUrl = new Uri(Request.Url, 
                Server.UrlEncode(UploadedBannerImage.ImageUrl.Substring(2)));

            adInfo += String.Format("Banner Ad: <img src=\"{0}\"><br>" +
                "Banner ad URL: {1}<br>",
                imgUrl.ToString(),
                imgUrl.ToString());
        }
        else
        {
            adInfo += String.Format("Line 1: {0}<br>" +
                "Line 2: {1}<br>" +
                "Line 3: {2}<br>" +
                "Instructions: {3}<br><br>",
                FirstLine.Text,
                SecondLine.Text,
                ThirdLine.Text,
                Instructions.Text);

            if (BuildImage.ImageUrl.CompareTo(YOUR_BUSINESS_CARD_IMAGE_URL) != 0)
            {
                Uri imageUrl = new Uri(Request.Url, 
                    Server.UrlEncode(BuildImage.ImageUrl.Substring(2)));

                adInfo += String.Format("Use image: <img src=\"{0}\"><br>" +
                    "Image Url: {1}<br>",
                    imageUrl.ToString(),
                    imageUrl.ToString());
            }
        }

        adInfo += String.Format("Link URL: {0}", Url.Text);

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

            // show the thank you page
            //
            AdCreateWizard.SetActiveView(Thankyou);
        }
        catch
        {
        }
    }


    protected void AcceptValidator_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (Accept.Checked == false)
        {
            AcceptCheckError.Visible = true;
            args.IsValid = false;
        }
        else
        {
            args.IsValid = true;
        }
    }
    protected void ReviewAndSubmit_PreRender(object sender, EventArgs e)
    {
        // uncheck the Accept check box on load all the time
        //
        Accept.Checked = false;
    }

    //protected void BeginButton_Click(object sender, EventArgs e)
    //{
    //    // save the ad cost
    //    //
    //    String adCostStr = Request["ctl00$MainContent$SelectedSchoolForm$AdCost"];
    //    String payPalDebugStr = Request["ctl00$MainContent$SelectedSchoolForm$PayPalDebug"];
    //    String payPalLiveStr = Request["ctl00$MainContent$SelectedSchoolForm$PayPalLive"];
    //    String appNameStr = Request["ctl00$MainContent$SelectedSchoolForm$AppName"];
    //    String usesTeamCodesStr = Request["ctl00$MainContent$SelectedSchoolForm$UsesTeamCodes"];
    //    String schoolName = Request["ctl00$MainContent$SelectedSchoolForm$HiddenSchoolName"];


    //    if(adCostStr != null)
    //    {
    //        try
    //        {
    //            double adCost = Double.Parse(adCostStr);
    //            Session["adCost"] = adCost;
    //        }
    //        catch
    //        {
    //            Session["adCost"] = null;
    //        }
    //    }

    //    if (payPalDebugStr != null)
    //    {
    //        Session["payPalDebugUrl"] = payPalDebugStr;
    //    }

    //    if (payPalLiveStr != null)
    //    {
    //        Session["payPalLiveUrl"] = payPalLiveStr;
    //    }

    //    if (appNameStr != null)
    //    {
    //        Session["appName"] = appNameStr;
    //    }

    //    bool usesTeamCodes = false;
    //    if (usesTeamCodesStr != null)
    //    {
    //        bool.TryParse(usesTeamCodesStr, out usesTeamCodes);
    //    }

    //    AdCreateWizard.SetActiveView(Step1);
    //}

    protected void AdStartDate_Load(object sender, EventArgs e)
    {
        TextBox startDate = (TextBox)sender;

        // set the start date to today of the box is empty
        //
        if (startDate.Text == null || startDate.Text.Length == 0)
        {
            startDate.Text = DateTime.Today.ToShortDateString();
        }
    }

 
    protected void AdDurationCombo_PreRender(object sender, EventArgs e)
    {
        if (AdDurationCombo.SelectedIndex > -1)
        {
            Step5Button.Enabled = true;
        }
        else
        {
            Step5Button.Enabled = false;
        }
    }

    protected void AdStartDate_TextChanged1(object sender, EventArgs e)
    {
        DateTime startDate;

        // check to see if the start date is a valid date.
        //
        try
        {
            startDate = Convert.ToDateTime(AdStartDate.Text);

            //if (startDate < DateTime.Today)
            //{
            //    AdStartDate.Text = DateTime.Today.ToShortDateString();
            //}
        }
        catch (Exception exe)
        {
            AdStartDate.Text = DateTime.Today.ToShortDateString();
        }

    }

    protected void State_DataBound(object sender, EventArgs e)
    {
        String renewState = (String)Session["renewState"];
        if (renewState != null)
        {
            State.SelectedValue = renewState;
            Session["renewState"] = null;
        }
    }
}

