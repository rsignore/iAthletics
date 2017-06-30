using System;
using System.Web;
using System.IO;
using System.Data.SqlClient;
using System.Data;

public abstract class DatabaseImage : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "image/png";
        Stream strm = GetImage(context);

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

    protected abstract string QueryString(HttpContext context);
    protected abstract string ConnectionString(HttpContext context);
    protected abstract void SetParameters(HttpContext context, SqlCommand cmd);

    private Stream GetImage(HttpContext context)
    {
        string conn = ConnectionString(context);
        SqlConnection connection = new SqlConnection(conn);

        string sql = QueryString(context);
        SqlCommand cmd = new SqlCommand(sql, connection);
        cmd.CommandType = CommandType.Text;
        SetParameters(context, cmd);
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

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}
