using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void AddButton_Click(object sender, EventArgs e)
    {
        SchoolForm.ChangeMode(FormViewMode.Insert);
    }

    protected void SchoolForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        SchoolGrid.DataBind();
    }
    protected void EditButton_Click(object sender, EventArgs e)
    {
        SchoolForm.ChangeMode(FormViewMode.Edit);
    }

    protected void SchoolGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        SchoolForm.ChangeMode(FormViewMode.ReadOnly);
    }
}
