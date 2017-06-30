using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class admin_Ad_Wizard_PayPalReturn : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // process the PayPal IPN notofication
        //
        PayPalIPNHandler handler = new PayPalIPNHandler(Request.Form, Context);
        handler.ProcessNotofication();

        // return to the ad page of the app
        //
        Response.Redirect("~/admin/ApplicationAds.aspx");  
      
        // debugging dump
        //
        //for (int i = 0; i < Request.Form.Keys.Count; i++)
        //{
        //    Response.Write(Request.Form.GetKey(i) + ": " + Request.Form.GetValues(i)[0] + "<br>"); 
        //}
    }
}