using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;


/// <summary>
/// Summary description for GetTeamInfo1_0
/// </summary>
/// 


public class GetTeamInfo1_0: iAthleticsService1_0
{
    public int      TeamId;
    public string   SportName;
    public string   TeamName;
    public string   TeamPhotoUrl;
    public string   TeamOverallResults;
    public List<NewsLink>  NewsLinks;

	public GetTeamInfo1_0():
        base()
	{
        Init();
	}

    public GetTeamInfo1_0(HttpContext context) :
        base(context)
    {
        Init();
    }

    private void Init()
    {
        NewsLinks = new List<NewsLink>();
    }

    public bool ExecuteService(int appId, string deviceId, int teamId)
    {
        bool retval = true;

        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "EXECUTE GetTeamInfo @teamId";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("teamId", teamId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.HasRows == true && reader.Read())
        {
            this.TeamId = teamId;
            this.SportName = (string)reader["sportName"];
            this.TeamName = (string)reader["teamName"];
            this.TeamPhotoUrl = "http://iathletics.appapro.com/images/GetTeamPhoto.ashx?teamId=" +
                teamId.ToString();
            if (reader["teamOverallResults"].GetType() != typeof(DBNull))
                this.TeamOverallResults = (string)reader["teamOverallResults"];
//            this.NumTeamNewsLinks = (int)reader["NumLinks"];

            GetNewsLinks(teamId);
        }

        con.Close();
        this.LogApiCall(deviceId);
        return retval;
    }

    private void GetNewsLinks(int teamId)
    {
        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "EXECUTE [GetTeamNewsLinks] @teamId";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("teamId", teamId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();


        if (reader.HasRows)
        {
            while (reader.Read())
            {
                NewsLink newLink = new NewsLink();

                newLink.LinkName = (string)reader["linkName"];
                if (reader["linkDescription"].GetType() != typeof(DBNull))
                {
                    newLink.LinkDescription = (string)reader["linkDescription"];
                }
                newLink.LinkUrl = (string)reader["linkUrl"];
                newLink.LinkIconUrl = "http://iathletics.appapro.com/images/GetLinkTypeIcon.ashx?linkTypeId="
                    + ((int)reader["linkTypeId"]).ToString();
                newLink.LinkTypeId = (int)reader["linkTypeId"];
                NewsLinks.Add(newLink);
            }
        }

        con.Close();
    }
}
