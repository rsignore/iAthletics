using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class admin_TeamLinks : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String appStr = Session["AppIdParam"].ToString();
        String teamStr = Session["TeamIdParam"].ToString() ; 
//        String appStr = Request.Params["appId"];
//        String teamStr = Request.Params["teamId"];

        if (appStr != null && teamStr != null)
        {
            int appId = Convert.ToInt32(appStr);
            int teamId = Convert.ToInt32(teamStr);
            string conStr = (string)Application["DB_CONNECTION_STRING"];
            string appNameQry = String.Format(
                "EXECUTE SelectAppNameTeamNameSportName @appId = {0}, @teamId = {1}",
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
    protected void LinkForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        LinksGrid.DataBind();
    }

    protected void LinkForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        e.Values["teamId"] = (int)Session["TeamIdParam"];
//        e.Values["teamId"] = Request.Params["teamId"]; 
    }
    protected void LinksGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        LinkForm.ChangeMode(FormViewMode.ReadOnly);
    }

    protected void LinkForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        LinksGrid.DataBind();
    }
    protected void LinkForm_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        LinksGrid.DataBind();
    }
}
