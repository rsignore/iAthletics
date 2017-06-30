using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class admin_NewsLinks : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int appId = (int)Session["AppIdParam"];
//        int appId = Convert.ToInt32(Request.Params["appId"]);
        string appNameQry = "SELECT appName FROM Applications WHERE appId = " + appId.ToString();
        string conStr = (string)Application["DB_CONNECTION_STRING"];

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(appNameQry, con);

        con.Open();
        try
        {
            AppLabel.Text = (string)cmd.ExecuteScalar();

       }
        finally
        {
            // Always call Close when done reading.
            con.Close();
        }
    }
    protected void LinksForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        LinksGrid.DataBind();
    }
    protected void LinksForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        e.Values["appId"] = (int)Session["AppIdParam"];
//        e.Values["appId"] = Request.Params["appId"];
    }
    protected void LinksForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        LinksGrid.DataBind();
    }
    protected void LinksGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        LinksForm.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void LinksForm_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        LinksGrid.DataBind();
    }
}
