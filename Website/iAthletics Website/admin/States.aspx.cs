using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_States : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void StateForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        StateGrid.DataBind();
    }

    protected void StateForm_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        StateGrid.DataBind();
    }

    protected void StateGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        StateForm.ChangeMode(FormViewMode.ReadOnly);
    }
}
