using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using System.Data.SqlClient;
using System.IO;

/// <summary>
/// Summary description for AdEditValues
/// </summary>
public class AdEditValues
{
    private String _BusinessName;
    private TempImage _AdImage;
    private String _ClickUrl;
    private DateTime _BeginDate;
    private DateTime _EndDate;

    private HttpContext _context;

    public TempImage AdImage
    {
        get
        {
            return _AdImage;
        }
    }

    public String BusinessName
    { 
        get
        { 
            return _BusinessName;
        }
    }

    public AdEditValues(HttpContext context)
    {
        _context = context;
    }

	public AdEditValues(HttpContext context, int adId)
	{
        _context = context;

        CreateFromAdId(adId);
	}

    public int SaveImage(Bitmap image)
    {
        if (_AdImage == null)
        {
            _AdImage = new TempImage(_context);
        }

        return _AdImage.SaveImage(image);
    }

    public Boolean CreateFromAdId(int adId)
    {
        // clear our any old values
        //
        _AdImage = null;
        _BeginDate = _EndDate = Convert.ToDateTime("1/1/1980");
        _BusinessName = _ClickUrl = null;

        Boolean retVal = false;
        String qryStr = "SELECT * from ApplicationAds WHERE adId = @adId";

        string conStr = (string)_context.Application["DB_CONNECTION_STRING"];

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(qryStr, con);
        cmd.Parameters.Add("adId", (int)adId);

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.Read())
        {
            // read the easy stuff
            //
            if (reader["vendorName"] != DBNull.Value)
            {
                _BusinessName = (String)reader["vendorName"];
            }

            if(reader["adUrl"] != DBNull.Value)
            {
                _ClickUrl = (String)reader["adUrl"];
            }

            if(reader["adStartDate"] != DBNull.Value)
            {
                _BeginDate = (DateTime)reader["adStartDate"];
            }

            if(reader["adEndDate"] != DBNull.Value)
            {
                _EndDate = (DateTime)reader["adEndDate"];
            }

            // get the image
            //
            if (reader["adImage"] != DBNull.Value)
            {
                MemoryStream memStr = new MemoryStream((byte[])reader["adImage"]);
                _AdImage = new TempImage(_context, memStr);
            }

            retVal = true;

            con.Close();
        }

        return retVal;
    }
}