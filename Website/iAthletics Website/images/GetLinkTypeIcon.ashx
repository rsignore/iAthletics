<%@ WebHandler Language="C#" Class="GetLinkTypeIcon" %>

using System;
using System.Web;
using System.IO;
using System.Data.SqlClient;
using System.Data;

public  class GetLinkTypeIcon : DatabaseImage
{
    protected override string QueryString(HttpContext context)
    {
        return "SELECT linkTypeIcon FROM LinkTypes WHERE linkTypeId = @linkTypeId";
    }

    protected override void SetParameters(HttpContext context, SqlCommand cmd)
    {
        cmd.Parameters.AddWithValue("linkTypeId", context.Request.QueryString["linkTypeId"]); 
    }

    protected override string ConnectionString(HttpContext context)
    {
        return (string)context.Application["DB_CONNECTION_STRING"];
    }
} 
