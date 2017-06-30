using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;


public class Player
{
    public string Name;
    public string Number;
    public string Grade;
    public string Height;
    public string Weight;
    public string Positions;
}
/// <summary>
/// Summary description for GetTeamRoster1_0
/// </summary>
public class GetTeamRoster1_0: iAthleticsService1_0
{
    public List<Player> Roster;

	public GetTeamRoster1_0():
        base()
	{
        Init();
	}

    public GetTeamRoster1_0(HttpContext context) :
        base(context)
    {
        Init();
    }

    private void Init()
    {
        Roster = new List<Player>();
    }

    public bool ExecuteService(int appId, string deviceId, int teamId)
    {
        bool retval = true;

        string conStr = (string)context.Application["DB_CONNECTION_STRING_LIVE"];
        string appNameQry = "EXECUTE GetTeamRoster @teamId";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        cmd.Parameters.AddWithValue("teamId", teamId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.HasRows == true)
        {
            while (reader.Read())
            {
                Player newPlayer = new Player();

                if (reader["playerName"].GetType() != typeof(DBNull)) 
                    newPlayer.Name = (string)reader["playerName"];

                if (reader["playerNumber"].GetType() != typeof(DBNull))
                    newPlayer.Number = (string)reader["playerNumber"];

                if (reader["playerGrade"].GetType() != typeof(DBNull))
                newPlayer.Grade = (string)reader["playerGrade"];

                if (reader["playerHeight"].GetType() != typeof(DBNull)) 
                    newPlayer.Height = (string)reader["playerHeight"];

                if (reader["playerWeight"].GetType() != typeof(DBNull)) 
                    newPlayer.Weight = (string)reader["playerWeight"];

                if (reader["playerPositions"].GetType() != typeof(DBNull)) 
                    newPlayer.Positions = (string)reader["playerPositions"];

                Roster.Add(newPlayer);
            }
        }

        con.Close();
        this.LogApiCall(deviceId);
        return retval;
    }
  
}
