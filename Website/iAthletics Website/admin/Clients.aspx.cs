using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Clients : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void ClientsGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        ClientsForm.ChangeMode(FormViewMode.ReadOnly);
    }

    protected void ClientsForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        ClientsGrid.DataBind();
    }

    protected void ClientsForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        ClientsGrid.DataBind();
    }
}
