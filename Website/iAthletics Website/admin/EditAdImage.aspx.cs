using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Drawing;

public partial class admin_EditAdImage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String sportStr = Session["AdIdParam"].ToString();
//        String sportStr = Request.Params["adId"];


        if (sportStr != null)
        {
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string appNameQry = String.Format("SELECT vendorName FROM ApplicationAds WHERE adId = {0}",
                sportStr);

            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand(appNameQry, con);

            con.Open();
            string sportName = (String)cmd.ExecuteScalar();

            SportNameLabel.Text = (sportName != null) ? sportName : "nothing";

            con.Close();
        }
    }
    protected void IconImage_Load(object sender, EventArgs e)
    {
        IconImage.ImageUrl = "~/images/GetAdImage.ashx?adId=" + Session["AdIdParam"].ToString();
//        IconImage.ImageUrl = "~/images/GetAdImage.ashx?adId=" + Request.Params["adId"];
    }

    protected void Remove_Click(object sender, EventArgs e)
    {
        String sportStr = Session["AdIdParam"].ToString();
//        String sportStr = Request.Params["adId"];

        if (sportStr != null)
        {
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string updateQry = String.Format("UPDATE ApplicationAds SET adImage = null, adImageName = null " +
                "WHERE(adId = {0})", sportStr);

            SqlConnection con = new SqlConnection(conStr);
            con.Open();
            SqlCommand cmd = new SqlCommand(updateQry, con);

            int retVal = cmd.ExecuteNonQuery();
            con.Close();
        }

        Response.Redirect("~/admin/ApplicationAds.aspx");
//        Response.Redirect("~/admin/ApplicationAds.aspx?appId=" + Request.Params["appId"]);
    }
    protected void UploadButton_Click(object sender, EventArgs e)
    {
        FileSizeErrorLabel.Visible = false;
        IconFailLabel.Visible = false;

        String sportStr = Session["AdIdParam"].ToString();
//        String sportStr = Request.Params["adId"];

        if (IconUpload.HasFile)
        {
            // make sure it's a png or jpeg file file
            //
            if (String.Compare(IconUpload.PostedFile.ContentType, "image/x-png") == 0 ||
                String.Compare(IconUpload.PostedFile.ContentType, "image/png") == 0 ||
                String.Compare(IconUpload.PostedFile.ContentType, "image/pjpeg") == 0)
            {
                IconFailLabel.Visible = false;

                // read the file in and create a bitmap out of it so we can validate the
                // file size. the ad must have WxH of 320x50
                //
                HttpPostedFile File = IconUpload.PostedFile;

                // create a bitmap with the image data
                //
                Bitmap img = new Bitmap(File.InputStream, false);

                // check the width and height , make sure is the image is exactally 320x50
                //
                if (img.Width == 320 && img.Height == 50)
                {
                    FileSizeErrorLabel.Visible = false;

                    //Create a byte Array with file length
                    //
                    Byte[] imgByte = new Byte[File.ContentLength];

                    //read the data into the imgByteBuffer
                    //
                    File.InputStream.Seek(0, System.IO.SeekOrigin.Begin);
                    File.InputStream.Read(imgByte, 0, File.ContentLength);

                    string conStr = (string)Application["DB_CONNECTION_STRING"];
                    string updateQry = String.Format("UPDATE ApplicationAds SET adImage = @adImage, " +
                        "adImageName = @adImageName WHERE (adId = {0})", sportStr);

                    SqlConnection con = new SqlConnection(conStr);
                    con.Open();
                    SqlCommand cmd = new SqlCommand(updateQry, con);

                    // save the icon's file name
                    //
                    cmd.Parameters.AddWithValue("adImageName", IconUpload.FileName);

                    cmd.Parameters.AddWithValue("adImage", imgByte);

                    int retVal = cmd.ExecuteNonQuery();
                    con.Close();

                    Response.Redirect("~/admin/ApplicationAds.aspx");
//                    Response.Redirect("~/admin/ApplicationAds.aspx?appId=" + Request.Params["appId"]);
                }
                else
                {
                    FileSizeErrorLabel.Visible = true;
                }
            }
            else
            {
                IconFailLabel.Visible = true;
            }
        }
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/admin/ApplicationAds.aspx");
//        Response.Redirect("~/admin/ApplicationAds.aspx?appId=" + Request.Params["appId"]);
    }
}
