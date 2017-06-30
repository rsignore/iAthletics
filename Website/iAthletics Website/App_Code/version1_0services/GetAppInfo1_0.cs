using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

/// <summary>
/// Summary description for GetAppInfo1_0
/// </summary>
public class GetAppInfo1_0 : iAthleticsService1_0
{
    public string Status;
    public string Message;
    public string CurrentVersionUrl;

    public GetAppInfo1_0(HttpContext context) :
        base(context)
    {

    }

    public GetAppInfo1_0() : base()
    {

    }

    public bool ExecuteService(int appId, string deviceId, string deviceOS, float deviceVer)
    {
        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "EXECUTE DoesAppExist @appId";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("appId", appId);

        con.Open();
        int appCount = (int)cmd.ExecuteScalar();

        if (appCount == 1)
        {
            this.Status = "Available";
            CheckForUpgrade(deviceOS, deviceVer);

        }
        else
        {
            this.Status = "Unavailable";
            this.Message = "The application for your organization is not available at this time.";
        }

        LogApiCall(deviceId);
        con.Close();
        return true;
    }

    private bool CheckForUpgrade(string deviceOs, float deviceVer)
    {
        bool retVal = false;

        if (deviceOs != null && deviceOs.Length > 0)
        {
            string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
            string appNameQry = "EXECUTE GetClientOsInfo @clientOs";

            SqlConnection con = new SqlConnection(conStr);
            SqlCommand cmd = new SqlCommand(appNameQry, con);

            cmd.Parameters.AddWithValue("clientOs", deviceOs);

            con.Open();
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.HasRows == true && reader.Read())
            {

                double currentVer = (double)reader["currentVersion"];

                if (currentVer > deviceVer)
                {
                    this.Message = "Upgrade";
                    this.CurrentVersionUrl = (string)reader["currentVersionUrl"];
                    retVal = true;
                }
            }

            con.Close();
        }

        return retVal;
    }
}
