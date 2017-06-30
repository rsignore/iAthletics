<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="TeamLinks.aspx.cs" Inherits="admin_TeamLinks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style3
        {
            text-align: right;
        }
        .style4
        {
            text-align: right;
        }
        .style5
        {
            text-align: right;
            font-weight: bold;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p>
    <asp:HyperLink ID="HyperLink2" runat="server" 
        NavigateUrl="~/admin/Applications.aspx">Applications</asp:HyperLink>
    &nbsp;&gt;&gt;
    <asp:HyperLink ID="TeamsHyperlink" runat="server" 
        NavigateUrl="~/admin/Teams.aspx">Teams</asp:HyperLink>
    </p>
    <h2>Links for 
    <asp:Label ID="AppLabel" runat="server"></asp:Label>
    <asp:Label ID="TeamLabel" runat="server"></asp:Label>
    <asp:Label ID="SportLabel" runat="server"></asp:Label>
    Team</h2>
    <p>
        <asp:GridView ID="LinksGrid" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
            BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
            DataKeyNames="teamLinkId" DataSourceID="LinksGridDs" ForeColor="Black" 
            GridLines="Vertical" 
            onselectedindexchanged="LinksGrid_SelectedIndexChanged" 
            EnableModelValidation="True">
            <RowStyle BackColor="#F7F7DE" />
            <Columns>
                <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
                <asp:BoundField DataField="linkName" HeaderText="linkName" 
                    SortExpression="linkName" />
                <asp:BoundField DataField="linkDescription" HeaderText="linkDescription" 
                    SortExpression="linkDescription" />
                <asp:ImageField DataImageUrlField="linkTypeId" 
                    DataImageUrlFormatString="~/images/GetLinkTypeIcon.ashx?linkTypeId={0}" 
                    HeaderText="Link Type">
                </asp:ImageField>
                <asp:HyperLinkField DataNavigateUrlFields="linkUrl" DataTextField="linkUrl" 
                    HeaderText="URL" />
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
        <asp:SqlDataSource ID="LinksGridDs" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            
            SelectCommand="SELECT TeamLinks.teamLinkId, TeamLinks.teamId, TeamLinks.linkTypeId, TeamLinks.linkName, TeamLinks.linkDescription, TeamLinks.linkUrl FROM LinkTypes INNER JOIN TeamLinks ON LinkTypes.linkTypeId = TeamLinks.linkTypeId WHERE (TeamLinks.teamId = @teamId) ORDER BY TeamLinks.linkName">
            <SelectParameters>
                <asp:SessionParameter Name="teamId" SessionField="TeamIdParam" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:FormView ID="LinkForm" runat="server" DataKeyNames="teamLinkId" 
            DataSourceID="LinkFormDs" onitemdeleted="LinkForm_ItemDeleted" 
            oniteminserted="LinkForm_ItemInserted" oniteminserting="LinkForm_ItemInserting" 
            onitemupdated="LinkForm_ItemUpdated">
            <EditItemTemplate>
                <asp:HiddenField ID="HiddenField1" runat="server" 
                    Value='<%# Bind("teamLinkId") %>' />
                <table class="style3">
                    <tr>
                        <td class="style4" valign="top">
                            <b>Link Type:</b></td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="LinkTypeDs" 
                                DataTextField="linkTypeName" DataValueField="linkTypeId" 
                                SelectedValue='<%# Bind("linkTypeId") %>'>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="LinkTypeDs" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                                SelectCommand="SELECT [linkTypeId], [linkTypeName] FROM [LinkTypes] ORDER BY [linkTypeName]">
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="style5" valign="top">
                            Link Name:</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="linkNameTextBox" runat="server" MaxLength="50" 
                                Text='<%# Bind("linkName") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="linkNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                            <br />
                            Hint: The link name is displayed to the user in the mobile application.</td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Link Description:</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="linkDescriptionTextBox" runat="server" MaxLength="128" 
                                Text='<%# Bind("linkDescription") %>' Width="303px" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Link URL:</td>
                        <td>
                            <asp:TextBox ID="linkUrlTextBox" runat="server" MaxLength="256" 
                                Text='<%# Bind("linkUrl") %>' Width="417px" style="text-align: left" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="linkUrlTextBox" ErrorMessage="Required" 
                                Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                ControlToValidate="linkUrlTextBox" ErrorMessage="URL required" 
                                style="text-align: left" 
                                ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"></asp:RegularExpressionValidator>
                            <br />
                        </td>
                    </tr>
                </table>
                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                    CommandName="Update" Text="Update" />
&nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" 
                    CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>
            <InsertItemTemplate>
                <asp:HiddenField ID="HiddenField1" runat="server" 
                    Value='<%# Bind("teamId") %>' />
                <table class="style3">
                    <tr>
                        <td class="style4">
                            <b>Link Type:</b></td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="LinkTypeDs" 
                                DataTextField="linkTypeName" DataValueField="linkTypeId" 
                                SelectedValue='<%# Bind("linkTypeId") %>'>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="LinkTypeDs" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                                SelectCommand="SELECT [linkTypeId], [linkTypeName] FROM [LinkTypes] ORDER BY [linkTypeName]">
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="style5" valign="top">
                            Link Name:</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="linkNameTextBox" runat="server" MaxLength="50" 
                                Text='<%# Bind("linkName") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="linkNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                            <br />
                            Hint: The link name is displayed to the user in the mobile application.</td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Link Description:</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="linkDescriptionTextBox" runat="server" MaxLength="128" 
                                Text='<%# Bind("linkDescription") %>' Width="303px" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Link URL:</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="linkUrlTextBox" runat="server" MaxLength="256" 
                                Text='<%# Bind("linkUrl") %>' Width="417px" style="text-align: left" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="linkUrlTextBox" ErrorMessage="Required" 
                                Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                ControlToValidate="linkUrlTextBox" ErrorMessage="URL required" 
                                style="text-align: left" 
                                ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                </table>
                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                    CommandName="Insert" Text="Insert" />
                &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
            <ItemTemplate>
                <asp:HiddenField ID="HiddenField2" runat="server" 
                    Value='<%# Eval("teamLinkId") %>' />
                <asp:Button ID="AddButton" runat="server" CommandName="New" Text="Add Link" />
                &nbsp;<asp:Button ID="EditButton" runat="server" CommandName="Edit" 
                    Text="Edit Link" />
                &nbsp;<asp:Button ID="DeleteButton" runat="server" CommandName="Delete" 
                    onclientclick="return confirm('Are you sure you want to delete this link?');" 
                    Text="Delete Link" BackColor="Red" />
                <br />
            </ItemTemplate>
            <EmptyDataTemplate>
                <asp:Button ID="AddButton" runat="server" CommandName="New" Text="Add Link" />
            </EmptyDataTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="LinkFormDs" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            DeleteCommand="DELETE FROM TeamLinks WHERE (teamLinkId = @teamLinkId)" 
            InsertCommand="INSERT INTO TeamLinks(teamId, linkTypeId, linkName, linkDescription, linkUrl) VALUES (@teamId, @linkTypeId, @linkName, @linkDescription, @linkUrl)" 
            SelectCommand="SELECT teamLinkId, linkTypeId, linkName, linkDescription, teamId, linkUrl FROM TeamLinks WHERE (teamLinkId = @teamLinkId)" 
            UpdateCommand="UPDATE TeamLinks SET linkTypeId = @linkTypeId, linkName = @linkName, linkDescription = @linkDescription, linkUrl = @linkUrl WHERE (teamLinkId = @teamLinkId)">
            <SelectParameters>
                <asp:ControlParameter ControlID="LinksGrid" Name="teamLinkId" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="teamLinkId" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="linkTypeId" />
                <asp:Parameter Name="linkName" />
                <asp:Parameter Name="linkDescription" />
                <asp:Parameter Name="linkUrl" />
                <asp:Parameter Name="teamLinkId" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="teamId" />
                <asp:Parameter Name="linkTypeId" />
                <asp:Parameter Name="linkName" />
                <asp:Parameter Name="linkDescription" />
                <asp:Parameter Name="linkUrl" />
            </InsertParameters>
        </asp:SqlDataSource>
    </p>
</asp:Content>

