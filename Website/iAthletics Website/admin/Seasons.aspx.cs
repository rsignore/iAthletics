using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class admin_Seasons : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void SeasonsGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        SeasonForm.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void SeasonForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        SeasonsGrid.DataBind();
    }
    protected void SeasonForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        SeasonsGrid.DataBind();
    }
    protected void EditIconButton_Click(object sender, EventArgs e)
    {
        DataKey keyVals = SeasonsGrid.SelectedDataKey;
        if (keyVals != null)
        {
            int seasonId = (int)keyVals["SeasonId"];

            Response.Redirect("~/admin/EditSeasonsIcon.aspx?SeasonId=" + seasonId.ToString());
        }
    }
}
