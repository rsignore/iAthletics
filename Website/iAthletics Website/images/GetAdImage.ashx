<%@ WebHandler Language="C#" Class="GetAdImage" %>

using System;
using System.Web;
using System.IO;
using System.Data.SqlClient;
using System.Data;

public class GetAdImage : DatabaseImage
{
    protected override string QueryString(HttpContext context)
    {
        return "SELECT adImage FROM ApplicationAds WHERE adId = @adId";
    }

    protected override void SetParameters(HttpContext context, SqlCommand cmd)
    {
        cmd.Parameters.AddWithValue("adId", context.Request.QueryString["adId"]); 
    }

    protected override string ConnectionString(HttpContext context)
    {
        return (string)context.Application["DB_CONNECTION_STRING"];
    }
} 
