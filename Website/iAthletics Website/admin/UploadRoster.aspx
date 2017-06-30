<%@ Page Title="Team Roster" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="UploadRoster.aspx.cs" Inherits="admin_TeamSchedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style3
        {
            color: #FF0000;
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
    &nbsp;&gt;&gt;
        <asp:HyperLink ID="RosterLink" runat="server" 
            NavigateUrl="~/admin/TeamRoster.aspx">Roster</asp:HyperLink>
    </p>
    <h2>
        Upload Players for
        <asp:Label ID="AppLabel" runat="server"></asp:Label>
        <asp:Label ID="TeamLabel" runat="server"></asp:Label>
        <asp:Label ID="SportLabel" runat="server"></asp:Label>
    </h2>
    <asp:MultiView ID="WizardStep" runat="server" ActiveViewIndex="0">
        <asp:View ID="UploadAndInstructions" runat="server">
        <table>
            <tr>
                <td style="text-align: right">
                    CSV File:</td>
                <td>
        <asp:FileUpload ID="CsvFile" runat="server" />

                    <br />
                    <asp:Label ID="ErrMsgLbl" runat="server" Font-Bold="True" ForeColor="Red" 
                        Text="Error Message goes here" Visible="False"></asp:Label>

                </td>
            </tr>
            <tr>
                <td style="text-align: right">
                    File contains header row:</td>
                <td>
                    <asp:CheckBox ID="HasHeader" runat="server" Checked="True" /></td>
            </tr>
            <tr>
                <td style="text-align: right">
                    &nbsp;</td>
                <td>

        <asp:Button ID="UploadBtn" runat="server" Text="Upload" onclick="UploadBtn_Click" />&nbsp;
                    <asp:Button ID="CancelBtn" runat="server" PostBackUrl="~/admin/TeamRoster.aspx" 
            Text="Cancel" />
                </td>
            </tr>
        </table>


    <p style="font-weight: 700">
        Instructions:</p>
    <p>
        You can upload aditional players to a roster using a .CSV file. The file can 
        contain up to six columns, in the following order:</p>
    <ol>
        <li>Player Name <span class="style3">(required)</span></li>
        <li>Player Number </li>
        <li>Player Grade</li>
        <li>Player Height</li>
        <li>Player Weight</li>
        <li>Player Positions</li>
    </ol>
    <p>
        If this file contains a header row, check the <em>File contains header row</em> 
        check box above. If checked, the first row of the file will not be imported.</p>
    <p>
        Uploaded players are added to the existing list of players the team already has, 
        it does not delete the existing players.</p>
    </asp:View>
        <asp:View ID="ValidateData" runat="server">
            <asp:GridView ID="UploadedPlayersView" runat="server" AllowPaging="True" 
                AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
                BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" 
                Caption="Data read from CSV file" CaptionAlign="Top" CellPadding="4" 
                DataSourceID="RosterUploadTable" EnableModelValidation="True" ForeColor="Black" 
                GridLines="Vertical" PageSize="50">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
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
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                <RowStyle BackColor="#F7F7DE" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            </asp:GridView>
            <asp:SqlDataSource ID="RosterUploadTable" runat="server" 
                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                SelectCommand="SELECT [playerName], [playerNumber], [playerGrade], [playerHeight], [playerWeight], [playerPositions] FROM [RosterUpload] WHERE (([appId] = @appId) AND ([teamId] = @teamId))">
                <SelectParameters>
                    <asp:SessionParameter Name="appId" SessionField="AppIdParam" Type="Int32" />
                    <asp:SessionParameter Name="teamId" SessionField="TeamIdParam" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:Button ID="YesBtn" runat="server" Text="Yes, add players to roster" 
                onclick="YesBtn_Click" />
            &nbsp;<asp:Button ID="NoBtn" runat="server" onclick="Button2_Click" 
                Text="No, try again" />
            &nbsp;<asp:Button ID="CancelBtn1" runat="server" 
                PostBackUrl="~/admin/TeamRoster.aspx" Text="Cancel" />
            <br />
        </asp:View>
    </asp:MultiView>

</asp:Content>

