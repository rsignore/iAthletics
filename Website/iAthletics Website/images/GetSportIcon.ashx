<%@ WebHandler Language="C#" Class="GetSportIcon" %>

using System;
using System.Web;
using System.IO;
using System.Data.SqlClient;
using System.Data;

public class GetSportIcon : IHttpHandler 
{
    public void ProcessRequest (HttpContext context) 
    {
        int sportId;
        
        string idStr = context.Request.QueryString["sportId"];
        if (idStr != null)
        {
            sportId = Convert.ToInt32(idStr);
        }
        else
        {
            throw new ArgumentException("No parameter specified");
        }
        
        context.Response.ContentType = "image/png";
        Stream strm = GetImage(context, sportId);

        if (strm != null)
        {
            byte[] buffer = new byte[4096];
            int byteSeq = strm.Read(buffer, 0, 4096);

            while (byteSeq > 0)
            {
                context.Response.OutputStream.Write(buffer, 0, byteSeq);
                byteSeq = strm.Read(buffer, 0, 4096);
            }
        }
    }

    private Stream GetImage(HttpContext context, int sportId)
    {
        string conn = (string)context.Application["DB_CONNECTION_STRING"];
        SqlConnection connection = new SqlConnection(conn);
        
        string sql = "SELECT sportIcon FROM Sports WHERE sportId = @sportId";
        SqlCommand cmd = new SqlCommand(sql, connection);
        cmd.CommandType = CommandType.Text;
        cmd.Parameters.AddWithValue("@sportId", sportId);
        connection.Open();
        object img = cmd.ExecuteScalar();
        try
        {
            return new MemoryStream((byte[])img);
        }
        catch
        {
            return null;
        }
        finally
        {
            connection.Close();
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}