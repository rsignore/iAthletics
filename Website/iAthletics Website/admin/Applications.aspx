<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Applications.aspx.cs" Inherits="admin_Applications" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style3
        {
            font-weight: bold;
        }
        .style4
        {
            font-weight: bold;
            text-align: right;
        }
    </style>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2>Applications Administration<asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </asp:ToolkitScriptManager>
        </h2>
    <asp:GridView ID="AppsGrid" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
        DataSourceID="GridDS" ForeColor="Black" GridLines="Vertical" 
        DataKeyNames="appId" 
        onselectedindexchanged="AppsGrid_SelectedIndexChanged" 
        EnableModelValidation="True">
        <RowStyle BackColor="#F7F7DE" />
        <Columns>
            <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
            <asp:CheckBoxField DataField="appActive" HeaderText="Active" 
                SortExpression="appActive" />
            <asp:BoundField DataField="appId" HeaderText="ID #" InsertVisible="False" 
                ReadOnly="True" SortExpression="appId" />
            <asp:BoundField DataField="appName" HeaderText="Application Name" 
                SortExpression="appName" />
            <asp:BoundField DataField="teamName" HeaderText="Team Name" 
                SortExpression="teamName" />
            <asp:BoundField DataField="userName" 
                HeaderText="User id" SortExpression="userName" />
            <asp:BoundField DataField="endDate" DataFormatString="{0:d}" 
                HeaderText="Subscription End Date" SortExpression="endDate" />
            <asp:BoundField DataField="Active Ads" HeaderText="Active Ads" 
                SortExpression="Active Ads" />
        </Columns>
        <FooterStyle BackColor="#CCCC99" />
        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    <asp:SqlDataSource ID="GridDS" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        
        
        
        
        
        
        SelectCommand="SELECT dbo.Applications.appId, dbo.Applications.appName, dbo.Applications.teamName, dbo.Applications.appActive, dbo.Applications.userName, AppActiveAds.activeAds AS [Active Ads], dbo.Applications.endDate FROM dbo.Applications LEFT OUTER JOIN AppActiveAds ON dbo.Applications.appId = AppActiveAds.appId">
    </asp:SqlDataSource>
    <asp:FormView ID="AppForm" runat="server" DataKeyNames="appId" 
        DataSourceID="AppFormDS" oniteminserted="AppForm_ItemInserted" 
        onitemupdated="AppForm_ItemUpdated" style="margin-right: 165px">
        <EditItemTemplate>
            <table class="style3">
                <tr>
                    <td class="style4">
                        Application Enabled:</td>
                    <td style="text-align: left">
                        <asp:CheckBox ID="appActiveCheckBox" runat="server" 
                            Checked='<%# Bind("appActive") %>' />
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        Application Name:</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="appNameTextBox" runat="server" MaxLength="50" 
                            style="text-align: left" Text='<%# Bind("appName") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                            ControlToValidate="appNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        <b>Team Name:</b></td>
                    <td style="text-align: left">
                        <asp:TextBox ID="teamNameTextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("teamName") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                            ControlToValidate="teamNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        Subscription End Date:</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="SubscriptionEndDate" runat="server" 
                            Text='<%# Bind("endDate", "{0:d}") %>' MaxLength="25"></asp:TextBox>
                        <asp:CalendarExtender ID="SubscriptionEndDate_CalendarExtender" runat="server" 
                            Enabled="True" TargetControlID="SubscriptionEndDate">
                        </asp:CalendarExtender>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                            ControlToValidate="SubscriptionEndDate" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" 
                            ControlToValidate="SubscriptionEndDate" Display="None" 
                            ErrorMessage="Enter a valid date" Operator="DataTypeCheck" Type="Date"></asp:CompareValidator>
                        <asp:ValidatorCalloutExtender ID="CompareValidator1_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="CompareValidator1">
                        </asp:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        Enable Ad Editor:</td>
                    <td style="text-align: left">
                        <asp:CheckBox ID="AdEditorCheckBox" runat="server" 
                            Checked='<%# Bind("enableAdEdit") %>' />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        Entering a User Name and Password below enables self service capabilities</td>
                </tr>
                <tr>
                    <td class="style4">
                        User Name:</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="TextBox1" runat="server" MaxLength="50" 
                            Text='<%# Bind("userName") %>' Width="268px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        Password:</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="TextBox2" runat="server" MaxLength="50" 
                            Text='<%# Bind("password") %>' Width="269px"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            <asp:HiddenField ID="AppIdHidden" runat="server" Value='<%# Eval("appId") %>' />
        </EditItemTemplate>
        <InsertItemTemplate>
            <table class="style3">
                <tr>
                    <td class="style4">
                        Application Enabled:</td>
                    <td style="text-align: left">
                        <asp:CheckBox ID="appActiveCheckBox" runat="server" 
                            Checked='<%# Bind("appActive") %>' />
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        Application Name:</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="appNameTextBox" runat="server" MaxLength="50" 
                            style="text-align: left" Text='<%# Bind("appName") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                            ControlToValidate="appNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        <b>Team Name:</b></td>
                    <td style="text-align: left">
                        <asp:TextBox ID="teamNameTextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("teamName") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                            ControlToValidate="teamNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        Subscription End Date:</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="SubscriptionEndDate" runat="server" 
                            Text='<%# Bind("endDate", "{0:d}") %>' MaxLength="25"></asp:TextBox>
                        <asp:CalendarExtender ID="SubscriptionEndDate_CalendarExtender" runat="server" 
                            Enabled="True" TargetControlID="SubscriptionEndDate">
                        </asp:CalendarExtender>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                            ControlToValidate="SubscriptionEndDate" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" 
                            ControlToValidate="SubscriptionEndDate" Display="None" 
                            ErrorMessage="Enter a valid date" Operator="DataTypeCheck" Type="Date"></asp:CompareValidator>
                        <asp:ValidatorCalloutExtender ID="CompareValidator1_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="CompareValidator1">
                        </asp:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        Enable Ad Editor:</td>
                    <td style="text-align: left">
                        <asp:CheckBox ID="AdEditorCheckBox" runat="server" 
                            Checked='<%# Bind("enableAdEdit") %>' />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        Entering a User Name and Password below enables self service capabilities</td>
                </tr>
                <tr>
                    <td class="style4">
                        User Name:</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="TextBox1" runat="server" MaxLength="50" 
                            Text='<%# Bind("userName") %>' Width="268px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="style4">
                        Password:</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="TextBox2" runat="server" MaxLength="50" 
                            Text='<%# Bind("password") %>' Width="269px"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>
        <ItemTemplate>
            <asp:Button ID="AddButton" runat="server" onclick="AddNewAppButton_Click" 
                Text="Add Application" oninit="ShowButton_Init" />
            &nbsp;<asp:Button ID="EditAppButton" runat="server" Text="Edit Application" 
                onclick="EditAppButton_Click" oninit="ShowButton_Init" />
            &nbsp;<br />
            <asp:Button ID="TeamsButton" runat="server" onclick="TeamsButton_Click" 
                Text="Edit Teams" />
            &nbsp;<asp:Button ID="NewsButton" runat="server" onclick="NewsButton_Click" 
                Text="Edit news links" />
            &nbsp;<asp:Button ID="AdButton" runat="server" onclick="AdButton_Click" 
                Text="Edit Ads" />
        </ItemTemplate>
        <EmptyDataTemplate>
            <asp:Button ID="AddNewAppButton" runat="server" onclick="AddNewAppButton_Click" 
                Text="Create New Application" oninit="ShowButton_Init" />
        </EmptyDataTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="AppFormDS" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        
        
        
        
        
        
    
        InsertCommand="INSERT INTO dbo.Applications(appName, appActive, teamName, userName, password, endDate, enableAdEdit ) VALUES (@appName, @appActive, @teamName, @userName, @password, @endDate, @enableAdEdit)" SelectCommand="SELECT appId, appName, appActive, teamName, userName, password, endDate, enableAdEdit FROM dbo.Applications WHERE (appId = @appId)" 
        
        
        
        
        
    
        UpdateCommand="UPDATE dbo.Applications SET appName = @appName, appActive = @appActive, teamName = @teamName, userName = @userName, password = @password, endDate = @endDate, enableAdEdit = @enableAdEdit WHERE (appId = @appId)">
        <SelectParameters>
            <asp:ControlParameter ControlID="AppsGrid" Name="appId" 
                PropertyName="SelectedValue" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="appName" />
            <asp:Parameter Name="appActive" />
            <asp:Parameter Name="teamName" />
            <asp:Parameter Name="userName" />
            <asp:Parameter Name="password" />
            <asp:Parameter Name="endDate" />
            <asp:Parameter Name="enableAdEdit" />
            <asp:Parameter Name="appId" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="appName" />
            <asp:Parameter Name="appActive" />
            <asp:Parameter Name="teamName" />
            <asp:Parameter Name="userName" />
            <asp:Parameter Name="password" />
            <asp:Parameter Name="endDate" />
            <asp:Parameter Name="enableAdEdit" />
        </InsertParameters>
    </asp:SqlDataSource>
    <br />
    
</asp:Content>

