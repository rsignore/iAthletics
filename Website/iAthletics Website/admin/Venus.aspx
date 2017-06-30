<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Venus.aspx.cs" Inherits="admin_Venus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2>Venues</h2>
    <asp:Panel ID="AppSelectPanel" runat="server">
    Select Application:<asp:DropDownList ID="AppIdDropDown" runat="server" 
        DataSourceID="AppSelectDS" DataTextField="appName" 
    DataValueField="appId" 
    onselectedindexchanged="AppIdDropDown_SelectedIndexChanged" 
        AutoPostBack="True">
    </asp:DropDownList>
    <asp:SqlDataSource ID="AppSelectDS" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        SelectCommand="SELECT appId, appName FROM dbo.Applications ORDER BY appName">
    </asp:SqlDataSource>
    </asp:Panel>
    
    <p>
    <asp:GridView ID="VenuGrid" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
        DataKeyNames="venuId" DataSourceID="VenusGridDs" ForeColor="Black" 
        GridLines="Vertical" onselectedindexchanged="VenuGrid_SelectedIndexChanged" 
            PageSize="25" EnableModelValidation="True">
        <RowStyle BackColor="#F7F7DE" />
        <Columns>
            <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
            <asp:BoundField DataField="venuName" HeaderText="Venue Name" 
                SortExpression="venuName" />
            <asp:BoundField DataField="venuAddress1" HeaderText="Address " 
                SortExpression="venuAddress1" />
            <asp:BoundField DataField="venuCity" HeaderText="City" 
                SortExpression="venuCity" />
            <asp:BoundField DataField="venuState" HeaderText="State" 
                SortExpression="venuState" />
            <asp:BoundField DataField="venuZip" HeaderText="Zip" SortExpression="venuZip" />
        </Columns>
        <FooterStyle BackColor="#CCCC99" />
        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    <asp:SqlDataSource ID="VenusGridDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        
            
            
            SelectCommand="SELECT venuId, venuName, venuAddress1, venuAddress2, venuCity, venuZip, venuPhone, venuWebsite, venuState, appId FROM Venus ORDER BY venuName" FilterExpression="appId = {0}" 
            >

    </asp:SqlDataSource>
    <asp:FormView ID="VenuForm" runat="server" DataKeyNames="venuId" 
        DataSourceID="VenuFormDs" oniteminserted="VenuForm_ItemInserted" 
        onitemupdated="VenuForm_ItemUpdated" oniteminserting="VenuForm_ItemInserting">
        <EditItemTemplate>
            <asp:HiddenField ID="HiddenField1" runat="server" 
                Value='<%# Bind("venuId") %>' />
            <table>
                <tr>
                    <td>
                        <b>Venue name: </b>
                    </td>
                    <td>
                        <asp:TextBox ID="venuNameTextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("venuName") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="venuNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: 700; text-align: right">
                        Address:
                    </td>
                    <td>
                        <asp:TextBox ID="venuAddress1TextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("venuAddress1") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                            ControlToValidate="venuAddress1TextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td>
                        <asp:TextBox ID="venuAddress2TextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("venuAddress2") %>' />
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: 700; text-align: right">
                        City:</td>
                    <td>
                        <asp:TextBox ID="venuCityTextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("venuCity") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                            ControlToValidate="venuCityTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: 700; text-align: right">
                        State:</td>
                    <td>
                        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="StatesDs" 
                            DataTextField="stateAbv" DataValueField="stateAbv" 
                            SelectedValue='<%# Bind("venuState") %>'>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="StatesDs" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                            SelectCommand="SELECT [stateAbv] FROM [States] ORDER BY [stateAbv]">
                        </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: 700; text-align: right">
                        Zip:</td>
                    <td>
                        <asp:TextBox ID="venuZipTextBox" runat="server" MaxLength="10" 
                            Text='<%# Bind("venuZip") %>' />
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                            ControlToValidate="venuZipTextBox" ErrorMessage="Enter a valid zip." 
                            ValidationExpression="\d{5}(-\d{4})?"></asp:RegularExpressionValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                            ControlToValidate="venuZipTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                CommandName="Update" Text="Update" />
&nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" 
                CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>
        <InsertItemTemplate>
            <table>
                <tr>
                    <td>
                        V<b>enu name: </b>
                    </td>
                    <td>
                        <asp:TextBox ID="venuNameTextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("venuName") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="venuNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: 700; text-align: right">
                        Address:
                    </td>
                    <td>
                        <asp:TextBox ID="venuAddress1TextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("venuAddress1") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                            ControlToValidate="venuAddress1TextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td>
                        <asp:TextBox ID="venuAddress2TextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("venuAddress2") %>' />
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: 700; text-align: right">
                        City:</td>
                    <td>
                        <asp:TextBox ID="venuCityTextBox" runat="server" MaxLength="50" 
                            Text='<%# Bind("venuCity") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                            ControlToValidate="venuCityTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: 700; text-align: right">
                        State:</td>
                    <td>
                        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="StatesDs" 
                            DataTextField="stateAbv" DataValueField="stateAbv" 
                            SelectedValue='<%# Bind("venuState") %>'>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="StatesDs" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                            SelectCommand="SELECT [stateAbv] FROM [States] ORDER BY [stateAbv]">
                        </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: 700; text-align: right">
                        Zip:</td>
                    <td>
                        <asp:TextBox ID="venuZipTextBox" runat="server" MaxLength="10" 
                            Text='<%# Bind("venuZip") %>' />
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                            ControlToValidate="venuZipTextBox" ErrorMessage="Enter a valid zip." 
                            ValidationExpression="\d{5}(-\d{4})?"></asp:RegularExpressionValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                            ControlToValidate="venuZipTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancel" 
                onclick="InsertCancelButton_Click" />
        </InsertItemTemplate>
        <ItemTemplate>
            <asp:Button ID="AddButton" runat="server" CommandName="New" Text="Add Venue" />
            &nbsp;<asp:Button ID="EditButton" runat="server" CommandName="Edit" 
                Text="Edit Venue" />
            <br />
        </ItemTemplate>
        <EmptyDataTemplate>
            <asp:Button ID="AddButton" runat="server" CommandName="New" Text="Add Venue" />
        </EmptyDataTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="VenuFormDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        InsertCommand="INSERT INTO Venus(venuName, venuAddress1, venuAddress2, venuCity, venuState, venuZip, appId) VALUES (@venuName, @venuAddress1, @venuAddress2, @venuCity, @venuState, @venuZip, @appId)" 
        SelectCommand="SELECT venuId, venuName, venuAddress1, venuAddress2, venuCity, venuState, venuZip, appId FROM Venus WHERE (venuId = @venuId)" 
        
            UpdateCommand="UPDATE Venus SET venuName = @venuName, venuAddress1 = @venuAddress1, venuAddress2 = @venuAddress2, venuCity = @venuCity, venuState = @venuState, venuZip = @venuZip, venuPhone = @venuPhone, venuWebsite = @venuWebsite WHERE (venuId = @venuId)">
        <SelectParameters>
            <asp:ControlParameter ControlID="VenuGrid" Name="venuId" 
                PropertyName="SelectedValue" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="venuName" />
            <asp:Parameter Name="venuAddress1" />
            <asp:Parameter Name="venuAddress2" />
            <asp:Parameter Name="venuCity" />
            <asp:Parameter Name="venuState" />
            <asp:Parameter Name="venuZip" />
            <asp:Parameter Name="venuPhone" />
            <asp:Parameter Name="venuWebsite" />
            <asp:Parameter Name="venuId" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="venuName" />
            <asp:Parameter Name="venuAddress1" />
            <asp:Parameter Name="venuAddress2" />
            <asp:Parameter Name="venuCity" />
            <asp:Parameter Name="venuState" />
            <asp:Parameter Name="venuZip" />
            <asp:Parameter Name="appId" />
        </InsertParameters>
    </asp:SqlDataSource>
</p>
</asp:Content>

