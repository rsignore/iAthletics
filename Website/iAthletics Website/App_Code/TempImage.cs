using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Drawing;
using System.Data.SqlClient;

/// <summary>
/// TempImage is used to store a tempory image in the database. It is useful when editing images
/// and provide the ability for the uer to undo the edited image before committing it to the 
/// actual application tables.
/// </summary>
public class TempImage
{
    private int _imageId = 0;
    private MemoryStream _imgageStream = null;
    private Bitmap _imageBitmap = null;
    private HttpContext _context = null;

    public int TempId { get { return _imageId; } }

	public TempImage(HttpContext context)
	{
		//
		// TODO: Add constructor logic here
		//
        _context = context;
	}

    public TempImage(HttpContext context, MemoryStream image)
    {
        _context = context;
        SaveImage(image);
    }

    // destructor
    //
     ~TempImage()
    {
        ReleaseImage();
    }

    private void SetImageId(int imageId)
    {
        _imageId = imageId;
    }

    public MemoryStream GetImageAsMemoryStream(int imageId)
    {
        SetImageId(imageId);

        return GetImageAsMemoryStream();
    }

    public Bitmap GetImageAsBitmap(int imageId)
    {
        SetImageId(imageId);

        return GetImageAsBitmap();
    }

    public Bitmap GetImageAsBitmap()
    {
        Bitmap retVal = null;
        MemoryStream memstr = (MemoryStream)GetImageAsMemoryStream();

        if (memstr != null)
        {
            retVal = new Bitmap(memstr);
        }
        return retVal;
    }

    public byte[] GetImageAsByteArray()
    {
        byte[] retVal = null;

        if (_imageId != 0)
        {
            String qryStr = "SELECT tempImage from TempImage where tempId = @tempId";

            string conStr = (string)_context.Application["DB_CONNECTION_STRING"];
            SqlConnection con = new SqlConnection(conStr);

            SqlCommand cmd = new SqlCommand(qryStr, con);
            cmd.Parameters.Add("tempId", (int)_imageId);

            con.Open();
            object img = cmd.ExecuteScalar();
            try
            {
                retVal = (byte[])img;
            }
            catch
            {
            }
            finally
            {
                con.Close();
            }
        }

        return retVal;
    }

    public MemoryStream GetImageAsMemoryStream()
    {
        MemoryStream retval = null;
        byte[] byteArr = GetImageAsByteArray();

        if (byteArr != null)
        {
            retval = new MemoryStream(byteArr);
        }

        return retval;
    }

    public void ReleaseImage()
    {
        String qryStr = "DELETE FROM TempImage WHERE tempId = @tempId";

        if (_imageId != 0)
        {
            string conStr = (string)_context.Application["DB_CONNECTION_STRING"];
            SqlConnection con = new SqlConnection(conStr);

            SqlCommand cmd = new SqlCommand(qryStr, con);
            cmd.Parameters.Add("tempId", (int)_imageId);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }

        _imageId = 0;
    }

    public int SaveImage(MemoryStream image)
    {
        //Create a byte Array with file length
        //
        Byte[] imgByte = new Byte[image.Length];

        //read the data into the imgByteBuffer
        //
        image.Seek(0, System.IO.SeekOrigin.Begin);
        image.Read(imgByte, 0, (int)image.Length);

        if (_imageId == 0)
        {
            _imageId = InsertImage(imgByte);
        }
        else
        {
            _imageId = UpdateImage(imgByte);
        }
        return _imageId;
    }

    private int InsertImage(byte[] imgByte)
    {
        int newId = 0;

        string conStr = (string)_context.Application["DB_CONNECTION_STRING"];
        string updateQry = "INSERT TempImage (tempImage) VALUES(@tempImage); " +
            "SELECT IDENT_CURRENT('TempImage')";

        SqlConnection con = new SqlConnection(conStr);
        con.Open();
        SqlCommand cmd = new SqlCommand(updateQry, con);

        cmd.Parameters.AddWithValue("tempImage", imgByte);

        // a decimal will be returned, but convert it to int
        //
        newId = Convert.ToInt32(cmd.ExecuteScalar());

        con.Close();

        return newId;
    }

    private int UpdateImage(Byte[] imgByte)
    {
        int retVal = 0;

        string conStr = (string)_context.Application["DB_CONNECTION_STRING"];
        string updateQry = "UPDATE TempImage SET tempImage = @tempImage WHERE tempId = @tempId"; 

        SqlConnection con = new SqlConnection(conStr);
        con.Open();
        SqlCommand cmd = new SqlCommand(updateQry, con);

        cmd.Parameters.AddWithValue("tempImage", imgByte);
        cmd.Parameters.AddWithValue("tempId", _imageId);

        int numRows = cmd.ExecuteNonQuery();

        if (numRows > 0)
        {
            retVal = _imageId;
        }

        con.Close();
        return retVal;
    }

    public int SaveImage(Bitmap image)
    {
        MemoryStream saveStream = new MemoryStream();
        image.Save(saveStream, System.Drawing.Imaging.ImageFormat.Png);

        return SaveImage(saveStream);
    }
}