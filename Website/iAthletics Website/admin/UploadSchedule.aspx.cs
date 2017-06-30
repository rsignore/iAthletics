using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using LumenWorks.Framework.IO.Csv;
using System.IO;
using System.Text;



public partial class admin_TeamSchedule : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String appStr = Session["AppIdParam"].ToString();
        String teamStr = Session["TeamIdParam"].ToString(); ;

        //        String appStr = Request.Params["appId"];
        //        String teamStr = Request.Params["teamId"];

        if (appStr != null && teamStr != null)
        {
            int appId = Convert.ToInt32(appStr);
            int teamId = Convert.ToInt32(teamStr);
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string appNameQry = String.Format(
                "EXECUTE dbo.SelectAppNameTeamNameSportName @appId = {0}, @teamId = {1}",
                appId, teamId);

            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand(appNameQry, con);

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
                    //                    TeamsHyperlink.NavigateUrl = "~/admin/Teams.aspx?appId=" + appStr;
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

    protected void UploadBtn_Click(object sender, EventArgs e)
    {
        if (CsvFile.HasFile)
        {
            // delete any existing upload records in the upload table
            //
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string delStmt = "DELETE FROM ScheduleUpload WHERE (teamId = @teamId AND appId = @appId)";

            SqlConnection con = new SqlConnection(conStr);
            con.Open();
            SqlCommand cmd = new SqlCommand(delStmt, con);
            cmd.Parameters.AddWithValue("@teamId", Session["TeamIdParam"]);
            cmd.Parameters.AddWithValue("@appId", Session["AppIdParam"]);
            int retVal = cmd.ExecuteNonQuery();

            // read the csv file and put in into the ScheduleUpload table
            //
            HttpPostedFile file = CsvFile.PostedFile;
            StreamReader CsvStream = new StreamReader(file.InputStream);

            String insertStmt = "INSERT INTO ScheduleUpload(" +
                    "teamId, appId, scheduleName, scheduleDateTime, venuId, " +
                    "note)" +
                    "VALUES(@teamId, @appId, @scheduleName, @scheduleDateTime," +
                "@venuId, @note)";

            cmd = new SqlCommand(insertStmt, con);

            // add the teamId and appId to the parameters, and set the values
            //
            cmd.Parameters.AddWithValue("@teamId", Session["TeamIdParam"]);
            cmd.Parameters.AddWithValue("@appId", Session["AppIdParam"]);

            // set up the parameter types and nullablity
            //
            cmd.Parameters.Add("@scheduleName", SqlDbType.VarChar, 50).IsNullable = false;
            cmd.Parameters.Add("@scheduleDateTime", SqlDbType.SmallDateTime, 5).IsNullable = false;
            cmd.Parameters.Add("@venuId", SqlDbType.Int, 12).IsNullable = false;
            cmd.Parameters.Add("@note", SqlDbType.VarChar, 50).IsNullable = true;


            try
            {
                using (CsvReader csv = new CsvReader(CsvStream, HasHeader.Checked))
                {
                    // missing fields are treated as nulls and handled in the code as such
                    //
                    csv.MissingFieldAction = MissingFieldAction.ReplaceByNull;
                    csv.DefaultParseErrorAction = ParseErrorAction.AdvanceToNextLine;

                    while (csv.ReadNextRecord())
                    {
                        for (int i = 0; i < 4; i++)
                        {

                            if (csv.FieldCount > i && csv[i] != null)
                            {
                                switch (cmd.Parameters[i + 2].SqlDbType)
                                {
                                    case SqlDbType.Int:
                                        {
                                            int outInt;

                                            if (int.TryParse(csv[i].ToString(), out outInt))
                                            {
                                                cmd.Parameters[i + 2].Value = outInt;
                                            }
                                            else
                                            {
                                                cmd.Parameters[i + 2].Value = DBNull.Value;
                                            }
                                        }
                                        break;

                                    case SqlDbType.SmallDateTime:
                                        {
                                            DateTime outDateTime;

                                            if (DateTime.TryParse(csv[i].ToString(), out outDateTime))
                                            {
                                                cmd.Parameters[i + 2].Value = outDateTime;
                                            }
                                            else
                                                cmd.Parameters[i + 2].Value = DBNull.Value;
                                        }
                                        break;

                                    case SqlDbType.VarChar:
                                    default:
                                        cmd.Parameters[i + 2].Value = csv[i].ToString();
                                        break;
                                }
                            }
                            else
                                cmd.Parameters[i + 2].Value = DBNull.Value;
                        }

                        // save the record if the required data exists
                        //
                        if (cmd.Parameters["@scheduleName"].Value != DBNull.Value &&
                            cmd.Parameters["@scheduleDateTime"].Value != DBNull.Value &&
                            cmd.Parameters["@venuId"].Value != DBNull.Value)
                        {
                            retVal = cmd.ExecuteNonQuery();
                        }
                    }

                    // if we reach here then everything is OK, so show the uploaded results
                    //
                    WizardStep.ActiveViewIndex = 1;
                    UploadedPlayersView.DataBind();
                }
                ErrMsgLbl.Visible = false;
            }
            catch (Exception csvException)
            {
                ErrMsgLbl.Text = csvException.Message;
                ErrMsgLbl.Visible = true;
            }
            finally
            {
                con.Close();
            }
        }
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        WizardStep.ActiveViewIndex = 0;
    }
    protected void YesBtn_Click(object sender, EventArgs e)
    {
        string conStr = (string)Application["DB_CONNECTION_STRING"];
        string insertStmt = "INSERT INTO Schedules(teamId, appId, ScheduleName, scheduleDateTime, " +
            "venuId, note, isAway, isConferenceGame) " +
            "SELECT teamId, appId, scheduleName, scheduleDateTime, venuId, note, 0, 0" +
            "FROM ScheduleUpload " +
            "WHERE (teamId = @teamId AND appId = @appId)";

        SqlConnection con = new SqlConnection(conStr);
        con.Open();
        SqlCommand cmd = new SqlCommand(insertStmt, con);
        cmd.Parameters.AddWithValue("@teamId", Session["TeamIdParam"]);
        cmd.Parameters.AddWithValue("@appId", Session["AppIdParam"]);
        int retVal = cmd.ExecuteNonQuery();

        con.Close();
        Response.Redirect("~/admin/TeamSchedule.aspx");
    }
    protected void DownloadVenus_Click(object sender, EventArgs e)
    {
        // prepare the HTTP response headers

        string attachment = "attachment; filename=venus.csv";
        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.ClearHeaders();
        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.AddHeader("content-disposition", attachment);
        HttpContext.Current.Response.ContentType = "text/csv";
        HttpContext.Current.Response.AddHeader("Pragma", "public");

        // query the DB for the venu list
        //
        string conStr = (string)Application["DB_CONNECTION_STRING"];
        string venuQry = "SELECT venuId, venuName, venuAddress1, venuAddress2, venuCity, venuState, venuZip " +
            "FROM dbo.Venus WHERE appId = @appId";

        SqlConnection con = new SqlConnection(conStr);
        con.Open();

        SqlCommand cmd = new SqlCommand(venuQry, con);
        cmd.Parameters.AddWithValue("@appId", Session["AppIdParam"]);

        // write the data in .CSV format
        //
        SqlDataReader reader = cmd.ExecuteReader();
        try
        {
            // write out the headers
            //
            HttpContext.Current.Response.Write("venuId,venuName,venuAddress1,venuAddress2,venuCity,venuState,venuZip");
            HttpContext.Current.Response.Write(Environment.NewLine);

            // write out each row
            //
            while (reader.Read())
            {
                for(int i=0; i < reader.FieldCount; i++)
                {
                    StringBuilder venuValue = new StringBuilder(Convert.ToString(reader[i]));
                    venuValue.Replace(",", "\\,"); venuValue.Replace("\"", "\\\"");

                    // if the string starts 
                    if (venuValue.Length > 0 && venuValue[0] == '0')
                        HttpContext.Current.Response.Write("\"" + venuValue.ToString() + "\"");
                    else
                        HttpContext.Current.Response.Write(venuValue.ToString());
//                    

                    if (i + 1 < reader.FieldCount)
                        HttpContext.Current.Response.Write(",");
                }
                HttpContext.Current.Response.Write(Environment.NewLine);
            }
        }
        finally
        {
            // Always call Close when done reading.
            reader.Close();
            con.Close();
        }

        // send the data to the user
        //
        HttpContext.Current.Response.End();

    }
}
