<%@ Page Title="Team Roster" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="UploadSchedule.aspx.cs" Inherits="admin_TeamSchedule" %>

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
        <asp:HyperLink ID="ScheduleLink" runat="server" 
            NavigateUrl="~/admin/TeamSchedule.aspx">Schedule</asp:HyperLink>
    </p>
    <h2>
        Upload Events for
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
        You can upload events to a schedule using a .CSV file. The file can contain up 
        to four columns, in the following order:</p>
    <ol>
        <li>Event Name <span class="style3">(required)</span></li>
        <li>Event Date and Time <span class="style3">(required)</span><span>. The recomended 
            format is <em>mm/dd/yyyy hh:mm AM/PM</em> for example <strong>09/26/2010 6:30 PM</strong></span></li>
        <li>Venue ID Number <span class="style3">(required).
            <asp:LinkButton ID="DownloadVenus" runat="server" onclick="DownloadVenus_Click">Click here</asp:LinkButton>
            &nbsp;</span><span>to download your venue list.</span></li>
        <li>Note</li>
    </ol>
    <p>
        If this file contains a header row, check the <em>File contains header row</em> 
        check box above. If checked, the first row of the file will not be imported.</p>
    <p>
        Uploaded events are added to the existing team schedule. It does not delete or 
        replace the existing events.</p>
    </asp:View>
        <asp:View ID="ValidateData" runat="server">
            <asp:GridView ID="UploadedPlayersView" runat="server" AllowPaging="True" 
                AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
                BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" 
                Caption="Data read from CSV file" CaptionAlign="Top" CellPadding="4" 
                DataSourceID="ScheduleUploadTable" EnableModelValidation="True" ForeColor="Black" 
                GridLines="Vertical" PageSize="50">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                    <asp:BoundField DataField="scheduleName" HeaderText="Event Name" 
                        SortExpression="scheduleName" />
                    <asp:BoundField DataField="scheduleDateTime" HeaderText="Date and Time" 
                        SortExpression="scheduleDateTime" />
                    <asp:BoundField DataField="venuId" HeaderText="venu ID" 
                        SortExpression="venuId" />
                    <asp:BoundField DataField="note" HeaderText="Note" SortExpression="note" />
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                <RowStyle BackColor="#F7F7DE" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            </asp:GridView>
            <asp:SqlDataSource ID="ScheduleUploadTable" runat="server" 
                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                
                SelectCommand="SELECT [scheduleName], [scheduleDateTime], [venuId], [note] FROM [ScheduleUpload] WHERE (([appId] = @appId) AND ([teamId] = @teamId))">
                <SelectParameters>
                    <asp:SessionParameter Name="appId" SessionField="AppIdParam" Type="Int32" />
                    <asp:SessionParameter Name="teamId" SessionField="TeamIdParam" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:Button ID="YesBtn" runat="server" Text="Yes, add events to schedule" 
                onclick="YesBtn_Click" />
            &nbsp;<asp:Button ID="NoBtn" runat="server" onclick="Button2_Click" 
                Text="No, try again" />
            &nbsp;<asp:Button ID="CancelBtn1" runat="server" 
                PostBackUrl="~/admin/TeamRoster.aspx" Text="Cancel" />
            <br />
        </asp:View>
    </asp:MultiView>

</asp:Content>

