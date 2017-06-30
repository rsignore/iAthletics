using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class admin_AdminLogon : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(Session["LOGGED_ON"] != null &&
            (bool)Session["LOGGED_ON"])
        {
            Response.Redirect("~/admin/Default.aspx");
        }

    }

    protected void LogonButton_Click(object sender, EventArgs e)
    {
        string hashUid = iAthleticsUtil.GetMd5Hash(uid.Text);
        string hashPwd = iAthleticsUtil.GetMd5Hash(pwd.Text);

        // first check to see if this is the master administrator password
        //
        if (hashUid != null && hashPwd != null &&
            String.Compare(hashUid, "c614e6078338873d8e4752da67d990ba") == 0 &&
            String.Compare(hashPwd, "4c55df308ad7614caee192de22a40372") == 0)
        {
            // set the logon on flag to true
            //
            Session["LOGGED_ON"] = true;
            // set the admin logged on flag to true
            // this flag is used to provide high level admin functions
            //
            Session["ADMIN_LOGGED_ON"] = true;

            // set administrator permissions
            //
            UserPermissions permissions = new UserPermissions();
            permissions.EnableAdWizard = true;
            permissions.EnableAdEditor = true;

            Session["Permissions"] = permissions;

            Response.Redirect("~/admin/Default.aspx");
        }
        // see if this is a self service user logging on
        //
        else if (DoSelfServiceLogon())
        {
            // set the logon on flag to true
            //
            Session["LOGGED_ON"] = true;
            // set the admin logged on flag to true
            // this flag is used to provide high level admin functions
            //
            Session["ADMIN_LOGGED_ON"] = false;

            Response.Redirect("~/admin/Default.aspx");
        }
        else
        {
            // logon failed, show the error panel
            //
            ErrorPanel.Visible = true;
        }
    }

    protected bool DoSelfServiceLogon()
    {
        bool retval = false;

        string conStr = (string)Application["DB_CONNECTION_STRING"];
        string logonUserQry = "SELECT appId, enableAdEdit " +
                                "FROM dbo.Applications " +
                                "WHERE (appActive = 1) AND (userName = @userName) AND (password = @password)";

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(logonUserQry, con);

        cmd.Parameters.AddWithValue("userName", uid.Text);
        cmd.Parameters.AddWithValue("password", pwd.Text);

        con.Open();

        SqlDataReader reader = cmd.ExecuteReader();

        if (reader.Read())
        {
            if (reader["appId"] != null)
            {
                Int32 asInt = (int)reader["appId"];
                Session["APP_ID"] = asInt;
                retval = true;
            }

            UserPermissions permissions = new UserPermissions();

            if (reader["enableAdEdit"] != null)
            {
                Boolean useEditor = (Boolean)reader["enableAdEdit"];

                if (useEditor)
                {
                    permissions.EnableAdEditor = true;
                    permissions.EnableAdWizard = false;
                }
                else
                {
                    permissions.EnableAdEditor = false;
                    permissions.EnableAdWizard = true;
                }
            }
            else
            {
                permissions.EnableAdEditor = false;
                permissions.EnableAdWizard = true;
            }

            Session["Permissions"] = permissions;
        }

        con.Close();

        return retval;
    }
}
