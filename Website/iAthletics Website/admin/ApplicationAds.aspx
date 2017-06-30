<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="ApplicationAds.aspx.cs" Inherits="admin_ApplicationAds" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<p>
        <asp:HyperLink ID="HyperLink2" runat="server" 
            NavigateUrl="~/admin/Applications.aspx">Applications</asp:HyperLink>
&nbsp;&gt;&gt;
    </p>
    <h2>
        Administer Ads for
        <asp:Label ID="AppLabel" runat="server" Text="!application name!"></asp:Label>
        <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </asp:ToolkitScriptManager>
    </h2>
    <p>
        <asp:Button ID="WizardButton" runat="server" 
            PostBackUrl="~/admin/AdWizard/AdWizard.aspx" 
            Text="Create ad with Ad Wizard" oninit="WizardButton_Init" />
    </p>
    <p>
        <asp:FormView ID="AdEditorForm" runat="server" oninit="AdEditorForm_Init" 
            DataSourceID="AdsGridDs" EnableModelValidation="True" 
            oniteminserting="AdEditorForm_ItemInserting">
            <EditItemTemplate>
                
            </EditItemTemplate>
            <EmptyDataTemplate>
                <asp:Button ID="CreateAdButton" runat="server" onclick="CreateAdButton_Click" 
                    Text="Create ad with Editor" />
            </EmptyDataTemplate>
            <InsertItemTemplate>
                <table>
                    <tr>
                        <td>
                            <b>Business Name</b></td>
                        <td>
                            <b>Ad Image</b></td>
                        <td>
                            <b>Ad URL</b></td>
                        <td>
                            <b>Begin Date</b></td>
                        <td>
                            <b>End Date</b></td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="BusinessNameText" runat="server" MaxLength="50" 
                                Text='<%# Bind("vendorName") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                ControlToValidate="BusinessNameText" Display="None" 
                                ErrorMessage="Please Enter a value"></asp:RequiredFieldValidator>
                            <asp:ValidatorCalloutExtender ID="RequiredFieldValidator4_ValidatorCalloutExtender" 
                                runat="server" Enabled="True" TargetControlID="RequiredFieldValidator4">
                            </asp:ValidatorCalloutExtender>
                        </td>
                        <td>
                            <br />
                            <asp:Image ID="EditImage" runat="server" Height="50px" oninit="EditImage_Init" 
                                Width="320px" /><br />
                            <asp:FileUpload ID="AdUpload" runat="server" />
                            <asp:Button ID="UploadButton" runat="server" CausesValidation="False" 
                                CommandArgument='<%# Eval("adId") %>' CommandName="UploadImage" 
                                oncommand="UploadButton_Command" Text="Upload" />
                            <br />
                            <asp:Label ID="FileSizeErrorLabel" runat="server" ForeColor="Red" 
                                Text="Ad must measure exactally 50x320" Visible="False"></asp:Label>
                            <asp:Label ID="AdFailLabel" runat="server" ForeColor="Red" 
                                Text="Only PNG and JPG file types are supported" Visible="False"></asp:Label>
                            <asp:Label ID="NoImageErrorLabel" runat="server" ForeColor="Red" 
                                style="font-weight: 700" Text="You must supply an ad image" Visible="False"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="AdUrlText" runat="server" MaxLength="255" 
                                Text='<%# Bind("adUrl") %>'></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                                ControlToValidate="AdUrlText" Display="None" 
                                ErrorMessage="Please enter a valid URL" 
                                ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"></asp:RegularExpressionValidator>
                            <asp:ValidatorCalloutExtender ID="RegularExpressionValidator2_ValidatorCalloutExtender" 
                                runat="server" Enabled="True" TargetControlID="RegularExpressionValidator2">
                            </asp:ValidatorCalloutExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="BeginDateText" runat="server" MaxLength="10" 
                                Text='<%# Bind("adStartDate", "{0:d}") %>'></asp:TextBox>
                            <asp:CalendarExtender ID="BeginDateText_CalendarExtender" runat="server" 
                                Enabled="True" TargetControlID="BeginDateText">
                            </asp:CalendarExtender>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                ControlToValidate="BeginDateText" Display="None" 
                                ErrorMessage="Please enter a value"></asp:RequiredFieldValidator>
                            <asp:ValidatorCalloutExtender ID="RequiredFieldValidator5_ValidatorCalloutExtender" 
                                runat="server" Enabled="True" TargetControlID="RequiredFieldValidator5">
                            </asp:ValidatorCalloutExtender>
                            <asp:CompareValidator ID="CompareValidator3" runat="server" 
                                ControlToValidate="BeginDateText" Display="None" 
                                ErrorMessage="Please enter a valid date" Operator="DataTypeCheck" Type="Date"></asp:CompareValidator>
                            <asp:ValidatorCalloutExtender ID="CompareValidator3_ValidatorCalloutExtender" 
                                runat="server" Enabled="True" TargetControlID="CompareValidator3">
                            </asp:ValidatorCalloutExtender>
                        </td>
                        <td>
                            <asp:TextBox ID="EndDateText" runat="server" MaxLength="10" 
                                Text='<%# Bind("adEndDate", "{0:d}") %>'></asp:TextBox>
                            <asp:CalendarExtender ID="EndDateText_CalendarExtender" runat="server" 
                                Enabled="True" TargetControlID="EndDateText">
                            </asp:CalendarExtender>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                ControlToValidate="EndDateText" Display="None" 
                                ErrorMessage="Please enter a value"></asp:RequiredFieldValidator>
                            <asp:ValidatorCalloutExtender ID="RequiredFieldValidator6_ValidatorCalloutExtender" 
                                runat="server" Enabled="True" TargetControlID="RequiredFieldValidator6">
                            </asp:ValidatorCalloutExtender>
                            <asp:CompareValidator ID="CompareValidator4" runat="server" 
                                ControlToValidate="EndDateText" Display="None" 
                                ErrorMessage="Please enter a valid date" Operator="DataTypeCheck" Type="Date"></asp:CompareValidator>
                            <asp:ValidatorCalloutExtender ID="CompareValidator4_ValidatorCalloutExtender" 
                                runat="server" Enabled="True" TargetControlID="CompareValidator4">
                            </asp:ValidatorCalloutExtender>
                        </td>
                        <td>
                            <asp:Button ID="InsertButton" runat="server" CommandName="Insert" 
                                Text="Insert" />
                            &nbsp;<asp:Button ID="CancelButton" runat="server" CausesValidation="False" 
                                CommandName="Cancel" Text="Cancel" onclick="CancelButton_Click" />
                        </td>
                    </tr>
                </table>
            </InsertItemTemplate>
            <ItemTemplate>
                <asp:Button ID="CreateAdButton" runat="server" onclick="CreateAdButton_Click" 
                    Text="Create ad with Editor" />
            </ItemTemplate>
            <PagerTemplate>
                pager
            </PagerTemplate>
        </asp:FormView>
    </p>
    <p>
        Filter ads by status:
        <asp:DropDownList ID="AdStatusFilterCombo" runat="server" AutoPostBack="True" 
            DataSourceID="AvailableStatusQry" DataTextField="running" 
            DataValueField="runningSort" 
            onselectedindexchanged="AdStatusFilterCombo_SelectedIndexChanged">
        </asp:DropDownList>
        <asp:SqlDataSource ID="AvailableStatusQry" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            SelectCommand="SELECT DISTINCT CASE WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 'Active' WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &lt;= 0 THEN 'Completed' WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &gt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 'Upcoming' ELSE 'Unknown' END AS running, CASE WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 1 WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &lt;= 0 THEN 2 WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &gt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 3 ELSE 4 END AS runningSort FROM dbo.ApplicationAds WHERE (appId = @appId) ORDER BY runningSort">
            <SelectParameters>
                <asp:SessionParameter Name="appId" SessionField="AppIdParam" />
            </SelectParameters>
        </asp:SqlDataSource>
    </p>
    <p>
        <asp:GridView ID="AdsGrid" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
            BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
            DataKeyNames="adId" DataSourceID="AdsGridDs" ForeColor="Black" 
            GridLines="Vertical" onselectedindexchanged="AdsGrid_SelectedIndexChanged" 
            EnableModelValidation="True" ondatabinding="AdsGrid_DataBinding" 
            onrowcancelingedit="AdsGrid_RowCancelingEdit" onrowupdated="AdsGrid_RowUpdated" 
            onrowupdating="AdsGrid_RowUpdating">
            <RowStyle BackColor="#F7F7DE" />
            <Columns>
                <asp:TemplateField HeaderText="Enabled" SortExpression="adActive">
                    <EditItemTemplate>
                        <asp:CheckBox ID="ActiveCheckBox" runat="server" 
                            Checked='<%# Bind("adActive") %>' />
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:CheckBox ID="ActiveCheckBox" runat="server" 
                            Checked='<%# Bind("adActive") %>' Enabled="False" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Business Name" SortExpression="vendorName">
                    <EditItemTemplate>
                        <asp:TextBox ID="BusinessNameText" runat="server" MaxLength="50" 
                            Text='<%# Bind("vendorName") %>'></asp:TextBox>
                        <br />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="BusinessNameText" Display="None" 
                            ErrorMessage="Please enter a value"></asp:RequiredFieldValidator>
                        <asp:ValidatorCalloutExtender ID="RequiredFieldValidator1_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="RequiredFieldValidator1">
                        </asp:ValidatorCalloutExtender>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("vendorName") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Ad Image">
                    <EditItemTemplate><strong>
                        <asp:Label ID="FileSizeErrorLabel" runat="server" ForeColor="Red" 
                            Text="Ad must measure exactally 50x320" Visible="False"></asp:Label>
                        <asp:Label ID="AdFailLabel" runat="server" ForeColor="Red" 
                            Text="Only PNG and JPG file types are supported" Visible="False"></asp:Label>
                        </strong><br />
                        <asp:Image ID="EditImage" runat="server" 
                            Height="50px" Width="320px" oninit="EditImage_Init" />
                        <asp:FileUpload ID="AdUpload" runat="server" />
                        <asp:Button ID="UploadButton" runat="server" CausesValidation="False" 
                            CommandArgument='<%# Eval("adId") %>' CommandName="UploadImage" 
                            oncommand="UploadButton_Command" Text="Upload" /> 
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Image ID="Image1" runat="server" 
                            ImageUrl='<%# Eval("adId", "~/images/GetAdImage.ashx?adId={0}") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Ad url when clicked" SortExpression="adUrl">
                    <EditItemTemplate>
                        <asp:TextBox ID="ClickUrlText" runat="server" MaxLength="256" 
                            Text='<%# Bind("adUrl") %>'></asp:TextBox>
                        <br />
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                            ControlToValidate="ClickUrlText" Display="None" 
                            ErrorMessage="Please enter a valid web URL" 
                            ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"></asp:RegularExpressionValidator>
                        <asp:ValidatorCalloutExtender ID="RegularExpressionValidator1_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="RegularExpressionValidator1">
                        </asp:ValidatorCalloutExtender>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("adUrl") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Begin Date" SortExpression="adStartDate">
                    <EditItemTemplate>
                        <asp:TextBox ID="BeginDateTextBox" runat="server" 
                            Text='<%# Bind("adStartDate", "{0:d}") %>' MaxLength="10"></asp:TextBox>
                        <asp:CalendarExtender ID="BeginDateTextBox_CalendarExtender" runat="server" 
                            Enabled="True" TargetControlID="BeginDateTextBox">
                        </asp:CalendarExtender>
                        
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                            ControlToValidate="BeginDateTextBox" Display="None" 
                            ErrorMessage="Please enter a starting date"></asp:RequiredFieldValidator>
                        <asp:ValidatorCalloutExtender ID="RequiredFieldValidator2_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="RequiredFieldValidator2">
                        </asp:ValidatorCalloutExtender>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" 
                            ControlToValidate="BeginDateTextBox" Display="None" 
                            ErrorMessage="Please enter a valid date" Operator="DataTypeCheck" 
                            Type="Date"></asp:CompareValidator>
      
                        <asp:ValidatorCalloutExtender ID="CompareValidator1_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="CompareValidator1">
                        </asp:ValidatorCalloutExtender>
      
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" 
                            Text='<%# Bind("adStartDate", "{0:d}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="End Date" SortExpression="adEndDate">
                    <EditItemTemplate>
                        <asp:TextBox ID="EndDateTextBox" runat="server" 
                            Text='<%# Bind("adEndDate", "{0:d}") %>'></asp:TextBox>
                        <asp:CalendarExtender ID="EndDateTextBox_CalendarExtender" runat="server" 
                            Enabled="True" TargetControlID="EndDateTextBox">
                        </asp:CalendarExtender>
                        <br />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                            ControlToValidate="EndDateTextBox" Display="None" 
                            ErrorMessage="Please enter  value"></asp:RequiredFieldValidator>
                        <asp:ValidatorCalloutExtender ID="RequiredFieldValidator3_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="RequiredFieldValidator3" 
                            PopupPosition="TopLeft">
                        </asp:ValidatorCalloutExtender>
                        <asp:CompareValidator ID="CompareValidator2" runat="server" 
                            ControlToValidate="EndDateTextBox" Display="None" 
                            ErrorMessage="Please enter a valid date" Operator="DataTypeCheck" 
                            Type="Date"></asp:CompareValidator>
                        <asp:ValidatorCalloutExtender ID="CompareValidator2_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="CompareValidator2" 
                            PopupPosition="TopLeft">
                        </asp:ValidatorCalloutExtender>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("adEndDate", "{0:d}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status" SortExpression="running">
                    <EditItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("running") %>'></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("running") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Commands">
                    <EditItemTemplate>
                        <asp:Button ID="UpdateButton" runat="server" CommandName="Update" 
                            Text="Update" />
                        &nbsp;<asp:Button ID="GridCancelButton" runat="server" CausesValidation="False" 
                            CommandName="Cancel" Text="Cancel"  />
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Button ID="RenewBtn" runat="server" 
                            oninit="RenewBtn_Init" Text="Renew" CausesValidation="False" 
                            CommandArgument='<%# Eval("adId") %>' CommandName="Renew" 
                            oncommand="RenewBtn_Command" />
                        &nbsp;<asp:Button ID="EditBtn" runat="server" CommandArgument='<%# Eval("adId") %>' 
                            CommandName="Edit" oninit="EditBtn_Init" Text="Edit" 
                            oncommand="EditBtn_Command" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <PagerSettings Position="TopAndBottom" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
        <asp:SqlDataSource ID="AdsGridDs" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            
            
            
            SelectCommand="SELECT adId, vendorName, dbaName, vendorCity, vendorState, adUrl, adPhone, contactName, contactPhone, contactEmail, adActive, adStartDate, adEndDate, CASE WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 'Active' WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &lt;= 0 THEN 'Completed' WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &gt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 'Upcoming' ELSE 'Unknown' END AS running, CASE WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 1 WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &lt;= 0 THEN 2 WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &gt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 3 ELSE 4 END AS runningSort FROM dbo.ApplicationAds WHERE (appId = @appId) AND (CASE WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 1 WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &lt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &lt;= 0 THEN 2 WHEN DATEDIFF(day , CURRENT_TIMESTAMP , adstartdate) &gt;= 0 AND DATEDIFF(day , CURRENT_TIMESTAMP , adEndDate) &gt;= 0 THEN 3 ELSE 4 END = @statusFilter) ORDER BY runningSort, adStartDate" 
            
            UpdateCommand="UPDATE dbo.ApplicationAds SET vendorName = @vendorName, adImage = @adImage, adUrl = @adUrl, adStartDate = @adStartDate, adEndDate = @adEndDate WHERE (adId = @adId)" 
            
            InsertCommand="INSERT INTO dbo.ApplicationAds(vendorName, appId, adUrl, adStartDate, adEndDate, adImage) VALUES (@vendorName, @appId, @adUrl, @adStartDate, @adEndDate, @adImage)">
            <InsertParameters>
                <asp:Parameter Name="vendorName" />
                <asp:Parameter Name="appId" />
                <asp:Parameter Name="adUrl" />
                <asp:Parameter Name="adStartDate" />
                <asp:Parameter Name="adEndDate" />
                <asp:Parameter Name="adImage" />
            </InsertParameters>
            <SelectParameters>
                <asp:SessionParameter Name="appId" SessionField="AppIdParam" />
                <asp:ControlParameter ControlID="AdStatusFilterCombo" Name="statusFilter" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="vendorName" />
                <asp:Parameter Name="adImage" />
                <asp:Parameter Name="adUrl" />
                <asp:Parameter Name="adStartDate" />
                <asp:Parameter Name="adEndDate" />
                <asp:Parameter Name="adId" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </p>
</asp:Content>

