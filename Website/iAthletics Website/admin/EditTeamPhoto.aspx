<%@ Page Title="Edit Sports Icon" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="EditTeamPhoto.aspx.cs" Inherits="admin_EditSportsIcon" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">

        .style3
        {
            text-align: right;
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
        Editing team photo for
        <asp:Label ID="AppLabel" runat="server"></asp:Label>
        <asp:Label ID="TeamLabel" runat="server" Visible="True"></asp:Label>
        <asp:Label ID="SportLabel" runat="server" Visible="True"></asp:Label>
    </h2>

        <table>
            <tr>
                <td class="style3">
                    <b>Current photo:</b></td>
                <td>
                    <asp:Image ID="IconImage" runat="server" onload="IconImage_Load" Height="200px" 
                        Width="320px" />&nbsp
                    <asp:Button ID="Remove" runat="server" Text="Remove" onclick="Remove_Click" 
                        onclientclick="return confirm('Are you shure you want to remove the photo?');" />
                </td>
            </tr>
            <tr>
            <td colspan="2" style="text-align: center; font-weight: 700">- or -</td>
            </tr>
            <tr>
                <td style="font-weight: 700; text-align: right" valign="top">
                    Upload new photo:
                </td>
                <td>
                    Photo must be a png or jpeg file and no wider that 320 pixels.<br />
                    <asp:FileUpload ID="IconUpload" runat="server" />
                    <br />
                    <asp:Button ID="UploadButton" runat="server" Text="Upload" 
                        onclick="UploadButton_Click" />
                    <br />
                    <asp:Label ID="IconFailLabel" runat="server" Font-Bold="True" ForeColor="Red" 
                                Text="Invalid file type: Photo must be a .png, .jpg, or .jpeg file" 
                        Visible="False"></asp:Label>
                    <br />
                    <asp:Label ID="FileToBigLabel" runat="server" Font-Bold="True" ForeColor="Red" 
                                Text="The photo can not be wider than 320 pixels. Please edit and upload again." 
                        Visible="False"></asp:Label>
                    <br />
                </td>
            </tr>
            <tr>
            <td colspan="2" style="text-align: center; font-weight: 700">- or -</td>
            </tr>
            <tr>
                <td style="font-weight: 700; text-align: right">Do nothing:</td>
                <td>
                    <asp:Button ID="CancelButton" runat="server" Text="Cancel" 
                        onclick="CancelButton_Click" /></td>
            </tr>
        </table>
        
</asp:Content>

