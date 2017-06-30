using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_AdminMasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LOGGED_ON"] == null ||
            !(bool)Session["LOGGED_ON"])
        {
            Response.Redirect("~/admin/AdminLogon.aspx");
        }
    }

    // this is the click event for the logout button
    //
    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        Session["LOGGED_ON"] = false;
        Session["ADMIN_LOGGED_ON"] = false;
        Session.Remove("APP_ID");
        Session.Remove("Permissions");

        Response.Redirect("~/admin/AdminLogon.aspx");
    }
}
