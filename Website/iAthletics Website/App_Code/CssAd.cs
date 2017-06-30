using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Drawing;

/// <summary>
/// Summary description for CssAd
/// </summary>
public class CssAd
{
    private HttpContext _context;
    private string _conStr;

    public int cssAdId { get; set; }
    public String businessName { get; set; }
    public String address1 { get; set; }
    public String address2 { get; set; }
    public String city { get; set; }
    public String state { get; set; }
    public String zip { get; set; }
    public String contactName { get; set; }
    public String contactEmail { get; set; }
    public String phone { get; set; }
    public String uploadedBannerUrl { get; set; }
    public String firstLine { get; set; }
    public String secondLine { get; set; }
    public String thirdLine { get; set; }
    public String instructions { get; set; }
    public String uploadedImageUrl { get; set; }
    public String linkUrl { get; set; }
    public int appId { get; set; }
    public int cssAdRate { get; set; }
    public String payPalTransaction { get; set; }
    public DateTime adStartDate { get; set; }
    public DateTime adEndDate { get; set; }
    public DateTime agreeToTermsDate { get; set; }

    // this member variable is use to hold the image during the renew function
    //
    public Bitmap bmpImg { get; set; }

    public CssAd(HttpContext context)
    {
        _context = context;
        _conStr = (string)_context.Application["DB_CONNECTION_STRING"];
    }

    private void clear()
    {
        businessName = address1 = address2 = city = state = zip = contactName =
            contactEmail = phone = uploadedBannerUrl =
            firstLine = secondLine = thirdLine = instructions = uploadedImageUrl = linkUrl = payPalTransaction = null;

        appId = cssAdRate = 0;
        adStartDate = adEndDate = agreeToTermsDate = Convert.ToDateTime("1/1/1980");
    }

    public bool getCssAd(int adId)
    {
        bool retVal = false;
        string qry = "SELECT dbo.CssAds.* FROM dbo.CssAds WHERE (cssAdId = @adId)";
        SqlConnection con = new SqlConnection(_conStr);
        SqlCommand cmd = new SqlCommand(qry, con);

        // set the input parameters
        //
        cmd.Parameters.AddWithValue("adId", adId);

        // clear all members in this class
        //
        clear();

        try
        {
            con.Open();
            SqlDataReader adRow = cmd.ExecuteReader();
            if (adRow.Read())
            {
                cssAdId = adRow["cssAdId"] == DBNull.Value ? 0 : (int)adRow["cssAdId"];
                businessName = adRow["businessName"] == DBNull.Value ? null : (string)adRow["businessName"];
                address1 = adRow["address1"] == DBNull.Value ? null : (string)adRow["address1"];
                address2 = adRow["address2"] == DBNull.Value ? null : (string)adRow["address2"];
                city = adRow["city"] == DBNull.Value ? null : (string)adRow["city"];
                state = adRow["state"] == DBNull.Value ? null : (string)adRow["state"];
                zip = adRow["zip"] == DBNull.Value ? null : (string)adRow["zip"];
                contactName = adRow["contactName"] == DBNull.Value ? null : (string)adRow["contactName"];
                contactEmail = adRow["contactEmail"] == DBNull.Value ? null : (string)adRow["contactEmail"];
                phone = adRow["phone"] == DBNull.Value ? null : (string)adRow["phone"];
                uploadedBannerUrl = adRow["uploadedBannerUrl"] == DBNull.Value ? null : (string)adRow["uploadedBannerUrl"];
                firstLine = adRow["firstLine"] == DBNull.Value ? null : (string)adRow["firstLine"];
                secondLine = adRow["secondLine"] == DBNull.Value ? null : (string)adRow["secondLine"];
                thirdLine = adRow["thirdLine"] == DBNull.Value ? null : (string)adRow["thirdLine"];
                instructions = adRow["instructions"] == DBNull.Value ? null : (string)adRow["instructions"];
                uploadedImageUrl = adRow["uploadedImageUrl"] == DBNull.Value ? null : (string)adRow["uploadedImageUrl"];
                linkUrl = adRow["linkUrl"] == DBNull.Value ? null : (string)adRow["linkUrl"];
                appId = adRow["appId"] == DBNull.Value ? 0 : (int)adRow["appId"];
                cssAdRate = adRow["cssAdRate"] == DBNull.Value ? 0 : (int)adRow["cssAdRate"];
                payPalTransaction = adRow["PayPalTransaction"] == DBNull.Value ? null : (string)adRow["PayPalTransaction"];
                adStartDate = adRow["adStartDate"] == DBNull.Value ? Convert.ToDateTime("1/1/1980") : (DateTime)adRow["adStartDate"];
                adEndDate = adRow["adEndDate"] == DBNull.Value ? Convert.ToDateTime("1/1/1980") : (DateTime)adRow["adEndDate"];
                agreeToTermsDate = adRow["agreeToTermsDate"] == DBNull.Value ? Convert.ToDateTime("1/1/1980") : (DateTime)adRow["agreeToTermsDate"];

                retVal = true;
            }
        }
        finally
        {
            con.Close();
        }

        return retVal;
    }

