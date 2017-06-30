<%@ WebHandler Language="C#" Class="GetTempImage" %>

using System;
using System.Web;
using System.IO;
using System.Data.SqlClient;

public class GetTempImage : DatabaseImage 
{
    protected override string QueryString(HttpContext context)
    {
        return "SELECT tempImage FROM TempImage WHERE tempId = @tempId";
    }

    protected override void SetParameters(HttpContext context, SqlCommand cmd)
    {
        cmd.Parameters.AddWithValue("tempId", context.Request.QueryString["tempId"]);
    }

    protected override string ConnectionString(HttpContext context)
    {
        return (string)context.Application["DB_CONNECTION_STRING"];
    }
}