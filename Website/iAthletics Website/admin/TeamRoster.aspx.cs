using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

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

    protected void RosterForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        RosterGrid.DataBind();
    }

    protected void RosterForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        // set the appId and teamId parameters
        //
        e.Values["appId"] = (int)Session["AppIdParam"];
        e.Values["teamId"] = (int)Session["TeamIdParam"]; 
        
//        e.Values["appId"] = Request.Params["appId"];
//        e.Values["teamId"] = Request.Params["teamId"]; 
    }

    protected void RosterGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        RosterForm.ChangeMode(FormViewMode.ReadOnly);
    }

    protected void RosterForm_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        RosterForm.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void RosterForm_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        RosterGrid.DataBind();
    }
    protected void RosterForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        RosterGrid.DataBind();
    }
    protected void DeleteRosterBtn_Init(object sender, EventArgs e)
    {
        Button me = (Button)sender;
        me.Visible = (RosterGrid.Rows.Count > 0);
    }
    protected void DeleteRosterBtn_Click(object sender, EventArgs e)
    {
        String teamStr = Session["TeamIdParam"].ToString();
        String appStr = Session["AppIdParam"].ToString();

        string conStr = (string)Application["DB_CONNECTION_STRING"];
        string updateQry = String.Format("DELETE FROM Rosters WHERE (teamId = {0} AND appId = {1})", teamStr, appStr);

        SqlConnection con = new SqlConnection(conStr);
        con.Open();
        SqlCommand cmd = new SqlCommand(updateQry, con);

        int retVal = cmd.ExecuteNonQuery();
        con.Close();

        RosterGrid.DataBind();
        RosterForm.ChangeMode(FormViewMode.ReadOnly);

        //turn the delete button off
        //
        Button me = (Button)sender;
        me.Visible = false;
    }

    protected void UploadBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/admin/UploadRoster.aspx");
    }
}
