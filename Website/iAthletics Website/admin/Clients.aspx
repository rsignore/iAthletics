<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Clients.aspx.cs" Inherits="admin_Clients" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<h2>Administer Mobile Client Information</h2>
<p>
    <asp:GridView ID="ClientsGrid" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
        DataKeyNames="clientId" DataSourceID="ClientsGridDs" ForeColor="Black" 
        GridLines="Vertical" 
        onselectedindexchanged="ClientsGrid_SelectedIndexChanged">
        <RowStyle BackColor="#F7F7DE" />
        <Columns>
            <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
            <asp:BoundField DataField="clientOs" HeaderText="clientOs" 
                SortExpression="clientOs" />
            <asp:BoundField DataField="currentVersion" HeaderText="currentVersion" 
                SortExpression="currentVersion" />
            <asp:BoundField DataField="currentVersionUrl" HeaderText="currentVersionUrl" 
                SortExpression="currentVersionUrl" />
        </Columns>
        <FooterStyle BackColor="#CCCC99" />
        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    <asp:SqlDataSource ID="ClientsGridDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        SelectCommand="SELECT [clientId], [clientOs], [currentVersion], [currentVersionUrl] FROM [Clients] ORDER BY [clientOs]">
    </asp:SqlDataSource>
    <asp:FormView ID="ClientsForm" runat="server" DataKeyNames="clientId" 
        DataSourceID="ClientsFormDs" oniteminserted="ClientsForm_ItemInserted" 
        onitemupdated="ClientsForm_ItemUpdated">
        <EditItemTemplate>
            <asp:HiddenField ID="HiddenField1" runat="server" 
                Value='<%# Bind("clientId") %>' />
            <br />
            <table>
                <tr>
                    <td>
                        clientOs:
                    </td>
                    <td>
                        <asp:TextBox ID="clientOsTextBox" runat="server" MaxLength="25" 
                            Text='<%# Bind("clientOs") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="clientOsTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        currentVersion:
                    </td>
                    <td>
                        <asp:TextBox ID="currentVersionTextBox" runat="server" MaxLength="10" 
                            Text='<%# Bind("currentVersion") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                            ControlToValidate="currentVersionTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                            ControlToValidate="currentVersionTextBox" 
                            ErrorMessage="Must be a decimal number" ValidationExpression="\d+.\d+"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        currentVersionUrl:
                    </td>
                    <td>
                        <asp:TextBox ID="currentVersionUrlTextBox" runat="server" 
                            Text='<%# Bind("currentVersionUrl") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                            ControlToValidate="currentVersionUrlTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
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
                        clientOs:
                    </td>
                    <td>
                        <asp:TextBox ID="clientOsTextBox" runat="server" MaxLength="25" 
                            Text='<%# Bind("clientOs") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="clientOsTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        currentVersion:
                    </td>
                    <td>
                        <asp:TextBox ID="currentVersionTextBox" runat="server" MaxLength="10" 
                            Text='<%# Bind("currentVersion") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                            ControlToValidate="currentVersionTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                            ControlToValidate="currentVersionTextBox" 
                            ErrorMessage="Must be a decimal number" ValidationExpression="\d+.\d+"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        currentVersionUrl:
                    </td>
                    <td>
                        <asp:TextBox ID="currentVersionUrlTextBox" runat="server" 
                            Text='<%# Bind("currentVersionUrl") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                            ControlToValidate="currentVersionUrlTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>
        <ItemTemplate>
            <asp:Button ID="AddButton" runat="server" 
                Text="Add client" CommandName="New" />
            &nbsp;<asp:Button ID="EditButton" runat="server" 
                Text="Edit client" CommandName="Edit" />
        </ItemTemplate>
        <EmptyDataTemplate>
            <asp:Button ID="AddButton" runat="server" 
                Text="Add client" CommandName="New" />
        </EmptyDataTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="ClientsFormDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        DeleteCommand="DELETE FROM [Clients] WHERE [clientId] = @clientId" 
        InsertCommand="INSERT INTO [Clients] ([clientOs], [currentVersion], [currentVersionUrl]) VALUES (@clientOs, @currentVersion, @currentVersionUrl)" 
        SelectCommand="SELECT [clientId], [clientOs], [currentVersion], [currentVersionUrl] FROM [Clients] WHERE ([clientId] = @clientId)" 
        
        UpdateCommand="UPDATE [Clients] SET [clientOs] = @clientOs, [currentVersion] = @currentVersion, [currentVersionUrl] = @currentVersionUrl WHERE [clientId] = @clientId">
        <SelectParameters>
            <asp:ControlParameter ControlID="ClientsGrid" Name="clientId" 
                PropertyName="SelectedValue" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="clientId" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="clientOs" Type="String" />
            <asp:Parameter Name="currentVersion" Type="Double" />
            <asp:Parameter Name="currentVersionUrl" Type="String" />
            <asp:Parameter Name="clientId" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="clientOs" Type="String" />
            <asp:Parameter Name="currentVersion" Type="Double" />
            <asp:Parameter Name="currentVersionUrl" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>
</p>
</asp:Content>

