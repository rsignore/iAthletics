<%@ Page Title="Administer Seasons" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Seasons.aspx.cs" Inherits="admin_Seasons" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<h2>Administer Seasons</h2>
    <asp:GridView ID="SeasonsGrid" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
        DataKeyNames="seasonId" DataSourceID="SeasonsGridDs" ForeColor="Black" 
        GridLines="Vertical" onselectedindexchanged="SeasonsGrid_SelectedIndexChanged">
        <RowStyle BackColor="#F7F7DE" />
        <Columns>
            <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
            <asp:BoundField DataField="SeasonName" HeaderText="Season" 
                SortExpression="SeasonName" />
            <asp:BoundField DataField="seasonIconFileName" HeaderText="Icon File Name" 
                SortExpression="seasonIconFileName" />
            <asp:ImageField DataImageUrlField="seasonId" 
                DataImageUrlFormatString="~/images/GetSeasonIcon.ashx?seasonId={0}" 
                HeaderText="Icon Image">
            </asp:ImageField>
        </Columns>
        <FooterStyle BackColor="#CCCC99" />
        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    <asp:SqlDataSource ID="SeasonsGridDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        SelectCommand="SELECT seasonId, SeasonName, seasonIconFileName FROM Seasons ORDER BY SeasonName">
    </asp:SqlDataSource>
    <asp:FormView ID="SeasonForm" runat="server" DataKeyNames="seasonId" 
        DataSourceID="SeasonsFormDs" oniteminserted="SeasonForm_ItemInserted" 
        onitemupdated="SeasonForm_ItemUpdated">
        <EditItemTemplate>
            <asp:HiddenField ID="SeasonIdHidden" runat="server" 
                Value='<%# Bind("seasonId") %>' />
            <br />
            SeasonName:
            <asp:TextBox ID="SeasonNameTextBox" runat="server" 
                Text='<%# Bind("SeasonName") %>' />
            <br />
            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                CommandName="Update" Text="Update" />
&nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" 
                CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>
        <InsertItemTemplate>
            <b>SeasonName:</b>
            <asp:TextBox ID="SeasonNameTextBox" runat="server" MaxLength="50" 
                Text='<%# Bind("SeasonName") %>' />
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>
        <ItemTemplate>
            <asp:Button ID="AddButton" runat="server" CommandName="New" Text="Add season" />
            <br />
            <asp:Button ID="EditButton" runat="server" CommandName="Edit" 
                Text="Edit season name" />
            &nbsp;<asp:Button ID="EditIconButton" runat="server" Text="Edit Icon" 
                onclick="EditIconButton_Click" />
        </ItemTemplate>
        <EmptyDataTemplate>
            <asp:Button ID="AddButton" runat="server" CommandName="New" Text="Add season" />
        </EmptyDataTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SeasonsFormDs" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        InsertCommand="INSERT INTO Seasons(SeasonName) VALUES (@SeasonName)" 
        SelectCommand="SELECT seasonId, SeasonName FROM Seasons WHERE (seasonId = @seasonId)" 
        UpdateCommand="UPDATE Seasons SET SeasonName = @SeasonName WHERE (seasonId = @seasonId)">
        <SelectParameters>
            <asp:ControlParameter ControlID="SeasonsGrid" Name="seasonId" 
                PropertyName="SelectedValue" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="SeasonName" />
            <asp:Parameter Name="seasonId" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="SeasonName" />
        </InsertParameters>
    </asp:SqlDataSource>
</asp:Content>

