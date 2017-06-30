using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;

public partial class admin_ApplicationAds : System.Web.UI.Page
{
    private int adsLeft = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        int appId = (int)Session["AppIdParam"];
//        int appId = Convert.ToInt32(Request.Params["appId"]);

        AppLabel.Text = iAthleticsUtil.GetApplicationName(Context, appId);

        DisplayAdUsageInfo();
    }

    protected void DisplayAdUsageInfo()
    {
        string adQry = "SELECT totalAdsAvailable, adsUsed " +
                            "FROM dbo.AdsAvailableUsed " +
                            "WHERE (appId = @appId)";

        string conStr = (string)Application["DB_CONNECTION_STRING"];

        SqlConnection con = new SqlConnection(conStr);
        SqlCommand cmd = new SqlCommand(adQry, con);
        cmd.Parameters.AddWithValue("appId", (int)Session["AppIdParam"]);
//        cmd.Parameters.Add("appId", Convert.ToInt32(Request.Params["appId"]));

        con.Open();
        SqlDataReader reader = cmd.ExecuteReader();
        try
        {
            if (reader.Read())
            {
                // save how many ads are left (free to be used) for use by this app
                //
                this.adsLeft = Convert.ToInt32(reader["totalAdsAvailable"]) -
                    Convert.ToInt32(reader["adsUsed"]);

                //AdsAvailableLabel.Text = reader["totalAdsAvailable"].ToString();
                //AdsUsedLabel.Text = reader["adsUsed"].ToString();
            }
        }
        finally
        {
            // Always call Close when done reading.
            reader.Close();
            con.Close();
        }

//        MoreAdsPanel.Visible = (this.adsLeft <= 0);
    }

    protected void AdsGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
//        AdForm.ChangeMode(FormViewMode.ReadOnly);
    }

    protected void AdForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        e.Values["appId"] = (int)Session["AppIdParam"];
