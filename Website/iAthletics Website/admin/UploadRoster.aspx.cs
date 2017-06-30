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
            string delStmt = "DELETE FROM RosterUpload WHERE (teamId = @teamId AND appId = @appId)";

            SqlConnection con = new SqlConnection(conStr);
            con.Open();
            SqlCommand cmd = new SqlCommand(delStmt, con);
            cmd.Parameters.AddWithValue("@teamId", Session["TeamIdParam"]);
            cmd.Parameters.AddWithValue("@appId", Session["AppIdParam"]);
            int retVal = cmd.ExecuteNonQuery();

            // read the csv file and put in into the RosterUpload table
            //
            HttpPostedFile file = CsvFile.PostedFile;
            StreamReader CsvStream = new StreamReader(file.InputStream);

            String insertStmt = "INSERT INTO RosterUpload(" +
                    "teamId, appId, playerName, playerNumber, playerGrade, " +
                    "playerHeight, playerWeight,playerPositions)" +
                    "VALUES(@teamId, @appId, @playerName, @playerNumber," +
                "@playerGrade, @playerHeight, @playerWeight, @playerPosition)";

            cmd = new SqlCommand(insertStmt, con);

            // add the teamId and appId to the parameters, and set the values
            //
            cmd.Parameters.AddWithValue("@teamId", Session["TeamIdParam"]);
            cmd.Parameters.AddWithValue("@appId", Session["AppIdParam"]);

            // just add the player info w/o values
            //
            cmd.Parameters.Add("@playerName", SqlDbType.VarChar, 75).IsNullable = false;
            cmd.Parameters.Add("@playerNumber", SqlDbType.VarChar, 5).IsNullable = true;
            cmd.Parameters.Add("@playerGrade", SqlDbType.VarChar, 12).IsNullable = true;
            cmd.Parameters.Add("@playerHeight", SqlDbType.VarChar, 5).IsNullable = true;
            cmd.Parameters.Add("@playerWeight", SqlDbType.VarChar, 10).IsNullable = true;
            cmd.Parameters.Add("@playerPosition", SqlDbType.VarChar, 25).IsNullable = true;

            try
            {
                using (CsvReader csv = new CsvReader(CsvStream, HasHeader.Checked))
                {
                    // missing fields are treated as nulls and handled in the code as such
                    //
                    csv.MissingFieldAction = MissingFieldAction.ReplaceByNull;
                    csv.DefaultParseErrorAction = ParseErrorAction.AdvanceToNextLine;

                    if (csv.FieldCount > 0)
                    {
                        while (csv.ReadNextRecord())
                        {
                            //skip any player that has no name
                            //
                            if (csv[0] != null && csv[0].Length > 0)
                            {
                                for (int i = 0; i < 6; i++)
                                {

                                    if (csv.FieldCount > i && csv[i] != null)
                                        cmd.Parameters[i + 2].Value = csv[i];
                                    else
                                        cmd.Parameters[i + 2].Value = DBNull.Value;
                                }

                                // save the record
                                //
                                retVal = cmd.ExecuteNonQuery();
                            }
                        }
                        WizardStep.ActiveViewIndex = 1;

                        UploadedPlayersView.DataBind();
                    }
                }
                ErrMsgLbl.Visible = false;
            }
            catch (Exception csvException)
            {
                ErrMsgLbl.Text = csvException.Message;
                ErrMsgLbl.Visible = true;
            }

            con.Close();
        }

    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        WizardStep.ActiveViewIndex = 0;
    }
    protected void YesBtn_Click(object sender, EventArgs e)
    {
        string conStr = (string)Application["DB_CONNECTION_STRING"];
        string insertStmt = "INSERT INTO Rosters(teamId, appId, playerName, playerNumber, " +
            "playerGrade, playerHeight, playerWeight, playerPositions) " +
            "SELECT teamId, appId, playerName, playerNumber, playerGrade, playerHeight, " +
            "playerWeight, playerPositions FROM RosterUpload " +
            "WHERE (teamId = @teamId AND appId = @appId)";

        SqlConnection con = new SqlConnection(conStr);
        con.Open();
        SqlCommand cmd = new SqlCommand(insertStmt, con);
        cmd.Parameters.AddWithValue("@teamId", Session["TeamIdParam"]);
        cmd.Parameters.AddWithValue("@appId", Session["AppIdParam"]);
        int retVal = cmd.ExecuteNonQuery();

        con.Close();
        Response.Redirect("~/admin/TeamRoster.aspx");
    }
}
