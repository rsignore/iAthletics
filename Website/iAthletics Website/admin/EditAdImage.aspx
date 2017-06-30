<%@ Page Title="Edit Ad Image" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="EditAdImage.aspx.cs" Inherits="admin_EditAdImage" %>

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
        Editing Ad Image for
        <asp:Label ID="SportNameLabel" runat="server" Visible="True"></asp:Label>
    </h2>

        <table>
            <tr>
                <td class="style3">
                    <b>Current ad image:</b></td>
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
                    Upload new 
                    ad image:
                </td>
                <td>
                    Ad must be a png or jpeg file 50 pixels high by 320 pixels wide 
                    (320x50)<br />
                    <asp:FileUpload ID="IconUpload" runat="server" />
                    <br />
                    <asp:Button ID="UploadButton" runat="server" Text="Upload" 
                        onclick="UploadButton_Click" />
                    <br />
                    <asp:Label ID="IconFailLabel" runat="server" Font-Bold="True" ForeColor="Red" 
                                Text="Upload failed. Wrong file type. Ad must be a  .png or .jpg file." 
                        Visible="False"></asp:Label>
                    <br />
                    <asp:Label ID="FileSizeErrorLabel" runat="server" Font-Bold="True" ForeColor="Red" 
                                Text="Upload failed. Ad must be 50 pixels high by 320 pixels wide." 
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

