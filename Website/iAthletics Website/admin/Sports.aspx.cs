using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Sports : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void SportForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        SportGrid.DataBind();
    }

    protected void SportForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        SportGrid.DataBind();
    }
    protected void SportGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        SportForm.ChangeMode(FormViewMode.ReadOnly);
    }

     protected void EditIconButton_Click(object sender, EventArgs e)
    {
        DataKey keyVals = SportGrid.SelectedDataKey;
        if (keyVals != null)
        {
            int sportId = (int)keyVals["sportId"];

            Response.Redirect("~/admin/EditSportsIcon.aspx?sportId=" + sportId.ToString());
        }
    }
}
