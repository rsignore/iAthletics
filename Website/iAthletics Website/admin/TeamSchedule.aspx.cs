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
        // get the app and team fron the session
        //
        String appStr = Session["AppIdParam"].ToString();
        String teamStr = Session["TeamIdParam"].ToString();

//        String appStr = Request.Params["appId"];
//        String teamStr = Request.Params["teamId"];

        if(appStr != null && teamStr != null)
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

        // are we being called from the venu page in response to a request by the user
        // to create a new venu
        //
        InterruptedSchedule interrInfo = (InterruptedSchedule)Session["SCHEDULE_INTERRUPT_INFO"];
        if (interrInfo != null)
        {
            if (interrInfo.interruptType == InterruptedScheduleType.Insert)
                ScheduleForm.ChangeMode(FormViewMode.Insert);
            //else
            //    ScheduleForm.ChangeMode(FormViewMode.Edit);

            // get rid of he saved interrupt info
            //
            Session.Remove("SCHEDULE_INTERRUPT_INFO");
        }
    }

    protected void ScheduleForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        // set the appId and teamId parameters
        //
        // set from session object
        //
        e.Values["appId"] = (int)Session["AppIdParam"];
        e.Values["teamId"] = (int)Session["TeamIdParam"];

//        e.Values["appId"] = Request.Params["appId"];
//        e.Values["teamId"] = Request.Params["teamId"]; 
        
        // now set the date and Time parameter
        //
        e.Values["scheduleDateTime"] = BuildDateTimeFromControls((FormView)sender);
    }

    protected void ScheduleForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        ScheduleGrid.DataBind();
    }

    protected void ScheduleGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        ScheduleForm.ChangeMode(FormViewMode.ReadOnly);
    }

    private DateTime BuildDateTimeFromControls(FormView f)
    {
        DropDownList monthList = (DropDownList)f.FindControl("MonthList");
        DropDownList dayList = (DropDownList)f.FindControl("DayList");
        DropDownList yearList = (DropDownList)f.FindControl("YearList");
        DropDownList hourList = (DropDownList)f.FindControl("HourList");
        DropDownList minuteList = (DropDownList)f.FindControl("MinuteList");
        DropDownList amPmList = (DropDownList)f.FindControl("AmPmList");

        String strDate = String.Format("{0}/{1}/{2} {3}:{4:D2} {5}", monthList.SelectedValue,
            dayList.SelectedValue, yearList.SelectedValue, hourList.SelectedValue,
            Convert.ToInt32(minuteList.SelectedValue), amPmList.SelectedValue);

        DateTime retVal = Convert.ToDateTime(strDate);

        return retVal;
    }

    protected void MonthList_PreRender(object sender, EventArgs e)
    {
        HiddenField hf = (HiddenField)ScheduleForm.FindControl("ScheduleHidden");
        DateTime eventDateTime = Convert.ToDateTime(hf.Value);

        DropDownList monthList = (DropDownList)ScheduleForm.FindControl("MonthList");
        DropDownList dayList = (DropDownList)ScheduleForm.FindControl("DayList");
        DropDownList yearList = (DropDownList)ScheduleForm.FindControl("YearList");
        DropDownList hourList = (DropDownList)ScheduleForm.FindControl("HourList");
        DropDownList minuteList = (DropDownList)ScheduleForm.FindControl("MinuteList");
        DropDownList amPmList = (DropDownList)ScheduleForm.FindControl("AmPmList");

        // set the date mm/dd/yyyy
        //
        monthList.SelectedValue = eventDateTime.Month.ToString();
        dayList.SelectedValue = eventDateTime.Day.ToString();
        yearList.SelectedValue = eventDateTime.Year.ToString();

        // set the time
        //
        int hour = eventDateTime.Hour;
        if (hour > 12)
        {
            hourList.SelectedValue = Convert.ToString(hour - 12);
            amPmList.SelectedValue = "PM";
        }
        else
        {
            hourList.SelectedValue = Convert.ToString(hour);
            amPmList.SelectedValue = "AM";
        }

        minuteList.SelectedValue = eventDateTime.Minute.ToString("D2");
    }

    protected void ScheduleForm_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        //  set the date and Time parameter
        //
        e.NewValues["scheduleDateTime"] = BuildDateTimeFromControls((FormView)sender);
    }

    protected void ScheduleForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        ScheduleGrid.DataBind();
    }

    protected void ScheduleForm_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        ScheduleGrid.DataBind();
    }

    protected void CreateNewVenuButton_Click(object sender, EventArgs e)
    {
        InterruptedSchedule interrupt =
            new InterruptedSchedule((int)Session["AppIdParam"],
                (int)Session["TeamIdParam"]);

        //            new InterruptedSchedule(Convert.ToInt32(Request.Params["appId"]), 
//                Convert.ToInt32(Request.Params["teamId"]));

        // what mode is the form in
        //
        if (ScheduleForm.CurrentMode == FormViewMode.Insert)
            interrupt.interruptType = InterruptedScheduleType.Insert;
        else
            interrupt.interruptType = InterruptedScheduleType.Update;

        Session["SCHEDULE_INTERRUPT_INFO"] = interrupt;

        Response.Redirect("~/admin/Venus.aspx");
    }

    protected void DeleteEventsBtn_Init(object sender, EventArgs e)
    {
        Button me = (Button)sender;

        me.Visible = (ScheduleGrid.Rows.Count > 0);
    }

    protected void DeleteEventsBtn_Click(object sender, EventArgs e)
    {
        String teamStr = Session["TeamIdParam"].ToString();
        String appStr = Session["AppIdParam"].ToString();

        string conStr = (string)Application["DB_CONNECTION_STRING"];
        string updateQry = String.Format("DELETE FROM Schedules WHERE (teamId = {0} AND appId = {1})", teamStr, appStr);

        SqlConnection con = new SqlConnection(conStr);
        con.Open();
        SqlCommand cmd = new SqlCommand(updateQry, con);

        int retVal = cmd.ExecuteNonQuery();
        con.Close();

        ScheduleGrid.DataBind();
        ScheduleForm.ChangeMode(FormViewMode.ReadOnly);

        //turn the delete button off
        //
        Button me = (Button)sender;
        me.Visible = false;
    }
}
