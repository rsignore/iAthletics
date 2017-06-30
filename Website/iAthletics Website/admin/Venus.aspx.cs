using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Venus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Parameter appIdParam = null;

        // use the self service user app id to filter the venu table
        //
        if (Session["APP_ID"] != null)
        {
            appIdParam = new SessionParameter("appId", "APP_ID");
            AppSelectPanel.Visible = false;
        }
        else
        {
            // use the control on the page to filter venus by app
            //
            appIdParam = new ControlParameter("appId", "AppIdDropDown", "SelectedValue");
            AppSelectPanel.Visible = true;
        }

        VenusGridDs.FilterParameters.Clear();
        VenusGridDs.FilterParameters.Add(appIdParam);

        // the venus page can be called from the schedule page if a new
        // venu needed to be added. if that's the case, put the form into insert mode
        //
        if (Session["SCHEDULE_INTERRUPT_INFO"] != null)
        {
            VenuForm.ChangeMode(FormViewMode.Insert);
        }
    }

    protected void VenuForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        VenuGrid.DataBind();

        // if this page was called from the team schedule page because
        // the user need to create a new venu, go back to the team page
        //
        InterruptedSchedule interrInfo = (InterruptedSchedule)Session["SCHEDULE_INTERRUPT_INFO"];
        if (interrInfo != null)
        {
            Response.Redirect("~/admin/TeamSchedule.aspx");
//            Response.Redirect(
//                String.Format("~/admin/TeamSchedule.aspx?appId={0}&teamId={1}",
//                    interrInfo.appId, interrInfo.teamId));
        }
    }

    protected void VenuGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        VenuForm.ChangeMode(FormViewMode.ReadOnly);
    }

    protected void VenuForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        VenuGrid.DataBind();
    }

    protected void AppIdDropDown_SelectedIndexChanged(object sender, EventArgs e)
    {
        // show the first page of venus
        //
        VenuGrid.PageIndex = 1;
    }
    protected void VenuForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        int appId;

        // set the appId parameter to the inster statement depending on
        // where we're getting the appId from
        //
        if (Session["APP_ID"] != null)
        {
            // get the appId from the self service user's appId
            //
            appId = (int)Session["APP_ID"];
        }
        else
        {
            // get from the control on the form
            //
            appId = Convert.ToInt32(AppIdDropDown.SelectedValue);
        }

        e.Values.Add("appId", appId);

    }
    protected void InsertCancelButton_Click(object sender, EventArgs e)
    {
        // if this page was called from the team schedule page because
        // the user need to create a new venu, go back to the team page
        //
        InterruptedSchedule interrInfo = (InterruptedSchedule)Session["SCHEDULE_INTERRUPT_INFO"];
        if (interrInfo != null)
        {
            Response.Redirect("~/admin/TeamSchedule.aspx");
//            Response.Redirect(
//                String.Format("~/admin/TeamSchedule.aspx?appId={0}&teamId={1}",
//                    interrInfo.appId, interrInfo.teamId));
        }
    }
}
