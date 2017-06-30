<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Schools.aspx.cs" Inherits="admin_Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2>
    Schools Administation</h2>
<p>
    <asp:GridView ID="SchoolGrid" runat="server" AutoGenerateColumns="False" 
        BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" 
        CellPadding="4" DataKeyNames="schoolId" DataSourceID="SchoolGridView" 
        ForeColor="Black" GridLines="Vertical" AllowPaging="True" 
        AllowSorting="True" 
        onselectedindexchanged="SchoolGrid_SelectedIndexChanged">
        <RowStyle BackColor="#F7F7DE" />
        <Columns>
            <asp:CommandField ButtonType="Button" ShowSelectButton="True" />
            <asp:BoundField DataField="School Name" HeaderText="School Name" 
                SortExpression="School Name" />
            <asp:BoundField DataField="City" HeaderText="City" SortExpression="City" />
            <asp:BoundField DataField="State" HeaderText="State" SortExpression="State" />
        </Columns>
        <FooterStyle BackColor="#CCCC99" />
        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
        <AlternatingRowStyle BackColor="White" />
    </asp:GridView>
    <asp:SqlDataSource ID="SchoolGridView" runat="server" 
        ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
        SelectCommand="SELECT schoolId, schoolName as [School Name], schoolCity as City, schoolState as [State] FROM Schools ORDER BY schoolName">
    </asp:SqlDataSource>
    </p>
    <p>
        <asp:FormView ID="SchoolForm" runat="server" DataKeyNames="schoolId" 
            DataSourceID="SchoolFormView" oniteminserted="SchoolForm_ItemInserted">
            <EditItemTemplate>
                <table class="style4">
                    <tr>
                        <td style="text-align: right">
                            <b>School
                            <asp:HiddenField ID="HiddenField1" runat="server" 
                                Value='<%# Eval("schoolId") %>' />
                            Name:</b></td>
                        <td>
                            <asp:TextBox ID="schoolNameTextBox" runat="server" 
                                Text='<%# Bind("schoolName") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                ControlToValidate="schoolNameTextBox" ErrorMessage="School Name is Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Street Address:</b></td>
                        <td>
                            <asp:TextBox ID="schoolAddressTextBox" runat="server" 
                                Text='<%# Bind("schoolAddress") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                ControlToValidate="schoolAddressTextBox" ErrorMessage="Address is Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>City:</b></td>
                        <td>
                            <asp:TextBox ID="schoolCityTextBox" runat="server" 
                                Text='<%# Bind("schoolCity") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                ControlToValidate="schoolCityTextBox" ErrorMessage="City is required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>State:</b></td>
                        <td>
                            <asp:DropDownList ID="StateDropDown" runat="server" 
                                SelectedValue='<%# Bind("schoolState") %>'>
                                <asp:ListItem>NC</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Zip:</b></td>
                        <td>
                            <asp:TextBox ID="schoolZipTextBox" runat="server" 
                                Text='<%# Bind("schoolZip") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                                ControlToValidate="schoolZipTextBox" ErrorMessage="Zip is required"></asp:RequiredFieldValidator>
                            &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator1" 
                                runat="server" ControlToValidate="schoolZipTextBox" 
                                ErrorMessage="Enter a vlaid zip format" ValidationExpression="\d{5}(-\d{4})?"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Longitude:</b></td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Latitude:</b></td>
                    </tr>
                </table>
                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                    CommandName="Update" Text="Update" />
                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>
            <InsertItemTemplate>
                <table class="style4">
                    <tr>
                        <td style="text-align: right">
                            <b>School Name:</b></td>
                        <td>
                            <asp:TextBox ID="schoolNameTextBox" runat="server" MaxLength="50" 
                                Text='<%# Bind("schoolName") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="schoolNameTextBox" ErrorMessage="School Name is Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Street Address:</b></td>
                        <td>
                            <asp:TextBox ID="schoolAddressTextBox" runat="server" MaxLength="50" 
                                Text='<%# Bind("schoolAddress") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="schoolAddressTextBox" ErrorMessage="Address is required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>City:</b></td>
                        <td>
                            <asp:TextBox ID="schoolCityTextBox" runat="server" MaxLength="50" 
                                Text='<%# Bind("schoolCity") %>' />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                ControlToValidate="schoolCityTextBox" ErrorMessage="City is Required"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>State:</b></td>
                        <td>
                            <asp:DropDownList ID="DropDownState" runat="server" 
                                SelectedValue='<%# Bind("schoolState") %>'>
                                <asp:ListItem>NC</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Zip:</b></td>
                        <td>
                            <asp:TextBox ID="schoolZipTextBox" runat="server" MaxLength="10" 
                                Text='<%# Bind("schoolZip") %>' />
                            <asp:RequiredFieldValidator ID="ZipRequiredValidator" runat="server" 
                                ControlToValidate="schoolZipTextBox" ErrorMessage="Zip is required"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="ZipExpressionValidator" runat="server" 
                                ControlToValidate="schoolZipTextBox" ErrorMessage="Enter a valid zip format" 
                                ValidationExpression="\d{5}(-\d{4})?"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Longitude:</b></td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Latitude:</b></td>
                    </tr>
                </table>
                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                    CommandName="Insert" Text="Insert" />
&nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" 
                    CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
            <ItemTemplate>
                <asp:Button ID="AddSchoolButton" runat="server" onclick="AddButton_Click" 
                    Text="Add new school..." />
                &nbsp;<asp:Button ID="EditButton" runat="server" onclick="EditButton_Click" 
                    Text="Edit..." />
                &nbsp;<table class="style3">
                    <tr>
                        <td style="text-align: right">
                            <b>School Name:</b></td>
                        <td>
                            <asp:Label ID="schoolNameLabel" runat="server" 
                                Text='<%# Bind("schoolName") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Address:</b></td>
                        <td>
                            <asp:Label ID="schoolAddressLabel" runat="server" 
                                Text='<%# Bind("schoolAddress") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>City:</b></td>
                        <td>
                            <asp:Label ID="schoolCityLabel" runat="server" 
                                Text='<%# Bind("schoolCity") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>State</b></td>
                        <td>
                            <asp:Label ID="schoolStateLabel" runat="server" 
                                Text='<%# Bind("schoolState") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Zip:</b></td>
                        <td>
                            <asp:Label ID="schoolZipLabel" runat="server" Text='<%# Bind("schoolZip") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Lattitude:</b></td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <b>Longitude:</b></td>
                        <td>
                            &nbsp;</td>
                    </tr>
                </table>
                <br />
            </ItemTemplate>
            <EmptyDataTemplate>
                <asp:Button ID="AddButton" runat="server" onclick="AddButton_Click" 
                    Text="Add new school..." />
            </EmptyDataTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="SchoolFormView" runat="server" 
            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" SelectCommand="SELECT [schoolId], [schoolName], 
[schoolAddress], 
[schoolCity], 
[schoolState], 
[schoolZip]
 FROM [Schools] WHERE ([schoolId] = @schoolId)" 
            
            InsertCommand="INSERT INTO Schools(schoolName, schoolAddress, schoolCity, schoolState, schoolZip) VALUES (@schoolName, @schoolAddress, @schoolCity, @schoolState, @schoolZip)" 
            
            UpdateCommand="UPDATE Schools SET schoolName = @schoolName, schoolAddress = @schoolAddress, schoolCity = @schoolCity, schoolState = @schoolState, schoolZip = @schoolZip WHERE (schoolId = @schoolId)">
            <SelectParameters>
                <asp:ControlParameter ControlID="SchoolGrid" Name="schoolId" 
                    PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="schoolName" />
                <asp:Parameter Name="schoolAddress" />
                <asp:Parameter Name="schoolCity" />
                <asp:Parameter Name="schoolState" />
                <asp:Parameter Name="schoolZip" />
                <asp:Parameter Name="schoolId" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="schoolName" />
                <asp:Parameter Name="schoolAddress" />
                <asp:Parameter Name="schoolCity" />
                <asp:Parameter Name="schoolState" />
                <asp:Parameter Name="schoolZip" />
            </InsertParameters>
        </asp:SqlDataSource>
    </p>
</asp:Content>

