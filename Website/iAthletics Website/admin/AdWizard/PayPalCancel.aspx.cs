using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Ad_Wizard_PayPalCancel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Write("begin dump:<br><br>");
        for (int i = 0; i < Request.Form.Keys.Count; i++)
        {
            Response.Write(Request.Form.GetKey(i) + ": " + Request.Form.GetValues(i)[0] + "<br>"); 
        }
        Response.Write("<br>end dump");

        Response.Redirect("~/admin/ApplicationAds.aspx");
    }
}