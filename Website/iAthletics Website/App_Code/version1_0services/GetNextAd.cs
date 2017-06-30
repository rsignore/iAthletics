using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

/// <summary>
/// Summary description for GetNextAd
/// </summary>
public class GetNextAd1_0 : iAthleticsService1_0
{
    public string AdUrl;
    public string AdImageUrl;
    public string AdPhone;

	public GetNextAd1_0(): base()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public GetNextAd1_0(HttpContext context)
        : base(context)
    {
    }

    public bool ExecuteService(int appId, string deviceId)
    {
        bool retval = true;

        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "SELECT adId, adUrl, adPhone FROM GetNextAdForApp(@appId)";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("appId", appId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.HasRows)
        {
            if (reader.Read())
            {
                int adId = ReadRow(reader);

                // log the ad
                //
                LogAd(adId, appId, deviceId);
            }
        }
        else
        {
            // if nothing was returned by GetNextAdForApp it could mean that
            // no ad has ever been rendered so go and get the first ad
            FirstTimeAd(appId, deviceId);
        }

        con.Close();
        this.LogApiCall(deviceId);
        return retval;
    }

    private void FirstTimeAd(int appId, string deviceId)
    {
        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "SELECT GetAppAdsWithRowId_1.* " +
            "FROM dbo.GetAppAdsWithRowId(@appId) AS GetAppAdsWithRowId_1 " +
            "WHERE(rowNumber = 1)";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("appId", appId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.HasRows && reader.Read())
        {
            int adId = ReadRow(reader);
 
            // log the ad
            //
            LogAd(adId, appId, deviceId);
        }

        con.Close();
    }

    private void LogAd(int adId, int appId, string deviceId)
    {
        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        SqlConnection con = new SqlConnection(conStr);
        SqlCommand logCmd = new SqlCommand("EXECUTE LogAd @adId, @appId, @deviceId", con);

        logCmd.Parameters.AddWithValue("adId", adId);
        logCmd.Parameters.AddWithValue("appId", appId);
        logCmd.Parameters.AddWithValue("deviceId", deviceId);
        con.Open();

        int numRows = logCmd.ExecuteNonQuery();

        con.Close();
    }

    private int ReadRow(SqlDataReader reader)
    {
        int adId = (int)reader["adId"];

        if (reader["adUrl"].GetType() != typeof(DBNull))
            AdUrl = (string)reader["adUrl"];

        AdImageUrl = "http://iAthletics.appapro.com/images/GetAdImage.ashx?adId=" +
            adId.ToString();
        if(reader["adPhone"].GetType() != typeof(DBNull))
            AdPhone = (string)reader["adPhone"];

        return adId;
    }
}