    public bool IsUploadedBannerAd()
    {
        bool retVal = false;

        if (this.uploadedBannerUrl != null && this.uploadedBannerUrl.Length > 0)
        {
            retVal = true;
        }

        return retVal;
    }
    public bool IsTransactionProcessed()
    {
        bool retVal = false;

        if (payPalTransaction != null && payPalTransaction.Length > 0)
        {
            retVal = true;
        }

        return retVal;
    }

    public int InsertNew()
    {
        string insertQry = "EXECUTE [dbo].[CssInsertAd] " +
            "@businessName, @address1, @address2, @city ,@state, @zip, " +
            "@contactName, @contactEmail, @phone, " +
            "@uploadedBannerUrl, " +
            "@firstLine, @secondLine, @thirdLine, @instructions, @uploadedImageUrl, " +
            "@linkUrl, @appId, @cssAdRate, @adStartDate, @adEndDate, " +
            "@adId = @adId OUTPUT";

        SqlConnection con = new SqlConnection(_conStr);
        SqlCommand cmd = new SqlCommand(insertQry, con);

        // set the input parameters
        //
        cmd.Parameters.AddWithValue("businessName",
            this.businessName == null ? DBNull.Value : (object)this.businessName);
        cmd.Parameters.AddWithValue("address1",
            this.address1 == null ? DBNull.Value : (object)this.address1);
        cmd.Parameters.AddWithValue("address2",
            this.address2 == null ? DBNull.Value : (object)this.address2);
        cmd.Parameters.AddWithValue("city",
            this.city == null ? DBNull.Value : (object)this.city);
        cmd.Parameters.AddWithValue("state",
            this.state == null ? DBNull.Value : (object)this.state);
        cmd.Parameters.AddWithValue("zip",
            this.zip == null ? DBNull.Value : (object)this.zip);
        cmd.Parameters.AddWithValue("contactName",
            this.contactName == null ? DBNull.Value : (object)this.contactName);
        cmd.Parameters.AddWithValue("contactEmail",
            this.contactEmail == null ? DBNull.Value : (object)this.contactEmail);
        cmd.Parameters.AddWithValue("phone",
            this.phone == null ? DBNull.Value : (object)this.phone);
        cmd.Parameters.AddWithValue("uploadedBannerUrl",
            this.uploadedBannerUrl == null ? DBNull.Value : (object)this.uploadedBannerUrl);
        cmd.Parameters.AddWithValue("firstLine",
            this.firstLine == null ? DBNull.Value : (object)this.firstLine);
        cmd.Parameters.AddWithValue("secondLine",
            this.secondLine == null ? DBNull.Value : (object)this.secondLine);
        cmd.Parameters.AddWithValue("thirdLine",
            this.thirdLine == null ? DBNull.Value : (object)this.thirdLine);
        cmd.Parameters.AddWithValue("instructions",
            this.instructions == null ? DBNull.Value : (object)this.instructions);
        cmd.Parameters.AddWithValue("uploadedImageUrl",
            this.uploadedImageUrl == null ? DBNull.Value : (object)this.uploadedImageUrl);
        cmd.Parameters.AddWithValue("linkUrl",
            this.linkUrl == null ? DBNull.Value : (object)this.linkUrl);
        cmd.Parameters.AddWithValue("cssAdRate", (object)this.cssAdRate);
        cmd.Parameters.AddWithValue("appId", (object)this.appId);

        cmd.Parameters.AddWithValue("adStartDate", (object)this.adStartDate);
        cmd.Parameters.AddWithValue("adEndDate", (object)this.adEndDate);


        // create and set the output parameter
        //
        SqlParameter adIdParam = new SqlParameter("adId", System.Data.SqlDbType.Decimal);
        adIdParam.Direction = System.Data.ParameterDirection.Output;
        cmd.Parameters.Add(adIdParam);

        con.Open();
        cmd.ExecuteNonQuery();

        // get the output parameters value
        //
        this.cssAdId = Decimal.ToInt32((Decimal)adIdParam.Value);

        con.Close();

        return this.cssAdId;
    }

