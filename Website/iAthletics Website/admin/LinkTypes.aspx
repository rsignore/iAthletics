<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="LinkTypes.aspx.cs" Inherits="admin_LinkTypes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<h2>Administer Link Types</h2>
    <asp:GridView ID="LinkTypeGrid" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
        DataKeyNames="linkTypeId" DataSourceID="LinkTypeGridDs" ForeColor="Black" 
        GridLines="Vertical" onselectedindexchanged="LinkTypeGrid_SelectedIndexChanged">
        <RowStyle BackColor="#F7F7DE" />
        <Columns>
            <asp:CommandField ShowSelectButton="True" />
            <asp:BoundField DataField="linkTypeName" HeaderText="linkTypeName" 
                SortExpression="linkTypeName" />
            <asp:BoundField DataField="linkTypeIconFileName" 
                HeaderText="linkTypeIconFileName" SortExpression="linkTypeIconFileName" />
            <asp:ImageField DataImageUrlField="linkTypeId" 
                DataImageUrlFormatString="~/images/GetLinkTypeIcon.ashx?linkTypeId={0}" 
                HeaderText="Icon">
            </asp:ImageField>
        </Columns>
        <FooterStyle BackColor="#CCCC99" />
        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    <asp:SqlDataSource ID="LinkTypeGridDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        SelectCommand="SELECT linkTypeName, linkTypeIconFileName, linkTypeId FROM LinkTypes ORDER BY linkTypeName">
    </asp:SqlDataSource>
    <asp:FormView ID="LinkTypeForm" runat="server" DataKeyNames="linkTypeId" 
        DataSourceID="LinkTypeFormDs" oniteminserted="LinkTypeForm_ItemInserted" 
        onitemupdated="LinkTypeForm_ItemUpdated">
        <EditItemTemplate>
            <asp:HiddenField ID="LinkTypeIdHidden" runat="server" 
                Value='<%# Bind("linkTypeId") %>' />
            <b>Link type name:</b>
            <asp:TextBox ID="linkTypeNameTextBox" runat="server" MaxLength="25" 
                Text='<%# Bind("linkTypeName") %>' />
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                ControlToValidate="linkTypeNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
            <br />
            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>
        <InsertItemTemplate>
            <b>Link type name:</b>
            <asp:TextBox ID="linkTypeNameTextBox" runat="server" MaxLength="25" 
                Text='<%# Bind("linkTypeName") %>' />
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                ControlToValidate="linkTypeNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>
        <ItemTemplate>
            <asp:Button ID="AddButton" runat="server" CommandName="New" 
                Text="Add link type" />
            &nbsp;<asp:Button ID="EditButton" runat="server" CommandName="Edit" 
                Text="Edit type name" />
            &nbsp;<asp:Button ID="EditImage" runat="server" onclick="EditImage_Click" 
                Text="Edit icon" />
        </ItemTemplate>
        <EmptyDataTemplate>
            <asp:Button ID="AddButton" runat="server" CommandName="New" 
                Text="Add link type" />
        </EmptyDataTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="LinkTypeFormDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        InsertCommand="INSERT INTO LinkTypes(linkTypeName) VALUES (@linkTypeName)" 
        SelectCommand="SELECT linkTypeName, linkTypeId FROM LinkTypes WHERE (linkTypeId = @linkTypeId) ORDER BY linkTypeName" 
        UpdateCommand="UPDATE LinkTypes SET linkTypeName = @linkTypeName WHERE (linkTypeId = @linkTypeId)">
        <SelectParameters>
            <asp:ControlParameter ControlID="LinkTypeGrid" Name="linkTypeId" 
                PropertyName="SelectedValue" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="linkTypeName" />
            <asp:Parameter Name="linkTypeId" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="linkTypeName" />
        </InsertParameters>
    </asp:SqlDataSource>
</asp:Content>

