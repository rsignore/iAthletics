<%@ Page Title="Team Roster" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="TeamRoster.aspx.cs" Inherits="admin_TeamSchedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p>
        <asp:HyperLink ID="HyperLink2" runat="server" 
            NavigateUrl="~/admin/Applications.aspx">Applications</asp:HyperLink>
        &nbsp;&gt;&gt;
        <asp:HyperLink ID="TeamsHyperlink" runat="server" 
            NavigateUrl="~/admin/Teams.aspx">Teams</asp:HyperLink>
    </p>
    <h2>
        Roster for
        <asp:Label ID="AppLabel" runat="server"></asp:Label>
        <asp:Label ID="TeamLabel" runat="server"></asp:Label>
        <asp:Label ID="SportLabel" runat="server"></asp:Label>
    </h2>
    <p>
        <asp:GridView ID="RosterGrid" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="rosterId" 
            DataSourceID="RosterGridDs" BackColor="White" BorderColor="#DEDFDE" 
            BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" 
            GridLines="Vertical" 
            onselectedindexchanged="RosterGrid_SelectedIndexChanged" 
            EnableModelValidation="True" PageSize="50">
            <RowStyle BackColor="#F7F7DE" />
            <Columns>
                <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
                <asp:BoundField DataField="playerName" HeaderText="Name" 
                    SortExpression="playerName" />
                <asp:BoundField DataField="playerNumber" HeaderText="Number" 
                    SortExpression="playerNumber" />
                <asp:BoundField DataField="playerGrade" HeaderText="Grade" 
                    SortExpression="playerGrade" />
                <asp:BoundField DataField="playerHeight" HeaderText="Height" 
                    SortExpression="playerHeight" />
                <asp:BoundField DataField="playerWeight" HeaderText="Weight" 
                    SortExpression="playerWeight" />
                <asp:BoundField DataField="playerPositions" HeaderText="Positions" 
                    SortExpression="playerPositions" />
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
        <asp:SqlDataSource ID="RosterGridDs" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            SelectCommand="SELECT playerName, playerNumber, playerGrade, playerHeight, playerWeight, playerPositions, rosterId, teamId, appId FROM Rosters WHERE (appId = @appId) AND (teamId = @teamId) ORDER BY playerName">
            <SelectParameters>
                <asp:SessionParameter Name="appId" SessionField="AppIdParam" />
                <asp:SessionParameter DefaultValue="" Name="teamId" 
                    SessionField="TeamIdParam" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:FormView ID="RosterForm" runat="server" 
            DataKeyNames="rosterId,teamId,appId" DataSourceID="RosterFormDs" 
            oniteminserted="RosterForm_ItemInserted" 
            oniteminserting="RosterForm_ItemInserting" 
            onitemupdating="RosterForm_ItemUpdating" 
            onitemdeleted="RosterForm_ItemDeleted" 
            onitemupdated="RosterForm_ItemUpdated" EnableModelValidation="True">
            <EditItemTemplate>
                <asp:HiddenField ID="RosterIdHidden" runat="server" 
                    Value='<%# Bind("rosterId") %>' />
                <table class="style3">
                    <tr>
                        <td class="style4">
                            <b>Player Name:</b></td>
                        <td>
                            <asp:TextBox ID="playerNameTextBox" runat="server" 
                                Text='<%# Bind("playerName") %>' MaxLength="75" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="playerNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Number:</b></td>
                        <td>
                            <asp:TextBox ID="playerNumberTextBox" runat="server" 
                                Text='<%# Bind("playerNumber") %>' MaxLength="5" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Grade:</b></td>
                        <td>
                            <asp:DropDownList ID="DropDownList1" runat="server" 
                                SelectedValue='<%# Bind("playerGrade") %>'>
                                <asp:ListItem Text="None" Value="">None</asp:ListItem>
                                <asp:ListItem>Freshman</asp:ListItem>
                                <asp:ListItem>Sophomore</asp:ListItem>
                                <asp:ListItem>Junior</asp:ListItem>
                                <asp:ListItem>Senior</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Height:</td>
                        <td>
                            <asp:TextBox ID="playerHeightTextBox" runat="server" 
                                Text='<%# Bind("playerHeight") %>' MaxLength="5" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Weight:</td>
                        <td>
                            <asp:TextBox ID="playerWeightTextBox" runat="server" 
                                Text='<%# Bind("playerWeight") %>' MaxLength="10" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Positions:</b></td>
                        <td>
                            <asp:TextBox ID="playerPositionsTextBox" runat="server" 
                                Text='<%# Bind("playerPositions") %>' MaxLength="25" />
                        </td>
                    </tr>
                </table>
                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                    CommandName="Update" Text="Update" />
                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>
            <InsertItemTemplate>
                <asp:HiddenField ID="TeamIdHidden" runat="server" 
                    Value='<%# Bind("teamId") %>' />
                <asp:HiddenField ID="AppIdHidden" runat="server" 
                    Value='<%# Eval("appId") %>' />
                <table class="style3">
                    <tr>
                        <td class="style4">
                            <b>Player Name:</b></td>
                        <td>
                            <asp:TextBox ID="playerNameTextBox" runat="server" 
                                Text='<%# Bind("playerName") %>' MaxLength="75" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="playerNameTextBox" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Number:</b></td>
                        <td>
                            <asp:TextBox ID="playerNumberTextBox" runat="server" 
                                Text='<%# Bind("playerNumber") %>' MaxLength="5" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Grade:</b></td>
                        <td>
                            <asp:DropDownList ID="DropDownList1" runat="server" 
                                SelectedValue='<%# Bind("playerGrade") %>'>
                                <asp:ListItem Text="None" Value="">None</asp:ListItem>
                                <asp:ListItem>Freshman</asp:ListItem>
                                <asp:ListItem>Sophomore</asp:ListItem>
                                <asp:ListItem>Junior</asp:ListItem>
                                <asp:ListItem>Senior</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Height:</td>
                        <td>
                            <asp:TextBox ID="playerHeightTextBox" runat="server" 
                                Text='<%# Bind("playerHeight") %>' MaxLength="5" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Weight:</td>
                        <td>
                            <asp:TextBox ID="playerWeightTextBox" runat="server" 
                                Text='<%# Bind("playerWeight") %>' MaxLength="10" />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Positions:</b></td>
                        <td>
                            <asp:TextBox ID="playerPositionsTextBox" runat="server" 
                                Text='<%# Bind("playerPositions") %>' MaxLength="25" />
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
                    Value='<%# Eval("rosterId") %>' />
                <br />
                <asp:Button ID="AddButton" runat="server" CommandName="New" Text="Add player" />
                &nbsp;<asp:Button ID="EditButton" runat="server" CommandName="Edit" 
                    Text="Edit player" />
                &nbsp;<asp:Button ID="DeleteButton" runat="server" CommandName="Delete" 
                    onclientclick="return confirm('Are you sure you want to delete this player?');" 
                    Text="Delete player" BackColor="Red" />
                <br />
                <asp:Button ID="UploadBtn" runat="server" onclick="UploadBtn_Click" 
                    Text="Upload Players" />
                &nbsp;<asp:Button ID="DeleteRosterBtn" runat="server" BackColor="Red" 
                    onclick="DeleteRosterBtn_Click" 
                    onclientclick="return confirm('Are you sure you want to delete ALL the players from this roster?');" 
                    oninit="DeleteRosterBtn_Init" Text="Delete Roster" />
            </ItemTemplate>
            <EmptyDataTemplate>
                <asp:Button ID="AddButton" runat="server" CommandName="New" Text="Add player" />
                <br />
                <asp:Button ID="UploadBtn" runat="server" onclick="UploadBtn_Click" 
                    Text="Upload Players" />
                &nbsp;<asp:Button ID="DeleteRosterBtn" runat="server" BackColor="Red" 
                    onclick="DeleteRosterBtn_Click" 
                    onclientclick="return confirm('Are you sure you want to delete ALL the players from this roster?');" 
                    oninit="DeleteRosterBtn_Init" Text="Delete Roster" />
            </EmptyDataTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="RosterFormDs" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            
            SelectCommand="SELECT rosterId, teamId, appId, playerName, playerNumber, playerGrade, playerHeight, playerWeight, playerPositions FROM Rosters WHERE (rosterId = @rosterId)" 
            
            InsertCommand="INSERT INTO Rosters(teamId, appId, playerName, playerNumber, playerGrade, playerHeight, playerWeight, playerPositions) VALUES (@teamId, @appId, @playerName, @playerNumber, @playerGrade, @playerHeight, @playerWeight, @playerPositions)" 
            
            UpdateCommand="UPDATE Rosters SET playerName = @playerName, playerNumber = @playerNumber, playerGrade = @playerGrade, playerHeight = @playerHeight, playerWeight = @playerWeight, playerPositions = @playerPositions WHERE (rosterId = @rosterId)" 
            DeleteCommand="DELETE FROM Rosters WHERE (rosterId = @rosterId)">
            <SelectParameters>
                <asp:ControlParameter ControlID="RosterGrid" Name="rosterId" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="rosterId" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="playerName" />
                <asp:Parameter Name="playerNumber" />
                <asp:Parameter Name="playerGrade" />
                <asp:Parameter Name="playerHeight" />
                <asp:Parameter Name="playerWeight" />
                <asp:Parameter Name="playerPositions" />
                <asp:Parameter Name="rosterId" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="teamId" />
                <asp:Parameter Name="appId" />
                <asp:Parameter Name="playerName" />
                <asp:Parameter Name="playerNumber" />
                <asp:Parameter Name="playerGrade" />
                <asp:Parameter Name="playerHeight" />
                <asp:Parameter Name="playerWeight" />
                <asp:Parameter Name="playerPositions" />
            </InsertParameters>
        </asp:SqlDataSource>
    </p>
</asp:Content>