    public static System.Array ResizeArray(System.Array oldArray, int newSize)
    {
        int oldSize = oldArray.Length;
        System.Type elementType = oldArray.GetType().GetElementType();
        System.Array newArray = System.Array.CreateInstance(elementType, newSize);
        int preserveLength = System.Math.Min(oldSize, newSize);
        if (preserveLength > 0)
        {
            System.Array.Copy(oldArray, newArray, preserveLength);
        }

        return newArray;
    }


    // returns the AdId in the ApplicationAds table
    //
    public int CopyToApplicationAds()
    {
        int retVal = 0;

        string copyQuery = "EXECUTE [CopyCssAdToApplicationAd] @adImage, @cssAdId, @adId OUTPUT";

        SqlConnection con = new SqlConnection(_conStr);
        SqlCommand cmd = new SqlCommand(copyQuery, con);

        try
        {

            // set the input parameters
            //
            cmd.Parameters.AddWithValue("cssAdId", this.cssAdId);

            // load the image file from the network
            //
            WebRequest request = WebRequest.Create(this.uploadedBannerUrl);
            WebResponse response = request.GetResponse();
            Stream responseStream = response.GetResponseStream();

            byte[] readBuffer = new Byte[1024];
            int bytesRead;
            byte[] imageBuffer = null;
            while ((bytesRead = responseStream.Read(readBuffer, 0, readBuffer.Length)) > 0)
            {
                int oldSize;
                if (imageBuffer == null)
                {
                    imageBuffer = new byte[bytesRead];
                    oldSize = 0;
                }
                else
                {

                    oldSize = imageBuffer.Length;
                    imageBuffer = (byte[])ResizeArray(imageBuffer, imageBuffer.Length + bytesRead);
                }

                // if this was not a full read then trim to buffer to wat was just read
                //
                if (bytesRead < readBuffer.Length)
                {
                    readBuffer = (byte[])ResizeArray(readBuffer, bytesRead);
                }

                readBuffer.CopyTo(imageBuffer, oldSize);
            }

            // save the image as a parameter
            //
            cmd.Parameters.AddWithValue("adImage", imageBuffer);

            // create and set the output parameter
            //
            SqlParameter adIdParam = new SqlParameter("adId", System.Data.SqlDbType.Decimal);
            adIdParam.Direction = System.Data.ParameterDirection.Output;
            cmd.Parameters.Add(adIdParam);

            con.Open();

            if (cmd.ExecuteNonQuery() == 1)
            {
                // we return the newly creaded adId in the ApplicationAds table
                //
                retVal = Decimal.ToInt32((Decimal)adIdParam.Value);
            }
        }
        catch
        {
            throw;
        }
        finally
        {
            con.Close();
        }

        return retVal;
    }

