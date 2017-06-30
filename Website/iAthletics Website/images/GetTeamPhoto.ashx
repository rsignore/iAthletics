<%@ WebHandler Language="C#" Class="GetTeamPhoto" %>

using System;
using System.Web;
using System.IO;
using System.Data.SqlClient;
using System.Data;

public  class GetTeamPhoto : DatabaseImage
{
    protected override string QueryString(HttpContext context)
    {
        return "SELECT teamPhoto FROM Teams WHERE (teamId = @teamId)";
    }

    protected override void SetParameters(HttpContext context, SqlCommand cmd)
    {
        cmd.Parameters.AddWithValue("teamId",context.Request.QueryString["teamId"]); 
    }

    protected override string ConnectionString(HttpContext context)
    {
        return (string)context.Application["DB_CONNECTION_STRING"];
    }
} 
