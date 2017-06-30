<%@ Page Title="Team Schedule" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="TeamSchedule.aspx.cs" Inherits="admin_TeamSchedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style4
        {
            text-align: right;
            font-weight: 700;
        }
        .style5
        {
            text-align: right;
            font-weight: 700;
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
    <h2>
        Schedule for
        <asp:Label ID="AppLabel" runat="server"></asp:Label>
        <asp:Label ID="TeamLabel" runat="server"></asp:Label>
        <asp:Label ID="SportLabel" runat="server"></asp:Label>
    </h2>
    <p>
        <asp:GridView ID="ScheduleGrid" runat="server" AllowPaging="True" 
            AllowSorting="True" AutoGenerateColumns="False" BackColor="White" 
            BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
            DataKeyNames="scheduleId,appId,teamId" DataSourceID="ScheduleGridDs" 
            ForeColor="Black" GridLines="Vertical" 
            onselectedindexchanged="ScheduleGrid_SelectedIndexChanged" PageSize="50" 
            EnableModelValidation="True">
            <RowStyle BackColor="#F7F7DE" />
            <Columns>
                <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
                <asp:BoundField DataField="scheduleName" HeaderText="Event Description" 
                    SortExpression="scheduleName" />
                <asp:BoundField DataField="scheduleDateTime" HeaderText="Date andTime" 
                    SortExpression="scheduleDateTime" />
                <asp:BoundField DataField="venuName" HeaderText="Location" 
                    SortExpression="venuName" />
                <asp:BoundField DataField="note" HeaderText="note" SortExpression="note" />
                <asp:CheckBoxField DataField="isAway" HeaderText="isAway" 
                    SortExpression="isAway" />
                <asp:CheckBoxField DataField="isConferenceGame" HeaderText="Conference Event" 
                    SortExpression="isConferenceGame" />
                <asp:BoundField DataField="result" HeaderText="Result" 
                    SortExpression="result" />
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <AlternatingRowStyle BackColor="White" />
        </asp:GridView>
        <asp:SqlDataSource ID="ScheduleGridDs" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            
            
            
            SelectCommand="SELECT Schedules.scheduleId, Schedules.appId, Schedules.teamId, Schedules.scheduleDateTime, Schedules.isAway, Schedules.isConferenceGame, Schedules.note, Venus.venuName, Schedules.result, Schedules.scheduleName FROM Schedules INNER JOIN Venus ON Schedules.venuId = Venus.venuId WHERE (Schedules.appId = @appId) AND (Schedules.teamId = @teamId)">
            <SelectParameters>
                <asp:SessionParameter Name="appId" SessionField="AppIdParam" />
                <asp:SessionParameter Name="teamId" SessionField="TeamIdParam" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:FormView ID="ScheduleForm" runat="server" 
            DataKeyNames="ScheduleId,appId,teamId" DataSourceID="ScheduleFormDs" 
            oniteminserted="ScheduleForm_ItemInserted" 
            oniteminserting="ScheduleForm_ItemInserting" 
            onitemupdated="ScheduleForm_ItemUpdated" 
            onitemupdating="ScheduleForm_ItemUpdating" 
            onitemdeleted="ScheduleForm_ItemDeleted" EnableModelValidation="True">
            <EditItemTemplate>
                <asp:HiddenField ID="ScheduleIdHidden" runat="server" 
                    Value='<%# Bind("scheduleId") %>' />
&nbsp;<asp:HiddenField ID="ScheduleHidden" runat="server" 
                    Value='<%# Eval("scheduleDateTime") %>' />
                <table>
                    <tr>
                        <td class="style4">
                            Event Description:</td>
                        <td>
                            <asp:TextBox ID="EventDescText" runat="server" MaxLength="50" 
                                Text='<%# Bind("scheduleName") %>' Width="292px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="EventDescText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Event date and time:</b></td>
                        <td>
                            <asp:DropDownList ID="MonthList" runat="server" 
                                onprerender="MonthList_PreRender">
                                <asp:ListItem Value="1">January</asp:ListItem>
                                <asp:ListItem Value="2">Febuary</asp:ListItem>
                                <asp:ListItem Value="3">March</asp:ListItem>
                                <asp:ListItem Value="4">April</asp:ListItem>
                                <asp:ListItem Value="5">May</asp:ListItem>
                                <asp:ListItem Value="6">June</asp:ListItem>
                                <asp:ListItem Value="7">July</asp:ListItem>
                                <asp:ListItem Value="8">August</asp:ListItem>
                                <asp:ListItem Value="9">September</asp:ListItem>
                                <asp:ListItem Value="10">October</asp:ListItem>
                                <asp:ListItem Value="11">November</asp:ListItem>
                                <asp:ListItem Value="12">December</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;<asp:DropDownList ID="DayList" runat="server">
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>11</asp:ListItem>
                                <asp:ListItem>12</asp:ListItem>
                                <asp:ListItem>13</asp:ListItem>
                                <asp:ListItem>14</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
                                <asp:ListItem>16</asp:ListItem>
                                <asp:ListItem>17</asp:ListItem>
                                <asp:ListItem>18</asp:ListItem>
                                <asp:ListItem>19</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>21</asp:ListItem>
                                <asp:ListItem>22</asp:ListItem>
                                <asp:ListItem>23</asp:ListItem>
                                <asp:ListItem>24</asp:ListItem>
                                <asp:ListItem>25</asp:ListItem>
                                <asp:ListItem>26</asp:ListItem>
                                <asp:ListItem>27</asp:ListItem>
                                <asp:ListItem>28</asp:ListItem>
                                <asp:ListItem>29</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>31</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;<asp:DropDownList ID="YearList" runat="server">
                                <asp:ListItem>2010</asp:ListItem>
                                <asp:ListItem>2011</asp:ListItem>
                                <asp:ListItem>2012</asp:ListItem>
                                <asp:ListItem>2013</asp:ListItem>
                                <asp:ListItem>2014</asp:ListItem>
                                <asp:ListItem>2015</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;at
                            <asp:DropDownList ID="HourList" runat="server">
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>11</asp:ListItem>
                                <asp:ListItem>12</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;<asp:DropDownList ID="MinuteList" runat="server">
                                <asp:ListItem Value="00">00</asp:ListItem>
                                <asp:ListItem Value="05">05</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>25</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>35</asp:ListItem>
                                <asp:ListItem>40</asp:ListItem>
                                <asp:ListItem>45</asp:ListItem>
                                <asp:ListItem>50</asp:ListItem>
                                <asp:ListItem>55</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;<asp:DropDownList ID="AmPmList" runat="server">
                                <asp:ListItem>AM</asp:ListItem>
                                <asp:ListItem>PM</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Venue:</b></td>
                        <td>
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="VenuNamesDs" 
                                DataTextField="vName" DataValueField="venuId" 
                                SelectedValue='<%# Bind("venuId") %>' Width="272px">
                            </asp:DropDownList>&nbsp;<asp:Button ID="CreateNewVenuButton" runat="server" 
                                CausesValidation="False" onclick="CreateNewVenuButton_Click" 
                                Text="Create new venu" />
                            &nbsp;<asp:SqlDataSource ID="VenuNamesDs" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                                
                                SelectCommand="SELECT venuName + ', ' + venuCity + ', ' + venuState AS vName, venuId FROM Venus WHERE appId = @appId ORDER BY vName">
                                <SelectParameters>
                                    <asp:SessionParameter Name="appId" SessionField="AppIdParam" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Away Game:</b></td>
                        <td>
                            <asp:CheckBox ID="isAwayCheckBox" runat="server" 
                                Checked='<%# Bind("isAway") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Conference Game:</b></td>
                        <td>
                            <asp:CheckBox ID="isConferenceGameCheckBox" runat="server" 
                                Checked='<%# Bind("isConferenceGame") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Notes:</td>
                        <td>
                            <asp:TextBox ID="NoteText" runat="server" MaxLength="50" 
                                Text='<%# Bind("note") %>' Width="300px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Result:</td>
                        <td>
                            <asp:TextBox ID="ResultText" runat="server" Text='<%# Bind("result") %>' 
                                Width="279px"></asp:TextBox>
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
                        <td class="style4">
                            Event Description:</td>
                        <td>
                            <asp:TextBox ID="EventDescText" runat="server" 
                                Text='<%# Bind("scheduleName") %>' Width="292px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="EventDescText" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Event date and time:</b></td>
                        <td>
                            <asp:DropDownList ID="MonthList" runat="server">
                                <asp:ListItem Value="1">January</asp:ListItem>
                                <asp:ListItem Value="2">Febuary</asp:ListItem>
                                <asp:ListItem Value="3">March</asp:ListItem>
                                <asp:ListItem Value="4">April</asp:ListItem>
                                <asp:ListItem Value="5">May</asp:ListItem>
                                <asp:ListItem Value="6">June</asp:ListItem>
                                <asp:ListItem Value="7">July</asp:ListItem>
                                <asp:ListItem Value="8">August</asp:ListItem>
                                <asp:ListItem Value="9">September</asp:ListItem>
                                <asp:ListItem Value="10">October</asp:ListItem>
                                <asp:ListItem Value="11">November</asp:ListItem>
                                <asp:ListItem Value="12">December</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;<asp:DropDownList ID="DayList" runat="server">
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>11</asp:ListItem>
                                <asp:ListItem>12</asp:ListItem>
                                <asp:ListItem>13</asp:ListItem>
                                <asp:ListItem>14</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
                                <asp:ListItem>16</asp:ListItem>
                                <asp:ListItem>17</asp:ListItem>
                                <asp:ListItem>18</asp:ListItem>
                                <asp:ListItem>19</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>21</asp:ListItem>
                                <asp:ListItem>22</asp:ListItem>
                                <asp:ListItem>23</asp:ListItem>
                                <asp:ListItem>24</asp:ListItem>
                                <asp:ListItem>25</asp:ListItem>
                                <asp:ListItem>26</asp:ListItem>
                                <asp:ListItem>27</asp:ListItem>
                                <asp:ListItem>28</asp:ListItem>
                                <asp:ListItem>29</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>31</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;<asp:DropDownList ID="YearList" runat="server">
                                <asp:ListItem>2010</asp:ListItem>
                                <asp:ListItem>2011</asp:ListItem>
                                <asp:ListItem>2012</asp:ListItem>
                                <asp:ListItem>2013</asp:ListItem>
                                <asp:ListItem>2014</asp:ListItem>
                                <asp:ListItem>2015</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;at
                            <asp:DropDownList ID="HourList" runat="server">
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>11</asp:ListItem>
                                <asp:ListItem>12</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;<asp:DropDownList ID="MinuteList" runat="server">
                                <asp:ListItem Value="00">00</asp:ListItem>
                                <asp:ListItem Value="05">05</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>25</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>35</asp:ListItem>
                                <asp:ListItem>40</asp:ListItem>
                                <asp:ListItem>45</asp:ListItem>
                                <asp:ListItem>50</asp:ListItem>
                                <asp:ListItem>55</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;<asp:DropDownList ID="AmPmList" runat="server">
                                <asp:ListItem>AM</asp:ListItem>
                                <asp:ListItem>PM</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="style4" valign="top">
                            <b>Venue:</b></td>
                        <td>
                            <asp:DropDownList ID="DropDownList1" runat="server" 
                                DataSourceID="VenuNamesDs" DataTextField="vName" 
                                DataValueField="venuId" SelectedValue='<%# Bind("venuId") %>' 
                                Width="272px">
                            </asp:DropDownList>&nbsp;<asp:Button ID="CreateNewVenuButton" runat="server" 
                                onclick="CreateNewVenuButton_Click" Text="Create new venu" 
                                CausesValidation="False" />
&nbsp;<asp:SqlDataSource ID="VenuNamesDs" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                                
                                
                                SelectCommand="SELECT venuName + ', ' + venuCity + ', ' + venuState AS vName, venuId FROM Venus WHERE appId = @appId ORDER BY vName">
                                <SelectParameters>
                                    <asp:SessionParameter Name="appId" SessionField="AppIdParam" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Away Game:</b></td>
                        <td>
                            <asp:CheckBox ID="isAwayCheckBox" runat="server" 
                                Checked='<%# Bind("isAway") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td class="style4">
                            <b>Conference Game:</b></td>
                            <td><asp:CheckBox ID="isConferenceGameCheckBox" runat="server" 
                    Checked='<%# Bind("isConferenceGame") %>' /></td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Notes:</td>
                        <td>
                            <asp:TextBox ID="NoteText" runat="server" MaxLength="50" 
                                Text='<%# Bind("note") %>' Width="300px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="style5">
                            Result:</td>
                        <td>
                            <asp:TextBox ID="ResultText" runat="server" Width="279px" 
                                Text='<%# Bind("result") %>' MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                    CommandName="Insert" Text="Insert" />
&nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" 
                    CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
            <ItemTemplate>
                <asp:HiddenField ID="HiddenField1" runat="server" 
                    Value='<%# Eval("scheduleId") %>' />
                <asp:Button ID="AddButton" runat="server" CommandName="New"  
                    Text="Add event" />
                &nbsp;<asp:Button ID="EditButton" runat="server" CommandName="Edit"  
                    Text="Edit event" />
                &nbsp;<asp:Button ID="DeleteButton" runat="server" CommandName="Delete" 
                    onclientclick="return confirm('Are you sure you want to delete this event?');" 
                    Text="Delete event" BackColor="Red" />
                <br />
                <asp:Button ID="UploadBtn" runat="server" 
                    PostBackUrl="~/admin/UploadSchedule.aspx" Text="Upload Events" />
                &nbsp;<asp:Button ID="DeleteScheduleBtn" runat="server" BackColor="Red" 
                    onclick="DeleteEventsBtn_Click" 
                    onclientclick="return confirm('Are you sure you want to delete ALL events from the schedule?');" 
                    oninit="DeleteEventsBtn_Init" Text="Delete Schedule" />
            </ItemTemplate>
            <EmptyDataTemplate>
                <asp:Button ID="AddEventButton" runat="server"  
                    Text="Add event" CommandName="New" />
                <br />
                <asp:Button ID="UploadBtn" runat="server"  
                    PostBackUrl="~/admin/UploadSchedule.aspx" Text="Upload Events" />
                &nbsp;<asp:Button ID="DeleteScheduleBtn" runat="server" BackColor="Red" 
                    onclick="DeleteEventsBtn_Click" oninit="DeleteEventsBtn_Init" 
                    Text="Delete Schedule" 
                    onclientclick="return confirm('Are you sure you want to delete ALL events from the schedule?');" />
            </EmptyDataTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="ScheduleFormDs" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
            
            SelectCommand="SELECT scheduleId, appId, teamId, scheduleDateTime, isAway, isConferenceGame, note, venuId, scheduleName, [result] FROM Schedules WHERE (appId = @appId) AND (teamId = @teamId) AND (scheduleId = @scheduleId)" 
            
            InsertCommand="INSERT INTO Schedules(appId, teamId, scheduleDateTime, isAway, isConferenceGame, note, venuId, [result], scheduleName) VALUES (@appId, @teamId, @scheduleDateTime, @isAway, @isConferenceGame, @note, @venuId, @result, @scheduleName)" 
            
            UpdateCommand="UPDATE Schedules SET scheduleDateTime = @scheduleDateTime, isAway = @isAway, isConferenceGame = @isConferenceGame, note = @note, venuId = @venuId, [result] = @result, scheduleName = @scheduleName WHERE (scheduleId = @scheduleId)" 
            DeleteCommand="DELETE FROM Schedules WHERE (scheduleId = @scheduleId)">
            <SelectParameters>
                <asp:SessionParameter Name="appId" SessionField="AppIdParam" />
                <asp:SessionParameter Name="teamId" SessionField="TeamIdParam" />
                <asp:ControlParameter ControlID="ScheduleGrid" Name="scheduleId" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="scheduleId" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="scheduleDateTime" />
                <asp:Parameter Name="isAway" />
                <asp:Parameter Name="isConferenceGame" />
                <asp:Parameter Name="note" />
                <asp:Parameter Name="venuId" />
                <asp:Parameter Name="result" />
                <asp:Parameter Name="scheduleName" />
                <asp:Parameter Name="scheduleId" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="appId" />
                <asp:Parameter Name="teamId" />
                <asp:Parameter Name="scheduleDateTime" />
                <asp:Parameter Name="isAway" />
                <asp:Parameter Name="isConferenceGame" />
                <asp:Parameter Name="note" />
                <asp:Parameter Name="venuId" />
                <asp:Parameter Name="result" />
                <asp:Parameter Name="scheduleName" />
            </InsertParameters>
        </asp:SqlDataSource>
    </p>
</asp:Content>

