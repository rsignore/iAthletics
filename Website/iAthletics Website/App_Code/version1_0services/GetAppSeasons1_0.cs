using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;


public class AppSeason
{
    public string SeasonName;
    public int SeasonId;
    public string IconUrl;
}

/// <summary>
/// Summary description for GetAppSeasons1_0: 
/// </summary>
public class GetAppSeasons1_0 : iAthleticsService1_0
{
    public List<AppSeason> AppSeasons;

	public GetAppSeasons1_0(): 
        base()
	{
        Init();
	}

    public GetAppSeasons1_0(HttpContext context): 
        base(context)
    {
        Init();        
    }

    private void Init()
    {
        AppSeasons = new List<AppSeason>();
    }

    public bool ExecuteService(int appId, string deviceId)
    {
        bool retval = true;

        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "EXECUTE GetAppSeasons @appId";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("appId", appId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.HasRows == true)
        {
            while(reader.Read())
            {
                AppSeason season = new AppSeason();

                season.SeasonId = (int)reader["SeasonId"];
                season.SeasonName = (string)reader["SeasonName"];
                season.IconUrl = "http://iathletics.appapro.com/images/GetSeasonIcon.ashx?SeasonId=" +
                    season.SeasonId.ToString();

                AppSeasons.Add(season);
            }
        }

        con.Close();
        LogApiCall(deviceId);
        return retval;
    }
}
