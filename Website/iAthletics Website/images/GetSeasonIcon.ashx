<%@ WebHandler Language="C#" Class="GetSeasonIcon" %>

using System;
using System.Web;
using System.IO;
using System.Data.SqlClient;
using System.Data;

public  class GetSeasonIcon : DatabaseImage
{
    protected override string QueryString(HttpContext context)
    {
        return "SELECT seasonIcon FROM Seasons WHERE SeasonId = @SeasonId";
    }

    protected override void SetParameters(HttpContext context, SqlCommand cmd)
    {
        cmd.Parameters.AddWithValue("SeasonId",context.Request.QueryString["SeasonId"]); 
    }

    protected override string ConnectionString(HttpContext context)
    {
        return (string)context.Application["DB_CONNECTION_STRING"];
    }
} 
