<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Teams.aspx.cs" Inherits="admin_Teams" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style5
        {
            text-align: right;
            font-weight: bold;
            width: 127px;
        }
        .style4
        {
            text-align: right;
        }
        .style6
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
    </p>    <h2>
        Administer Teams for
        <asp:Label ID="AppLabel" runat="server" Text="!application name!"></asp:Label>
    </h2>
    <p>
        <asp:GridView ID="TeamGrid" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
            BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
            DataKeyNames="teamId,appId" DataSourceID="TeamGridDS" ForeColor="Black" 
            GridLines="Vertical" 
            onselectedindexchanged="TeamGrid_SelectedIndexChanged" PageSize="25" 
            EnableModelValidation="True">
            <RowStyle BackColor="#F7F7DE" />
            <Columns>
                <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
                <asp:BoundField DataField="teamName" HeaderText="teamName" 
                    SortExpression="teamName" />
                <asp:BoundField DataField="sportName" HeaderText="sportName" 
                    SortExpression="sportName" />
                <asp:BoundField DataField="SeasonName" HeaderText="SeasonName" 
                    SortExpression="SeasonName" />
                <asp:BoundField DataField="teamOverallResults" HeaderText="teamOverallResults" 
                    SortExpression="teamOverallResults" />
                <asp:ImageField DataImageUrlField="teamId" 
                    DataImageUrlFormatString="~/images/GetTeamPhoto.ashx?teamId={0}" 
                    HeaderText="Team Photo" ItemStyle-Height="50px" ItemStyle-Width="100px">
                </asp:ImageField>
                <asp:CheckBoxField DataField="teamActive" HeaderText="teamActive" 
                    SortExpression="teamActive" />
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
        <asp:SqlDataSource ID="TeamGridDS" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            
            
            
            
            SelectCommand="SELECT Teams.teamId, Teams.appId, Teams.sportId, Sports.sportName, Teams.teamActive, Teams.teamName, Seasons.SeasonName, Teams.teamPhotoFileName, Teams.teamOverallResults FROM Teams INNER JOIN Sports ON Teams.sportId = Sports.sportId INNER JOIN Seasons ON Teams.seasonId = Seasons.seasonId WHERE (Teams.appId = @appId)" 
            onselecting="TeamGridDS_Selecting">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="0" Name="appId" SessionField="AppIdParam" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:FormView ID="TeamForm" runat="server" DataKeyNames="teamId,appId" 
            DataSourceID="TeamFormDS" oniteminserted="TeamForm_ItemInserted" 
            oniteminserting="TeamForm_ItemInserting" 
            onitemupdated="TeamForm_ItemUpdated" Width="595px" 
            EnableModelValidation="True">
            <EditItemTemplate>
                <asp:HiddenField ID="HiddenField1" runat="server" 
                    Value='<%# Bind("teamId") %>' />
                <asp:HiddenField ID="HiddenField2" runat="server" 
                    Value='<%# Bind("appId") %>' />
                <asp:HiddenField ID="HiddenField3" runat="server" 
                    Value='<%# Bind("sportId") %>' />
                <br />
                <table class="style3">
                    <tr>
                        <td class="style4">
                            <b>Sport:</b></td>
                        <td>
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("sportName") %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Team Name:</td>
                        <td>
                            <asp:TextBox ID="teamNameField" runat="server" MaxLength="50" 
                                Text='<%# Bind("teamName") %>' Height="22px" Width="343px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="teamNameField" ErrorMessage="RequiredFieldValidator"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Season:</td>
                        <td>
                            <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="SeasonsDS" 
                                DataTextField="SeasonName" DataValueField="seasonId" 
                                SelectedValue='<%# Bind("seasonId") %>'>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SeasonsDS" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                                SelectCommand="SELECT [seasonId], [SeasonName] FROM [Seasons] ORDER BY [SeasonName]">
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="style6">
                            Overall results:</td>
                        <td>
                            <asp:TextBox ID="OverallResultsText" runat="server" MaxLength="50" 
                                Text='<%# Bind("teamOverallResults") %>' Height="21px" Width="344px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Active:</b></td>
                        <td>
                            <asp:CheckBox ID="CheckBox1" runat="server" 
                                Checked='<%# Bind("teamActive") %>' />
                        </td>
                    </tr>
                </table>
                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                    CommandName="Update" Text="Update" />
                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>
            <InsertItemTemplate>
                <table>
                    <tr>
                        <td class="style5" valign="top">
                            Team Name:</td>
                        <td>
                            <asp:TextBox ID="teamNameEdit" runat="server" MaxLength="50" 
                                Text='<%# Bind("teamName") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="teamNameEdit" ErrorMessage="Required"></asp:RequiredFieldValidator>
                            <br />
                            Hint: A team name my be something like Varsity or Junior Varsity. It could also 
                            be Men&#39;s or Women&#39;s for teams that do not have a V/JV squad.</td>
                    </tr>
                    <tr>
                        <td class="style5" valign="top">
                            <b>Sport:</b></td>
                        <td>
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="TypeTypeDS" 
                                DataTextField="sportName" DataValueField="sportId" 
                                SelectedValue='<%# Bind("sportId") %>'>
                            </asp:DropDownList>
                            <br />
                            Hint: the team will display to the user as Team Name Sport in the mobile 
                            application.</td>
                    </tr>
                    <tr>
                        <td class="style5" valign="top">
                            <b>Season</b>:</td>
                        <td>
                            <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="SeasonsDS" 
                                DataTextField="SeasonName" DataValueField="seasonId" 
                                SelectedValue='<%# Bind("seasonId") %>'>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SeasonsDS" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                                SelectCommand="SELECT [seasonId], [SeasonName] FROM [Seasons] ORDER BY [SeasonName]">
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="style5" valign="top">
                            Overall results:</td>
                        <td>
                            <asp:TextBox ID="OverallResultsText" runat="server" MaxLength="50" 
                                Text='<%# Bind("teamOverallResults") %>' Width="300px"></asp:TextBox>
                            <br />
                            Hint: This field is displayed underneath Schedule/Results on the team 
                            information page in the web application.</td>
                    </tr>
                    <tr>
                        <td class="style5">
                            <b>Active:</b></td>
                        <td>
                            <asp:CheckBox ID="CheckBox2" runat="server" 
                                Checked='<%# Bind("teamActive") %>' />
                        </td>
                    </tr>
                </table>
