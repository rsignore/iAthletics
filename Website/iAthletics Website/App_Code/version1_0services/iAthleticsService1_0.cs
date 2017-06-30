using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

/// <summary>
/// Summary description for iAthleticsService
/// </summary>
public class iAthleticsService1_0
{
    // public member variables are returned by web methods
    //
    public string ApiVersion;

    protected HttpContext _context;
    protected HttpContext context
    {
        get { return _context; }
    }

	public iAthleticsService1_0()
	{
        ApiVersion = "1.0";
	}

    public iAthleticsService1_0(HttpContext context) : this()
    {
        _context = context;
    }

    protected void LogApiCall(string deviceId)
    {
        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "EXECUTE LogApiCall @deviceId, @apiName";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("apiName", this.ToString());
        cmd.Parameters.AddWithValue("deviceId", deviceId);

        con.Open();
        cmd.ExecuteNonQuery();

        con.Close();
    }
}
