<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Sports.aspx.cs" Inherits="admin_Sports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2>
        Sports Administration</h2>
    <p>
        <asp:GridView ID="SportGrid" runat="server" AllowPaging="True" 
            AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" 
            BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="sportId" 
            DataSourceID="SportsDS" ForeColor="Black" GridLines="Vertical" 
            onselectedindexchanged="SportGrid_SelectedIndexChanged" 
            AllowSorting="True" PageSize="25">
            <RowStyle BackColor="#F7F7DE" />
            <Columns>
                <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
                <asp:BoundField DataField="sportName" HeaderText="Sport Name" 
                    SortExpression="sportName" />
                <asp:BoundField DataField="iconFileName" HeaderText="Icon Name" 
                    SortExpression="iconFileName" />
                <asp:ImageField DataImageUrlField="sportId" 
                    DataImageUrlFormatString="~/images/GetSportIcon.ashx?sportId={0}" 
                    HeaderText="Icon">
                </asp:ImageField>
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
        <asp:SqlDataSource ID="SportsDS" runat="server" 
            ConflictDetection="CompareAllValues" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            DeleteCommand="DELETE FROM [Sports] WHERE [sportId] = @original_sportId AND [sportName] = @original_sportName AND (([sportIcon] = @original_sportIcon) OR ([sportIcon] IS NULL AND @original_sportIcon IS NULL)) AND (([iconFileName] = @original_iconFileName) OR ([iconFileName] IS NULL AND @original_iconFileName IS NULL))" 
            InsertCommand="INSERT INTO [Sports] ([sportName], [sportIcon], [iconFileName]) VALUES (@sportName, @sportIcon, @iconFileName)" 
            OldValuesParameterFormatString="original_{0}" 
            SelectCommand="SELECT [sportId], [sportName], [sportIcon], [iconFileName] FROM [Sports] ORDER BY [sportName]" 
            
            UpdateCommand="UPDATE [Sports] SET [sportName] = @sportName, [sportIcon] = @sportIcon, [iconFileName] = @iconFileName WHERE [sportId] = @original_sportId AND [sportName] = @original_sportName AND (([sportIcon] = @original_sportIcon) OR ([sportIcon] IS NULL AND @original_sportIcon IS NULL)) AND (([iconFileName] = @original_iconFileName) OR ([iconFileName] IS NULL AND @original_iconFileName IS NULL))">
            <DeleteParameters>
                <asp:Parameter Name="original_sportId" Type="Int32" />
                <asp:Parameter Name="original_sportName" Type="String" />
                <asp:Parameter Name="original_sportIcon" Type="Object" />
                <asp:Parameter Name="original_iconFileName" Type="String" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="sportName" Type="String" />
                <asp:Parameter Name="sportIcon" Type="Object" />
                <asp:Parameter Name="iconFileName" Type="String" />
                <asp:Parameter Name="original_sportId" Type="Int32" />
                <asp:Parameter Name="original_sportName" Type="String" />
                <asp:Parameter Name="original_sportIcon" Type="Object" />
                <asp:Parameter Name="original_iconFileName" Type="String" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="sportName" Type="String" />
                <asp:Parameter Name="sportIcon" Type="Object" />
                <asp:Parameter Name="iconFileName" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
    </p>
    <p>
        <asp:FormView ID="SportForm" runat="server" DataKeyNames="sportId" 
            DataSourceID="SportFormDS" oniteminserted="SportForm_ItemInserted" 
            onitemupdated="SportForm_ItemUpdated">
            <EditItemTemplate>
                sportId:
                <asp:Label ID="sportIdLabel1" runat="server" Text='<%# Eval("sportId") %>' />
                <br />
                <table class="style3">
                    <tr>
                        <td class="style4">
                            <b>Sport Name:</b></td>
                        <td>
                            <asp:TextBox ID="sportNameTextBox" runat="server" MaxLength="50" 
                                Text='<%# Bind("sportName") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="sportNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                </table>
                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                    CommandName="Update" Text="Update" />
                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>
            <InsertItemTemplate>
                <table class="style3">
                    <tr>
                        <td class="style4">
                            <b>Sport Name:</b></td>
                        <td>
                            <asp:TextBox ID="sportNameTextBox" runat="server" MaxLength="50" 
                                Text='<%# Bind("sportName") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="sportNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                </table>
                <b>&nbsp;</b><asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                    CommandName="Insert" Text="Insert" />
&nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" 
                    CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
            <ItemTemplate>
                <asp:Button ID="NewSportButton" runat="server" CommandName="New" 
                    Text="New Sport" />
                &nbsp;<br />
                <asp:Button ID="EditSportButton" runat="server" CommandName="Edit" 
                    Text="Edit Sport Name" />
                &nbsp;<asp:Button ID="EditIconButton" runat="server" onclick="EditIconButton_Click" 
                    Text="Edit Icon" />
            </ItemTemplate>
            <EmptyDataTemplate>
                <asp:Button ID="NewSportButton" runat="server" CommandName="New" 
                    Text="New Sport" />
            </EmptyDataTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="SportFormDS" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            InsertCommand="INSERT INTO Sports(sportName) VALUES (@sportName)" 
            
            
            SelectCommand="SELECT sportId, sportName, iconFileName, sportIcon FROM Sports WHERE (sportId = @sportId)" 
            
            
            UpdateCommand="UPDATE Sports SET sportName = @sportName WHERE (sportId = @sportId)">
            <SelectParameters>
                <asp:ControlParameter ControlID="SportGrid" Name="sportId" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="sportName" />
                <asp:Parameter Name="sportId" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="sportName" />
            </InsertParameters>
        </asp:SqlDataSource>
    </p>
</asp:Content>

