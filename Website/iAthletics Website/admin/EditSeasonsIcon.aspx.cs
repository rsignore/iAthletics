using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class admin_EditSeasonsIcon : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String seasonStr = Request.Params["SeasonId"];

        if (seasonStr != null)
        {
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string appNameQry = String.Format("SELECT SeasonName FROM Seasons WHERE SeasonId = {0}",
                seasonStr);

            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand(appNameQry, con);

            con.Open();
            string seasonName = (String)cmd.ExecuteScalar();

            SeasonNameLabel.Text = (seasonName != null) ? seasonName : "nothing";

            con.Close();
        }
    }
    protected void IconImage_Load(object sender, EventArgs e)
    {
        IconImage.ImageUrl = "~/images/GetSeasonIcon.ashx?SeasonId=" + Request.Params["SeasonId"];
    }

    protected void Remove_Click(object sender, EventArgs e)
    {
        String seasonStr = Request.Params["SeasonId"];

        if (seasonStr != null)
        {
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string updateQry = String.Format("UPDATE Seasons SET seasonIcon = null, seasonIconFileName = null " +
                "WHERE(SeasonId = {0})", seasonStr);

            SqlConnection con = new SqlConnection(conStr);
            con.Open();
            SqlCommand cmd = new SqlCommand(updateQry, con);

            int retVal = cmd.ExecuteNonQuery();
            con.Close();
        }

        Response.Redirect("~/admin/Seasons.aspx");
    }
    protected void UploadButton_Click(object sender, EventArgs e)
    {
        String sportStr = Request.Params["SeasonId"];

        if (IconUpload.HasFile)
        {
            // make sure it's a png file
            //
            if (String.Compare(IconUpload.PostedFile.ContentType, "image/png") == 0)
            {
                string conStr = (string)Application["DB_CONNECTION_STRING"];
                string updateQry = String.Format("UPDATE Seasons SET seasonIcon = @sportIcon, " +
                    "seasonIconFileName = @iconFileName WHERE (SeasonId = {0})", sportStr);

                SqlConnection con = new SqlConnection(conStr);
                con.Open();
                SqlCommand cmd = new SqlCommand(updateQry, con);

                IconFailLabel.Visible = false;

                // save the icon's file name
                //
                cmd.Parameters.AddWithValue("iconFileName", IconUpload.FileName); 

                //To create a PostedFile
                HttpPostedFile File = IconUpload.PostedFile;
                //Create byte Array with file len
                Byte[] imgByte = new Byte[File.ContentLength];
                //force the control to load data in array
                File.InputStream.Read(imgByte, 0, File.ContentLength);

                cmd.Parameters.AddWithValue("sportIcon", imgByte);

                int retVal = cmd.ExecuteNonQuery();
                con.Close();

                Response.Redirect("~/admin/Seasons.aspx");
            }
            else
            {
                IconFailLabel.Visible = true;
            }
        }
    }
}