    public bool RecordPayPalTransaction(string txnId)
    {
        int rows = 0;

        string updateQry = "UPDATE CssAds SET PayPalTransaction = @txnId WHERE cssAdId = @adId";

        SqlConnection con = new SqlConnection(_conStr);
        SqlCommand cmd = new SqlCommand(updateQry, con);

        //set parameters
        //
        cmd.Parameters.AddWithValue("txnId", txnId);
        cmd.Parameters.AddWithValue("adId", this.cssAdId);

        try
        {
            con.Open();

            rows = cmd.ExecuteNonQuery();
        }
        finally
        {
            con.Close();
        }

        return rows > 0;
    }

    // this method creates a CssAd object from an existing Applicaion ad. It is used by the
    // renew feature of the ad manager to create a new ad based upon an existing ad in the system
    //
    public bool CreateFromApplicationAd(int adId)
    {
        bool retVal = false;
        String qry = "SELECT * from ApplicationAds where adId = @adId";
        SqlConnection con = new SqlConnection(_conStr);
        SqlCommand cmd = new SqlCommand(qry, con);

        // set the input parameters
        //
        cmd.Parameters.AddWithValue("adId", adId);

        // clear all members in this class
        //
        clear();

        try
        {
            con.Open();
            SqlDataReader adRow = cmd.ExecuteReader();
            if (adRow.Read())
            {
                // cssAdId = adRow["cssAdId"] == DBNull.Value ? 0 : (int)adRow["cssAdId"];

                businessName = adRow["vendorName"] == DBNull.Value ? null : (string)adRow["vendorName"];
                address1 = adRow["vendorAddress1"] == DBNull.Value ? null : (string)adRow["vendorAddress1"];
                address2 = adRow["vendorAddress2"] == DBNull.Value ? null : (string)adRow["vendorAddress2"];
                city = adRow["vendorCity"] == DBNull.Value ? null : (string)adRow["vendorCity"];
                state = adRow["vendorState"] == DBNull.Value ? null : (string)adRow["vendorState"];
                zip = adRow["vendorZip"] == DBNull.Value ? null : (string)adRow["vendorZip"];
                contactName = adRow["contactName"] == DBNull.Value ? null : (string)adRow["contactName"];
                contactEmail = adRow["contactEmail"] == DBNull.Value ? null : (string)adRow["contactEmail"];
                phone = adRow["contactPhone"] == DBNull.Value ? null : (string)adRow["contactPhone"];

                // uploadedBannerUrl = adRow["uploadedBannerUrl"] == DBNull.Value ? null : (string)adRow["uploadedBannerUrl"];

                //firstLine = adRow["firstLine"] == DBNull.Value ? null : (string)adRow["firstLine"];
                //secondLine = adRow["secondLine"] == DBNull.Value ? null : (string)adRow["secondLine"];
                //thirdLine = adRow["thirdLine"] == DBNull.Value ? null : (string)adRow["thirdLine"];
                //instructions = adRow["instructions"] == DBNull.Value ? null : (string)adRow["instructions"];
                //uploadedImageUrl = adRow["uploadedImageUrl"] == DBNull.Value ? null : (string)adRow["uploadedImageUrl"];

                // create an image in the download directory 
                //
                bmpImg =  new Bitmap(new MemoryStream((byte[])adRow["adImage"]));

                linkUrl = adRow["adUrl"] == DBNull.Value ? null : (string)adRow["adUrl"];

                appId = adRow["appId"] == DBNull.Value ? 0 : (int)adRow["appId"];
                //cssAdRate = adRow["cssAdRate"] == DBNull.Value ? 0 : (int)adRow["cssAdRate"];
                //payPalTransaction = adRow["PayPalTransaction"] == DBNull.Value ? null : (string)adRow["PayPalTransaction"];
                //adStartDate = adRow["adStartDate"] == DBNull.Value ? Convert.ToDateTime("1/1/1980") : (DateTime)adRow["adStartDate"];
                //adEndDate = adRow["adEndDate"] == DBNull.Value ? Convert.ToDateTime("1/1/1980") : (DateTime)adRow["adEndDate"];
                //agreeToTermsDate = adRow["agreeToTermsDate"] == DBNull.Value ? Convert.ToDateTime("1/1/1980") : (DateTime)adRow["agreeToTermsDate"];

                retVal = true;
            }
        }
        finally
        {
            con.Close();
        }
        return retVal;
    }
}