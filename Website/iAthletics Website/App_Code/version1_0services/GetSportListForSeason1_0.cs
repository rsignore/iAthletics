using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

//Sports.sportName, Sports.sportId, Teams.teamId, Teams.teamName

public class SportListItem
{
    public string   SportName;
    public string   SportIconUrl;
    public string   TeamName;
    public int      TeamId;
}

/// <summary>
/// Summary description for GetSportListForSeason1_0
/// </summary>
public class GetSportListForSeason1_0: iAthleticsService1_0
{
    public List<SportListItem> SportListItems;

	public GetSportListForSeason1_0():
        base()
	{
        Init();
	}

    public GetSportListForSeason1_0(HttpContext context) :
        base(context)
    {
        Init();
    }

    private void Init()
    {
        SportListItems = new List<SportListItem>();
    }

    public bool ExecuteService(int appId, string deviceId, int seasonId)
    {
        bool retval = true;

        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "EXECUTE GetSportListForSeason @appId, @seasonId";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("appId", appId);
        cmd.Parameters.AddWithValue("seasonId", seasonId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.HasRows == true)
        {
            while (reader.Read())
            {
                SportListItem newItem = new SportListItem();

                newItem.SportName = (string)reader["sportName"];
                newItem.SportIconUrl = "http://iathletics.appapro.com/images/GetSportIcon.ashx?sportId=" +
                    ((int)reader["sportId"]).ToString();
                newItem.TeamId = (int)reader["teamId"];
                newItem.TeamName = (string)reader["teamName"];

                this.SportListItems.Add(newItem);
            }
        }

        this.LogApiCall(deviceId);
        con.Close();

        return retval;
    }
}
