using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

/// <summary>
/// Summary description for GetCompleteTeamSchedule1_0
/// </summary>
public class GetCompleteTeamSchedule1_0 : iAthleticsService1_0
{
    public List<Event> Events;

	public GetCompleteTeamSchedule1_0(): base()
	{
        Init();
	}

    public GetCompleteTeamSchedule1_0(HttpContext context)
        : base(context)
    {
        Init();
    }

    private void Init()
    {
        Events = new List<Event>();
    }

    public bool ExecuteService(int appId, string deviceId, int teamId)
    {
        bool retval = true;

        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "EXECUTE GetCompleteTeamSchedule @teamId";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("teamId", teamId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        // Schedules.scheduleDateTime, Teams.teamName, Sports.sportName, Schedules.scheduleName, 
        // Sports.sportId, Venus.venuName, Venus.venuAddress1, Venus.venuAddress2, Venus.venuCity, 
        // Venus.venuState, Venus.venuZip, Venus.venuPhone, Venus.venuWebsite, Schedules.scheduleId, 
        // Schedules.isAway, Schedules.isConferenceGame, Schedules.note, Schedules.result
        if (reader.HasRows == true)
        {
            while (reader.Read())
            {
                Event newEvent = new Event();

                newEvent.EventDateTime = (DateTime)reader["scheduleDateTime"];
                newEvent.TeamName = (string)reader["teamName"];
                newEvent.SportName = (string)reader["sportName"];
                newEvent.EventName = (string)reader["scheduleName"];
                newEvent.IconUrl = "http://iathletics.appapro.com/images/GetSportIcon.ashx?sportId=" +
                    ((int)reader["sportId"]).ToString();
                newEvent.eventId = (int)reader["scheduleId"];
                newEvent.AwayEvent = (bool)reader["isAway"];
                newEvent.ConferenceEvent = (bool)reader["isConferenceGame"];
                if (reader["note"].GetType() != typeof(DBNull))
                    newEvent.Notes = (string)reader["note"];
                if (reader["result"].GetType() != typeof(DBNull))
                    newEvent.Results = (string)reader["result"];

                // venu information
                //
                newEvent.EventVenu.VenuName = (string)reader["venuName"];
                newEvent.EventVenu.Address1 = (string)reader["venuAddress1"];
                if (reader["venuAddress2"].GetType() != typeof(DBNull))
                    newEvent.EventVenu.Address2 = (string)reader["venuAddress2"];
                newEvent.EventVenu.City = (string)reader["venuCity"];
                newEvent.EventVenu.State = (string)reader["venuState"];
                newEvent.EventVenu.Zip = (string)reader["venuZip"];
                if (reader["venuPhone"].GetType() != typeof(DBNull))
                    newEvent.EventVenu.Phone = (string)reader["venuPhone"];
                if (reader["venuWebsite"].GetType() != typeof(DBNull))
                    newEvent.EventVenu.WebUrl = (string)reader["venuWebsite"];

                Events.Add(newEvent);
            }
        }

        con.Close();

        this.LogApiCall(deviceId);
        return retval;
    }


}