&nbsp;<asp:SqlDataSource ID="TypeTypeDS" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                    InsertCommand="INSERT INTO Teams(appId, sportId) VALUES (@appId, @sportId)" 
                    SelectCommand="SELECT [sportId], [sportName] FROM [Sports] ORDER BY [sportName]">
                    <InsertParameters>
                        <asp:Parameter Name="appId" />
                        <asp:Parameter Name="sportId" />
                    </InsertParameters>
                </asp:SqlDataSource>
                <br />
                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                    CommandName="Insert" Text="Insert" />
                &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
            <ItemTemplate>
                <asp:Button ID="RosterButton" runat="server" Text="Edit/View Roster" 
                    onclick="RosterButton_Click" />
                &nbsp;<asp:Button ID="ScheduleButton" runat="server" Text="Edit/View Schedule" 
                    onclick="ScheduleButton_Click" />
                &nbsp;<asp:Button ID="EditPhoto" runat="server" onclick="EditPhoto_Click" 
                    Text="Edit team photo" />
                &nbsp;<asp:Button ID="EditLinksButton" runat="server" 
                    onclick="EditLinksButton_Click" Text="Edit team links" />
                <br />
                <asp:Button ID="AddTeamButton" runat="server" onclick="AddButton_Click" 
                    Text="Add Team" />
                &nbsp;<asp:Button ID="EditButton" runat="server" onclick="EditButton_Click" 
                    Text="Edit Team" />
            </ItemTemplate>
            <EmptyDataTemplate>
                <asp:Button ID="AddButton" runat="server" onclick="AddButton_Click" 
                    Text="Add Team" />
            </EmptyDataTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="TeamFormDS" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            InsertCommand="INSERT INTO Teams(appId, sportId, teamActive, seasonId, teamName, teamOverallResults) VALUES (@appId, @sportId, @teamActive, @seasonId, @teamName, @teamOverallResults)" 
            SelectCommand="SELECT Teams.teamId, Teams.appId, Teams.sportId, Teams.teamActive, Sports.sportName, Teams.teamName, Teams.seasonId, Seasons.SeasonName, Teams.teamOverallResults FROM Teams INNER JOIN Sports ON Teams.sportId = Sports.sportId INNER JOIN Seasons ON Teams.seasonId = Seasons.seasonId WHERE (Teams.teamId = @teamId) AND (Teams.appId = @appId)" 
            
            
            UpdateCommand="UPDATE Teams SET teamActive = @teamActive, seasonId = @seasonId, teamName = @teamName, teamOverallResults = @teamOverallResults WHERE (teamId = @teamId) AND (appId = @appId) AND (sportId = @sportId)">
            <SelectParameters>
                <asp:ControlParameter ControlID="TeamGrid" Name="teamId" 
                    PropertyName="SelectedValue" />
                <asp:SessionParameter DefaultValue="" Name="appId" SessionField="AppIdParam" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="teamActive" />
                <asp:Parameter Name="seasonId" />
                <asp:Parameter Name="teamName" />
                <asp:Parameter Name="teamOverallResults" />
                <asp:Parameter Name="teamId" />
                <asp:Parameter Name="appId" />
                <asp:Parameter Name="sportId" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="appId" />
                <asp:Parameter Name="sportId" />
                <asp:Parameter Name="teamActive" />
                <asp:Parameter Name="seasonId" />
                <asp:Parameter Name="teamName" />
                <asp:Parameter Name="teamOverallResults" />
            </InsertParameters>
        </asp:SqlDataSource>
    </p>
</asp:Content>

