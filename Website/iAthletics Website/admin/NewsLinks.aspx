<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="NewsLinks.aspx.cs" Inherits="admin_NewsLinks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style4
        {
            font-weight: 700;
            text-align: right;
        }
        .style8
        {
            width: 586px;
        }
        .style3
        {
            width: 758px;
        }
        .style6
        {
            text-align: right;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p>
        <asp:HyperLink ID="HyperLink2" runat="server" 
            NavigateUrl="~/admin/Applications.aspx">Applications</asp:HyperLink>
&nbsp;&gt;&gt;
    </p>
    <h2>
        News links for
        <asp:Label ID="AppLabel" runat="server"></asp:Label>
    </h2>
    <p>
        <asp:GridView ID="LinksGrid" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
            BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
            DataKeyNames="newsLinkId" DataSourceID="LinksGridDs" ForeColor="Black" 
            GridLines="Vertical" 
            onselectedindexchanged="LinksGrid_SelectedIndexChanged" 
            EnableModelValidation="True">
            <RowStyle BackColor="#F7F7DE" />
            <Columns>
                <asp:CommandField ShowSelectButton="True" ButtonType="Button" />
                <asp:BoundField DataField="newsLinkName" HeaderText="Link Name" 
                    SortExpression="newsLinkName" />
                <asp:BoundField DataField="newsLinkDescription" HeaderText="Link Description" 
                    SortExpression="newsLinkDescription" />
                <asp:ImageField DataImageUrlField="linkTypeId" 
                    DataImageUrlFormatString="~/images/GetLinkTypeIcon.ashx?linkTypeId={0}" 
                    HeaderText="Link Type">
                    <ItemStyle Height="24px" Width="24px" />
                </asp:ImageField>
                <asp:BoundField DataField="newsLinkUrl" HeaderText="Url" 
                    SortExpression="newsLinkUrl" />
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
        <asp:SqlDataSource ID="LinksGridDs" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            SelectCommand="SELECT LinkTypes.linkTypeName, LinkTypes.linkTypeId, ApplicationNewsLinks.newsLinkId, ApplicationNewsLinks.appId, ApplicationNewsLinks.newsLinkName, ApplicationNewsLinks.newsLinkDescription, ApplicationNewsLinks.newsLinkUrl FROM ApplicationNewsLinks INNER JOIN LinkTypes ON ApplicationNewsLinks.linkTypeId = LinkTypes.linkTypeId WHERE (ApplicationNewsLinks.appId = @appId)">
            <SelectParameters>
                <asp:SessionParameter Name="appId" SessionField="AppIdParam" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:FormView ID="LinksForm" runat="server" DataKeyNames="newsLinkId" 
            DataSourceID="LinksFormDs" oniteminserted="LinksForm_ItemInserted" 
            oniteminserting="LinksForm_ItemInserting" 
            onitemupdated="LinksForm_ItemUpdated" onitemdeleted="LinksForm_ItemDeleted" 
            Width="450px">
            <EditItemTemplate>
                <table class="style3">
                    <tr>
                        <td class="style4" valign="top">
                            <b>Link type:</b></td>
                        <td class="style8">
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="LinkTypesDs" 
                                DataTextField="linkTypeName" DataValueField="linkTypeId" 
                                SelectedValue='<%# Bind("linkTypeId") %>'>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="LinkTypesDs" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                                SelectCommand="SELECT [linkTypeId], [linkTypeName] FROM [LinkTypes]">
                            </asp:SqlDataSource>
                            <asp:HiddenField ID="NewsLinkIdHidden" runat="server" 
                                Value='<%# Bind("newsLinkId") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4" valign="top">
                            <b>Link name:</b></td>
                        <td class="style8">
                            <asp:TextBox ID="newsLinkNameTextBox" runat="server" MaxLength="50" 
                                Text='<%# Bind("newsLinkName") %>' Width="251px" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="newsLinkNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                            <br />
                            Hint: The link name is displayed to the user in the mobile application.</td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Link description:</b></td>
                        <td class="style8">
                            <asp:TextBox ID="newsLinkDescriptionTextBox" runat="server" MaxLength="128" 
                                Text='<%# Bind("newsLinkDescription") %>' Width="237px" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4" valign="top">
                            Url:</td>
                        <td class="style8">
                            <asp:TextBox ID="UrlText" runat="server" MaxLength="256" 
                                Text='<%# Bind("newsLinkUrl") %>' Width="347px"></asp:TextBox>
                            &nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="UrlText" ErrorMessage="Required" Display="Dynamic"></asp:RequiredFieldValidator>
                            &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                ControlToValidate="UrlText" ErrorMessage="Must be a URL" 
                                ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                </table>
                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                    CommandName="Update" Text="Update" />
&nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" 
                    CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>
            <InsertItemTemplate>
                <table class="style3">
                    <tr>
                        <td class="style6" valign="middle">
                            <b style="text-align: right">Link type:</b></td>
                        <td class="style7">
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="LinkTypesDs" 
                                DataTextField="linkTypeName" DataValueField="linkTypeId" 
                                SelectedValue='<%# Bind("linkTypeId") %>'>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="LinkTypesDs" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                                SelectCommand="SELECT [linkTypeId], [linkTypeName] FROM [LinkTypes]">
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="style4" valign="top">
                            <b>Link name:</b></td>
                        <td class="style5">
                            <asp:TextBox ID="newsLinkNameTextBox" runat="server" MaxLength="50" 
                                Text='<%# Bind("newsLinkName") %>' Width="250px" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="newsLinkNameTextBox" ErrorMessage="Required" 
                                Display="Dynamic"></asp:RequiredFieldValidator>
                            &nbsp;<br />
                            Hint: The link name is displayed to the user in the mobile application.</td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Link description:</b></td>
                        <td class="style5">
                            <asp:TextBox ID="newsLinkDescriptionTextBox" runat="server" MaxLength="128" 
                                Text='<%# Bind("newsLinkDescription") %>' Width="237px" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4" valign="top">
                            Url:</td>
                        <td class="style5">
                            <asp:TextBox ID="UrlText" runat="server" MaxLength="256" 
                                Text='<%# Bind("newsLinkUrl") %>' Width="347px"></asp:TextBox>
                            &nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="UrlText" ErrorMessage="Required" Display="Dynamic"></asp:RequiredFieldValidator>
                            &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                ControlToValidate="UrlText" ErrorMessage="Must be a URL" 
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
                <asp:HiddenField ID="HiddenField1" runat="server" 
                    Value='<%# Bind("newsLinkId") %>' />
                <asp:Button ID="AddButton" runat="server" CommandName="New" 
                    Text="Add news link" />
                &nbsp;<asp:Button ID="EditButton" runat="server" CommandName="Edit" 
                    Text="Edit news link" />
                &nbsp;<asp:Button ID="DeleteButton" runat="server" CommandName="Delete" 
                    onclientclick="return confirm('Are you sure you want to delete this link?');" 
                    Text="Delete news link" BackColor="Red" />
            </ItemTemplate>
            <EmptyDataTemplate>
                <asp:Button ID="AddButton" runat="server" CommandName="New" 
                    Text="Add News Link" />
            </EmptyDataTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="LinksFormDs" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            InsertCommand="INSERT INTO ApplicationNewsLinks(appId, linkTypeId, newsLinkName, newsLinkDescription, newsLinkUrl) VALUES (@appId, @linkTypeId, @newsLinkName, @newsLinkDescription, @newsLinkUrl)" 
            SelectCommand="SELECT newsLinkId, appId, linkTypeId, newsLinkName, newsLinkDescription, newsLinkUrl FROM ApplicationNewsLinks WHERE (newsLinkId = @newsLinkId)" 
            
            UpdateCommand="UPDATE ApplicationNewsLinks SET linkTypeId = @linkTypeId, newsLinkName = @newsLinkName, newsLinkDescription = @newsLinkDescription, newsLinkUrl = @newsLinkUrl WHERE (newsLinkId = @newsLinkId)" 
            DeleteCommand="DELETE FROM ApplicationNewsLinks WHERE (newsLinkId = @newsLinkId)">
            <SelectParameters>
                <asp:ControlParameter ControlID="LinksGrid" Name="newsLinkId" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="newsLinkId" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="linkTypeId" />
                <asp:Parameter Name="newsLinkName" />
                <asp:Parameter Name="newsLinkDescription" />
                <asp:Parameter Name="newsLinkUrl" />
                <asp:Parameter Name="newsLinkId" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="appId" />
                <asp:Parameter Name="linkTypeId" />
                <asp:Parameter Name="newsLinkName" />
                <asp:Parameter Name="newsLinkDescription" />
                <asp:Parameter Name="newsLinkUrl" />
            </InsertParameters>
        </asp:SqlDataSource>
    </p>
</asp:Content>

