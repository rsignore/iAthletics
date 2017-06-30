using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;


public class Address
{
    public string Address1;
    public string Address2;
    public string City;
    public string State;
    public string Zip;
    public string Phone;
    public string WebUrl;
}

public class Venu: Address
{
    public string VenuName;
}


public class Event
{
    // Schedules.scheduleDateTime, Teams.teamName, Sports.sportName, Schedules.scheduleName, 
    // Sports.sportId, Venus.venuName, Venus.venuAddress1, Venus.venuAddress2, Venus.venuCity, 
    // Venus.venuState, Venus.venuZip, Venus.venuPhone, Venus.venuWebsite, Schedules.scheduleId, 
    // Schedules.isAway, Schedules.isConferenceGame, Schedules.note, Schedules.result

    public Event()
    {
        EventVenu = new Venu();
    }

    public int eventId;
    public DateTime EventDateTime;
    public string TeamName;
    public string SportName;
    public string EventName;
    public string IconUrl;
    public bool AwayEvent;
    public bool ConferenceEvent;
    public string Notes;
    public string Results;
    public Venu EventVenu;
}

/// <summary>
/// Summary description for GetNextEvent1_0
/// </summary>
public class GetNextEvent1_0 : GetUpcommingEvents1_0
{
    protected override string GetQueryString()
    {
        return "EXECUTE GetNextEvent @appId";
    }

	public GetNextEvent1_0():
        base()
	{

	}

    public GetNextEvent1_0(HttpContext context):
        base(context)
    {

    }
}
