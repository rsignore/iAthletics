using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.Text;
using System.Data.SqlClient;

/// <summary>
/// Summary description for iAthleticsUtil
/// </summary>
public class iAthleticsUtil
{
	public iAthleticsUtil()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static String GetMd5Hash(string input)
    {
        // Create a new instance of the MD5CryptoServiceProvider object.
        MD5 md5Hasher = MD5.Create();

        // Convert the input string to a byte array and compute the hash.
        Byte[] data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(input));

        // Create a new Stringbuilder to collect the bytes
        // and create a string.
        StringBuilder sBuilder = new StringBuilder();

        // Loop through each byte of the hashed data 
        // and format each one as a hexadecimal string.
        for (int i = 0; i < data.Length; i++)
        {
            sBuilder.Append(data[i].ToString("x2"));
        }

        // Return the hexadecimal string.
        return sBuilder.ToString();
    }

    public static string GetApplicationName(HttpContext context, int appId)
    {
        string appNameQry = "SELECT appName FROM Applications WHERE appId = " + appId.ToString();
        string conStr = (string) context.Application["DB_CONNECTION_STRING"];

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        con.Open();
        string retVal = (string)cmd.ExecuteScalar();

        con.Close();

        return retVal;
    }
}
