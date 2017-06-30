<%@ Page Title="Edit Seasons Icon" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="EditSeasonsIcon.aspx.cs" Inherits="admin_EditSeasonsIcon" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">

        .style3
        {
            text-align: right;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h2>
        Editing Icon for
        <asp:Label ID="SeasonNameLabel" runat="server"></asp:Label>
    </h2>
    <p>
        <table>
            <tr>
                <td class="style3">
                    <b>Current Icon:</b></td>
                <td>
                    <asp:Image ID="IconImage" runat="server" onload="IconImage_Load" />&nbsp
                    <asp:Button ID="Remove" runat="server" Text="Remove" onclick="Remove_Click" 
                        onclientclick="return confirm('Are you shure you want to remove the icon?');" />
                </td>
            </tr>
            <tr>
            <td colspan="2" style="text-align: center; font-weight: 700">- or -</td>
            </tr>
            <tr>
                <td style="font-weight: 700; text-align: right" valign="top">
                    Upload new icon:
                </td>
                <td>
                    <asp:FileUpload ID="IconUpload" runat="server" /><br />
                    <asp:Label ID="IconFailLabel" runat="server" Font-Bold="True" ForeColor="Red" 
                                Text="UPLOAD FAILED: Icon must be a 48x48 .PNG file" 
                        Visible="False"></asp:Label>
                    <br />
                    <asp:Button ID="UploadButton" runat="server" Text="OK" 
                        onclick="UploadButton_Click" />
                </td>
            </tr>
            <tr>
            <td colspan="2" style="text-align: center; font-weight: 700">- or -</td>
            </tr>
            <tr>
                <td style="font-weight: 700; text-align: right">Do nothing:</td>
                <td>
                    <asp:Button ID="CancelButton" runat="server" Text="Cancel" 
                        PostBackUrl="~/admin/Seasons.aspx" /></td>
            </tr>
        </table>
        </p>
</asp:Content>

