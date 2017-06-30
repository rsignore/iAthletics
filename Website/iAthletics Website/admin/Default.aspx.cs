using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["ADMIN_LOGGED_ON"] != null &&
            (bool)Session["ADMIN_LOGGED_ON"] == true)
        {
            AdminPanel.Visible = true;
        }
        else
        {
            AdminPanel.Visible = false;
        }
    }
}
