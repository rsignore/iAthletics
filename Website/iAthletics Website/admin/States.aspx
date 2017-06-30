<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="States.aspx.cs" Inherits="admin_States" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<h2>Administer State List</h2>
<p><asp:GridView ID="StateGrid" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
        DataKeyNames="stateAbv" DataSourceID="StatesDs" ForeColor="Black" 
        GridLines="Vertical" onselectedindexchanged="StateGrid_SelectedIndexChanged">
    <RowStyle BackColor="#F7F7DE" />
    <Columns>
        <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
        <asp:BoundField DataField="stateAbv" HeaderText="stateAbv" ReadOnly="True" 
            SortExpression="stateAbv" />
    </Columns>
    <FooterStyle BackColor="#CCCC99" />
    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
    <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    <asp:SqlDataSource ID="StatesDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        DeleteCommand="DELETE FROM [States] WHERE [stateAbv] = @stateAbv" 
        InsertCommand="INSERT INTO [States] ([stateAbv]) VALUES (@stateAbv)" 
        SelectCommand="SELECT [stateAbv] FROM [States] ORDER BY [stateAbv]">
        <DeleteParameters>
            <asp:Parameter Name="stateAbv" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="stateAbv" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:FormView ID="StateForm" runat="server" DataKeyNames="stateAbv" 
        DataSourceID="StateFormDs" onitemdeleted="StateForm_ItemDeleted" 
        oniteminserted="StateForm_ItemInserted">
        <EditItemTemplate>
            stateAbv:
            <asp:Label ID="stateAbvLabel1" runat="server" Text='<%# Eval("stateAbv") %>' />
            <br />
            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>
        <InsertItemTemplate>
            <b>stateAbv:</b>
            <asp:TextBox ID="stateAbvTextBox" runat="server" MaxLength="2" 
                Text='<%# Bind("stateAbv") %>' />
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                ControlToValidate="stateAbvTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                ControlToValidate="stateAbvTextBox" 
                ErrorMessage="Must be 2 upper case characters" ValidationExpression="[A-Z]{2}"></asp:RegularExpressionValidator>
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>
        <ItemTemplate>
            <asp:HiddenField ID="HiddenField1" runat="server" 
                Value='<%# Bind("stateAbv") %>' />
            <br />
            <asp:Button ID="Button1" runat="server" CommandName="New" Text="Add State" />
            &nbsp;<asp:Button ID="Button2" runat="server" 
                onclientclick="return confirm('Are you sure you want to delete the State abv?');" 
                Text="Delete State" CommandName="Delete" />
        </ItemTemplate>
        <EmptyDataTemplate>
            <asp:Button ID="Button1" runat="server" Text="Add State" CommandName="New" />
        </EmptyDataTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="StateFormDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        DeleteCommand="DELETE FROM [States] WHERE [stateAbv] = @stateAbv" 
        InsertCommand="INSERT INTO [States] ([stateAbv]) VALUES (@stateAbv)" 
        
        SelectCommand="SELECT [stateAbv] FROM [States] WHERE [stateAbv] = @stateAbv ORDER BY 1">
        <SelectParameters>
            <asp:ControlParameter ControlID="StateGrid" Name="stateAbv" 
                PropertyName="SelectedValue" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="stateAbv" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="stateAbv" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>
</p>
    

</asp:Content>

