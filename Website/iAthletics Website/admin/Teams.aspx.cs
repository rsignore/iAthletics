using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class admin_Teams : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // pass appId in Session
        //
        int appId = Convert.ToInt32(Session["AppIdParam"]);
//        int appId = Convert.ToInt32(Request.Params["appId"]);
        string appNameQry = "SELECT appName FROM Applications WHERE appId = " + appId.ToString();
        string conStr = (string)Application["DB_CONNECTION_STRING"];

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();
        try
        {
            if(reader.Read())
            {
                string appName = (string)reader["appName"];
                if (appName != null)
                {
                    AppLabel.Text = appName;
                }
                else
                {
                    AppLabel.Text = "";
                }
            }
        }
        finally
        {
            // Always call Close when done reading.
            reader.Close();
            con.Close();
        }
    }
    protected void AddButton_Click(object sender, EventArgs e)
    {
        TeamForm.ChangeMode(FormViewMode.Insert);
    }
    protected void TeamForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        TeamGrid.DataBind();
    }

    protected void TeamForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        // get AppId from the Session
        //
        int appId = Convert.ToInt32(Session["AppIdParam"]);
        e.Values["appId"] = appId.ToString();

//        e.Values["appId"] = Request.Params["appId"];
    }

    protected void TeamGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        TeamForm.ChangeMode(FormViewMode.ReadOnly);
    }

    protected void EditButton_Click(object sender, EventArgs e)
    {
        TeamForm.ChangeMode(FormViewMode.Edit);
    }

    protected void TeamForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        TeamGrid.DataBind();
    }
    protected void ScheduleButton_Click(object sender, EventArgs e)
    {
        DataKey keyVals = TeamGrid.SelectedDataKey;
        if (keyVals != null)
        {
            // pass appId and teamId as Session values
            //
            Session["AppIdParam"] = (int)keyVals["appId"];
            Session["TeamIdParam"] = (int)keyVals["teamId"];

            Response.Redirect("~/admin/TeamSchedule.aspx");
            
//            int teamId = (int)keyVals["teamId"];
//           int appId = (int)keyVals["appId"];
            
//            Response.Redirect("~/admin/TeamSchedule.aspx?appId=" + appId.ToString() +
//                "&teamId="+teamId.ToString());
        }
    }
    protected void RosterButton_Click(object sender, EventArgs e)
    {
        DataKey keyVals = TeamGrid.SelectedDataKey;
        if (keyVals != null)
        {
            // pass appId and teamId as Session values
            //
            Session["AppIdParam"] = (int)keyVals["appId"];
            Session["TeamIdParam"] = (int)keyVals["teamId"];

            Response.Redirect("~/admin/TeamRoster.aspx");

//            int teamId = (int)keyVals["teamId"];
//            int appId = (int)keyVals["appId"];

//            Response.Redirect("~/admin/TeamRoster.aspx?appId=" + appId.ToString() +
//                "&teamId=" + teamId.ToString());
        }
    }
    protected void EditPhoto_Click(object sender, EventArgs e)
    {
        DataKey keyVals = TeamGrid.SelectedDataKey;
        if (keyVals != null)
        {
            // pass appId and teamId as Session values
            //
            Session["AppIdParam"] = (int)keyVals["appId"];
            Session["TeamIdParam"] = (int)keyVals["teamId"];

            Response.Redirect("~/admin/EditTeamPhoto.aspx");

//            int teamId = (int)keyVals["teamId"];
//            int appId = (int)keyVals["appId"];

//            Response.Redirect("~/admin/EditTeamPhoto.aspx?appId=" + appId.ToString() +
//                "&teamId=" + teamId.ToString());
        }
    }
    protected void EditLinksButton_Click(object sender, EventArgs e)
    {
        DataKey keyVals = TeamGrid.SelectedDataKey;
        if (keyVals != null)
        {
            // pass appId and teamId as Session values
            //
            Session["AppIdParam"] = (int)keyVals["appId"];
            Session["TeamIdParam"] = (int)keyVals["teamId"];

            Response.Redirect("~/admin/TeamLinks.aspx");

//            int teamId = (int)keyVals["teamId"];
//            int appId = (int)keyVals["appId"];

//            Response.Redirect("~/admin/TeamLinks.aspx?appId=" + appId.ToString() +
//                "&teamId=" + teamId.ToString());
        }
    }
    protected void TeamGridDS_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {

    }
}