//        e.Values["appId"] = Convert.ToInt32(Request.Params["appId"]);
    }

    protected void AdForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        DisplayAdUsageInfo();
        AdsGrid.DataBind();
    }

    protected void AdForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        DisplayAdUsageInfo();
        AdsGrid.DataBind();
    }
    protected void EditImage_Click(object sender, EventArgs e)
    {
        DataKey keyVals = AdsGrid.SelectedDataKey;
        if (keyVals != null)
        {
            int adId = (int)keyVals["adId"];

            Session["AdIdParam"] = adId;
            Response.Redirect("~/admin/EditAdImage.aspx");
//            Response.Redirect("~/admin/EditAdImage.aspx?appId=" + Request.Params["appId"] +
//                "&adId=" + adId.ToString());
        }
    }
    protected void AdForm_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        DisplayAdUsageInfo();
        AdsGrid.DataBind();
    }
    protected void AddButton_PreRender(object sender, EventArgs e)
    {
        Button addButton = (Button)sender;

        // only turn the add button on if there are ads left
        //
        addButton.Enabled = (this.adsLeft > 0);
        
    }
    protected void MoreAdsPanel_PreRender(object sender, EventArgs e)
    {
        //MoreAdsPanel.Visible = (this.adsLeft <= 0);
    }


    protected void CheckBox2_PreRender(object sender, EventArgs e)
    {
        CheckBox activeCheckBox = (CheckBox)sender;

        // check to see if this ad is not active. If it is not active
        // only enable the check box if not all ad spaces are used
        //
        if (!activeCheckBox.Checked)
        {
            if (this.adsLeft > 0)
            {
                activeCheckBox.Enabled = true;
            }
            else
            {
                Label adWarning = (Label)activeCheckBox.Parent.FindControl("AdActiveWarning");
                if (adWarning != null)
                    adWarning.Visible = true;

                activeCheckBox.Enabled = false;
            }
        }
    }

    protected void AdStatusFilterCombo_SelectedIndexChanged(object sender, EventArgs e)
    {
        AdsGrid.EditIndex = -1;
        AdsGrid.DataBind();
    }

    protected void RenewBtn_Init(object sender, EventArgs e)
    {
        Button btn = (Button)sender;

        // the Renew button is only available to wizard users when the ad has expired
        //
        UserPermissions permissions = (UserPermissions)Session["Permissions"];
        if (permissions != null && permissions.EnableAdWizard == true)
        {
            // turn the renew button off if this is a current ad. We just want to renew non-running ads
            //
            btn.Visible = (AdStatusFilterCombo.Text != "1");
        }
        else
        {
            btn.Visible = false;
        }    
    }
    protected void RenewBtn_Command(object sender, CommandEventArgs e)
    {
        String adIdText = (String)e.CommandArgument;
        int adId = Convert.ToInt32(adIdText);

        CssAd renewAd = new CssAd(Context);

        if(renewAd.CreateFromApplicationAd(adId))
        {
            Session["renewAd"] = renewAd;
            Response.Redirect("~/admin/AdWizard/AdWizard.aspx");
        }
    }
    protected void EditBtn_Init(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        UserPermissions permissions = (UserPermissions)Session["Permissions"];

        if (permissions != null && permissions.EnableAdEditor == true)
        {
            btn.Visible = true;
        }
        else
        {
            btn.Visible = false;
        }
    }
    protected void UploadButton_Command(object sender, CommandEventArgs e)
    {
        WebControl me = (WebControl)sender;

        // find the controls we want to manipulate in the template we are being called from
        //
        Label noImageErrorLabel = (Label)me.FindControl("NoImageErrorLabel");
        FileUpload IconUpload = (FileUpload)me.Parent.FindControl("AdUpload");
        Label FileSizeErrorLabel = (Label)me.Parent.FindControl("FileSizeErrorLabel");
        Label IconFailLabel = (Label)me.Parent.FindControl("AdFailLabel");
        System.Web.UI.WebControls.Image editImageBox = 
            (System.Web.UI.WebControls.Image)me.Parent.FindControl("EditImage");

        noImageErrorLabel.Visible = false;

        FileSizeErrorLabel.Visible = false;
        IconFailLabel.Visible = false;

        String adId = (String)e.CommandArgument;

        if (IconUpload.HasFile)
        {
            // make sure it's a png or jpeg file file
            //
            if (String.Compare(IconUpload.PostedFile.ContentType, "image/x-png") == 0 ||
                String.Compare(IconUpload.PostedFile.ContentType, "image/png") == 0 ||
                String.Compare(IconUpload.PostedFile.ContentType, "image/pjpeg") == 0)
            {
                IconFailLabel.Visible = false;

                // read the file in and create a bitmap out of it so we can validate the
                // file size. the ad must have WxH of 320x50
                //
                HttpPostedFile File = IconUpload.PostedFile;

                // create a bitmap with the image data
                //
                Bitmap img = new Bitmap(File.InputStream, false);

                // check the width and height , make sure is the image is exactally 320x50
                //
                if (img.Width == 320 && img.Height == 50)
                {
                    FileSizeErrorLabel.Visible = false;

                    // put the uploaded bitmap into the temp image table via the session attached AdEditValues
                    //
                    AdEditValues editValues = (AdEditValues)Session["AdEditValues"];
                    int tmpImageId = editValues.SaveImage(img);

                    // change the URL of the image to the new imge Id;
                    //
                    if (tmpImageId != 0)
                    {
                        editImageBox.ImageUrl = "~/images/GetTempImage.ashx?tempId=" + tmpImageId.ToString();
                    }
                }
                else
                {
                    FileSizeErrorLabel.Visible = true;
                }
            }
            else
            {
                IconFailLabel.Visible = true;
            }
        }
    }
    protected void EditBtn_Command(object sender, CommandEventArgs e)
    {
        int adId = Convert.ToInt32(e.CommandArgument);

        AdEditValues values = new AdEditValues(Context, adId);

        // add the edit values to the session object
        //
        Session["AdEditValues"] = values;

    }

    protected void EditImage_Init(object sender, EventArgs e)
    {
        System.Web.UI.WebControls.Image editImageBox = (System.Web.UI.WebControls.Image)sender;

        AdEditValues editValues = (AdEditValues)Session["AdEditValues"];

        if (editValues != null && editValues.AdImage != null)
        {
            int tempId = editValues.AdImage.TempId;

            editImageBox.ImageUrl = "~/images/GetTempImage.ashx?tempId=" + tempId.ToString();
        }
        
    }
    protected void AdsGrid_DataBinding(object sender, EventArgs e)
    {
        
    }
    protected void AdsGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        AdEditValues editValues = (AdEditValues)Session["AdEditValues"];
        MemoryStream memStr = editValues.AdImage.GetImageAsMemoryStream();

        Byte[] imgByte = editValues.AdImage.GetImageAsByteArray();

        //read the data into the imgByteBuffer
        //
        memStr.Seek(0, System.IO.SeekOrigin.Begin);
        memStr.Read(imgByte, 0, (int)memStr.Length);

        e.NewValues.Add("adImage", imgByte);
    }
    protected void AdsGrid_RowUpdated(object sender, GridViewUpdatedEventArgs e)
    {
        AdEditValues editValues = (AdEditValues)Session["AdEditValues"];

        // we no longer need to store the temp image in the db
        //
        editValues.AdImage.ReleaseImage();

        Session["AdEditValues"] = null;
    }
    protected void AdsGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Session.Remove("AdEditValues");
    }


    protected void CreateAdButton_Click(object sender, EventArgs e)
    {
        AdEditorForm.ChangeMode(FormViewMode.Insert);

        AdEditValues values = new AdEditValues(Context);

        // add the edit values to the session object
        //
        Session["AdEditValues"] = values;
    }

    protected void AdEditorForm_Init(object sender, EventArgs e)
    {
        UserPermissions permissions = (UserPermissions)Session["Permissions"];

        if (permissions != null)
        {
            AdEditorForm.Visible = permissions.EnableAdEditor;
        }
        else
        {
            // the default state of the edit is hidden
            //
            AdEditorForm.Visible = false;
        }       
    }
    protected void AdEditorForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        AdEditValues editValues = (AdEditValues)Session["AdEditValues"];

        if (editValues != null && editValues.AdImage != null)
        {
            // ad the image to the parameters
            //
            e.Values.Add("adImage", editValues.AdImage.GetImageAsByteArray());

            // ad the app id too
            //
            int appId = (int)Session["AppIdParam"];

            e.Values.Add("appId", appId);
        }
        else
        {
            // find the error message and turn it on
            //
            Label noImageErrorLabel = (Label)((FormView)sender).FindControl("NoImageErrorLabel");
            noImageErrorLabel.Visible = true;
            
            // cancel the insert since there is no image for the ad
            //
            e.Cancel = true;   
        }
    }
    protected void WizardButton_Init(object sender, EventArgs e)
    {
        UserPermissions permissions = (UserPermissions)Session["Permissions"];

        if (permissions != null)
        {
            WizardButton.Visible = permissions.EnableAdWizard;
        }
        else
        {
            // by default the wizard button should be enabled
            //
            WizardButton.Visible = true;
        }
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Session.Remove("AdEditValues");
    }
}
