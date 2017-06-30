using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Drawing;

public partial class admin_EditSportsIcon : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String teamStr = Session["TeamIdParam"].ToString();
        String appStr = Session["AppIdParam"].ToString();

//        String teamStr = Request.Params["teamId"];
//        String appStr = Request.Params["appId"];


        if (teamStr != null && appStr != null)
        {
            int teamId = Convert.ToInt32(teamStr);
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string qry = "SELECT Applications.appName, Teams.teamName, Sports.sportName " +
                "FROM Teams INNER JOIN " +
                      "Applications ON Teams.appId = Applications.appId INNER JOIN " +
                      "Sports ON Teams.sportId = Sports.sportId " +
                "WHERE (Teams.teamId = @teamId)";

            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand(qry, con);
            cmd.Parameters.AddWithValue("teamId", teamId);

            con.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            try
            {
                if (reader.Read())
                {
                    string appName = (string)reader["appName"];
                    string teamName = (string)reader["teamName"];
                    string sportName = (string)reader["sportName"];

                    AppLabel.Text = (appName != null) ? appName : "";
                    TeamLabel.Text = (teamName != null) ? teamName : "";
                    SportLabel.Text = (sportName != null) ? sportName : "";

                    //set the hyperlink back to the applictions teams page
                    //
                    TeamsHyperlink.Text = "Teams (" + appName + ")";
                    TeamsHyperlink.NavigateUrl = "~/admin/Teams.aspx";
                    TeamsHyperlink.NavigateUrl = "~/admin/Teams.aspx?appId=" + appStr;
                }
            }
            finally
            {
                // Always call Close when done reading.
                reader.Close();
                con.Close();
            }
        }
    }
    protected void IconImage_Load(object sender, EventArgs e)
    {
        IconImage.ImageUrl = "~/images/GetTeamPhoto.ashx?teamId=" + Session["TeamIdParam"].ToString();
//        IconImage.ImageUrl = "~/images/GetTeamPhoto.ashx?teamId=" + Request.Params["teamId"];
    }

    protected void Remove_Click(object sender, EventArgs e)
    {
        String teamStr = Session["TeamIdParam"].ToString();
//        String teamStr = Request.Params["teamId"];

        if (teamStr != null)
        {
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string updateQry = String.Format("UPDATE Teams SET teamPhoto = null, teamPhotoFileName = null " +
                "WHERE(teamId = {0})", teamStr);

            SqlConnection con = new SqlConnection(conStr);
            con.Open();
            SqlCommand cmd = new SqlCommand(updateQry, con);

            int retVal = cmd.ExecuteNonQuery();
            con.Close();
        }

        Response.Redirect("~/admin/Teams.aspx");
//        Response.Redirect("~/admin/Teams.aspx?appId=" + Request.Params["appId"]);
    }
    protected void UploadButton_Click(object sender, EventArgs e)
    {
        String teamStr = Session["TeamIdParam"].ToString();
//        String teamStr = Request.Params["teamId"];

        FileToBigLabel.Visible = false;
        IconFailLabel.Visible = false;

        if (IconUpload.HasFile)
        {
            // make sure it's a png file
            //
            if (String.Compare(IconUpload.PostedFile.ContentType, "image/x-png") == 0 ||
                String.Compare(IconUpload.PostedFile.ContentType, "image/png") == 0 ||
                String.Compare(IconUpload.PostedFile.ContentType, "image/pjpeg") == 0)
            {
                IconFailLabel.Visible = false;

                // read the file in and create a bitmap out of it so we can validate the
                // file size. We don't want a team photo who's width is > 320 px
                //
                HttpPostedFile File = IconUpload.PostedFile;

                // create a bitmap with the image data
                //
                Bitmap img = new Bitmap(File.InputStream, false);

                // check the width, make sure is <= 320
                if (img.Width <= 320)
                {
                    FileToBigLabel.Visible = false;

                    //Create a byte Array with file length
                    //
                    Byte[] imgByte = new Byte[File.ContentLength];

                    //read the data into the imgByteBuffer
                    //
                    File.InputStream.Seek(0, System.IO.SeekOrigin.Begin);
                    File.InputStream.Read(imgByte, 0, File.ContentLength);

                    string conStr = (string)Application["DB_CONNECTION_STRING"];
                    string updateQry = String.Format("UPDATE Teams SET teamPhoto = @teamPhoto, " +
                        "teamPhotoFileName = @teamPhotoFileName WHERE (teamId = {0})", teamStr);

                    SqlConnection con = new SqlConnection(conStr);
                    con.Open();
                    SqlCommand cmd = new SqlCommand(updateQry, con);

                    IconFailLabel.Visible = false;

                    // save the photo's file name
                    //
                    cmd.Parameters.AddWithValue("teamPhotoFileName", IconUpload.FileName);



                    cmd.Parameters.AddWithValue("teamPhoto", imgByte);

                    int retVal = cmd.ExecuteNonQuery();
                    con.Close();

                    Response.Redirect("~/admin/Teams.aspx");
//                    Response.Redirect("~/admin/Teams.aspx?appId=" + Request.Params["appId"]);
                }
                else
                {
                    FileToBigLabel.Visible = true;
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
        Response.Redirect("~/admin/Teams.aspx");
//        Response.Redirect("~/admin/Teams.aspx?appId=" + Request.Params["appId"]);
    }
}
