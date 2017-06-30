using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_LinkTypes : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void LinkTypeGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        LinkTypeForm.ChangeMode(FormViewMode.ReadOnly);
    }

    protected void LinkTypeForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        LinkTypeGrid.DataBind();
    }

    protected void LinkTypeForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        LinkTypeGrid.DataBind();
    }

    protected void EditImage_Click(object sender, EventArgs e)
    {
        DataKey keyVals = LinkTypeGrid.SelectedDataKey;
        if (keyVals != null)
        {
            Response.Redirect("~/admin/EditLinkTypesIcon.aspx?linkTypeId=" + keyVals["linkTypeId"].ToString());
        }
    }
}
