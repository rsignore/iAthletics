<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminLogon.aspx.cs" Inherits="admin_AdminLogon" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {

        }
        .style2
        {
            font-weight: bold;
        }
        .style3
        {
            text-align: right;
        }
        .style4
        {
            font-weight: bold;
            text-align: right;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <img src="../images/appapro%20iathletics%20mobile%20banner.png" alt="iAthletics logo"/></div>
        <table class="style1">
        <tr>
            <td class="style4">
                User name:</td>
            <td>
                <asp:TextBox ID="uid" runat="server" CssClass="style2" Width="150px"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="text-align: right; font-weight: 700">
                Password:</td>
            <td>
                <asp:TextBox ID="pwd" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
                </td>
        </tr>
        <tr>
            <td style="text-align: right; font-weight: 700">
                &nbsp;</td>
            <td style="text-align: center">
                <asp:Button ID="LogonButton" runat="server" onclick="LogonButton_Click" 
                    Text="Logon" />
                </td>
        </tr>
    </table>
    <asp:Panel ID="ErrorPanel" runat="server" 
        style="font-size: small; color: #FF0000" Visible="False">
        Invalid user name or password.<br />
        Need help?
        <asp:HyperLink ID="HyperLink1" runat="server" 
            NavigateUrl="mailto:admin_support@appapro.com?subject=Assistance%20logging%20on">Email support for assistance</asp:HyperLink>
        .
    </asp:Panel>
    <div>
    
    </div>
    </form>
</body>
</html>
