<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPNtest.aspx.cs" Inherits="admin_Ad_Wizard_Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    </head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <table>
            <tr>
                <td>
                    payment_status:</td>
                <td>
                    <asp:TextBox ID="payment_status" runat="server">Completed</asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    txn_id:</td>
                <td>
                    <asp:TextBox ID="txn_id" runat="server">IPNtest</asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    item_number:</td>
                <td>
                    <asp:TextBox ID="item_number" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    <asp:Button ID="Button1" runat="server" 
                        PostBackUrl="~/admin/Ad Wizard/PayPalReturn.aspx" Text="Button" />
                </td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
