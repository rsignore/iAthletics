using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

public class NewsLink
{
    public string LinkName;
    public string LinkDescription;
    public string LinkUrl;
    public string LinkIconUrl;
    public int    LinkTypeId;
}

/// <summary>
/// Summary description for GetAppNewsLinks1_0: iAthleticsService1_0
/// </summary>
public class GetAppNewsLinks1_0: iAthleticsService1_0
{
    public List<NewsLink> NewsLinks;

	public GetAppNewsLinks1_0():
        base()
	{
		Init();
	}

    public GetAppNewsLinks1_0(HttpContext context) :
        base(context)
    {
		Init();
    }

    private void Init()
    {
        NewsLinks = new List<NewsLink>();
    }

    public bool ExecuteService(int appId, string deviceId)
    {
        bool retval = true;

        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "EXECUTE [GetAppNewsLinks] @appId";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("appId", appId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();


        if (reader.HasRows)
        {
            while (reader.Read())
            {
                NewsLink newLink = new NewsLink();

                newLink.LinkName = (string)reader["newsLinkName"];
                if(reader["newsLinkDescription"].GetType() != typeof(DBNull))
                {
                    newLink.LinkDescription = (string)reader["newsLinkDescription"];
                }
                newLink.LinkUrl = (string)reader["newsLinkUrl"];
                newLink.LinkIconUrl = "http://iathletics.appapro.com/images/GetLinkTypeIcon.ashx?linkTypeId="
                    + ((int)reader["linkTypeId"]).ToString();
                newLink.LinkTypeId = (int)reader["linkTypeId"];
                NewsLinks.Add(newLink);
            }
        }

        con.Close();

        this.LogApiCall(deviceId);
        return retval;
    }
}
