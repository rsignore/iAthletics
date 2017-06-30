using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class admin_EditSportsIcon : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String sportStr = Request.Params["sportId"];


        if (sportStr != null)
        {
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string appNameQry = String.Format("SELECT sportName FROM Sports WHERE sportId = {0}",
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
        IconImage.ImageUrl = "~/images/GetSportIcon.ashx?sportId=" + Request.Params["sportId"];
    }

    protected void Remove_Click(object sender, EventArgs e)
    {
        String sportStr = Request.Params["sportId"];

        if (sportStr != null)
        {
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string updateQry = String.Format("UPDATE Sports SET sportIcon = null, iconFileName = null " +
                "WHERE(sportId = {0})", sportStr);

            SqlConnection con = new SqlConnection(conStr);
            con.Open();
            SqlCommand cmd = new SqlCommand(updateQry, con);

            int retVal = cmd.ExecuteNonQuery();
            con.Close();
        }

        Response.Redirect("~/admin/Sports.aspx");
    }
    protected void UploadButton_Click(object sender, EventArgs e)
    {
        String sportStr = Request.Params["sportId"];

        if (IconUpload.HasFile)
        {
            // make sure it's a png file
            //
            if (String.Compare(IconUpload.PostedFile.ContentType, "image/png") == 0)
            {
                string conStr = (string)Application["DB_CONNECTION_STRING"];
                string updateQry = String.Format("UPDATE Sports SET sportIcon = @sportIcon, " +
                    "iconFileName = @iconFileName WHERE (sportId = {0})", sportStr);

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

                Response.Redirect("~/admin/Sports.aspx");
            }
            else
            {
                IconFailLabel.Visible = true;
            }
        }
    }
}
