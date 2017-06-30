using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Applications : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // if this is a self service user then apply a filter
        // expression to the grid DS
        //
        object appId = Session["APP_ID"];
        if (appId != null)
        {
            GridDS.FilterExpression =
                String.Format("appId = {0}", Convert.ToInt32(appId));

            // select the first row for the self service user
            AppsGrid.SelectedIndex = 0;
        }
    }

    protected void AddNewAppButton_Click(object sender, EventArgs e)
    {
        AppForm.ChangeMode(FormViewMode.Insert);
    }

    protected void AppForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        AppsGrid.DataBind();
    }

    protected void EditAppButton_Click(object sender, EventArgs e)
    {
        AppForm.ChangeMode(FormViewMode.Edit);
    }
    protected void AppForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        AppsGrid.DataBind();
    }
    protected void AppsGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        AppForm.ChangeMode(FormViewMode.ReadOnly);
    }

    protected void TeamsButton_Click(object sender, EventArgs e)
    {
        int selectedApp = (int)AppsGrid.SelectedValue;

        Session["AppIdParam"] = selectedApp;
        Response.Redirect("~/admin/Teams.aspx");
        //Response.Redirect("~/admin/Teams.aspx?appId=" + selectedApp.ToString());
    }
    protected void NewsButton_Click(object sender, EventArgs e)
    {
        int selectedApp = (int)AppsGrid.SelectedValue;

        Session["AppIdParam"] = selectedApp;
        Response.Redirect("~/admin/NewsLinks.aspx");
//        Response.Redirect("~/admin/NewsLinks.aspx?appId=" + selectedApp.ToString());
    }
    protected void AdButton_Click(object sender, EventArgs e)
    {
        int selectedApp = (int)AppsGrid.SelectedValue;

        Session["AppIdParam"] = selectedApp;
        Response.Redirect("~/admin/ApplicationAds.aspx");
//        Response.Redirect("~/admin/ApplicationAds.aspx?appId=" + selectedApp.ToString());
    }
    protected void ShowButton_Init(object sender, EventArgs e)
    {
        Button me = (Button)sender;
        me.Visible = (Session["APP_ID"] == null);
    }
}
