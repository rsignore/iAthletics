<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TriviaAnswer.aspx.cs" Inherits="apex_TriviaAnswer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
            font-weight: bold;
            text-align: right;
        }
        .style3
        {
            text-align: left;
        }
    </style>
</head>
<body>
    <div style="text-align: center">
    
        &nbsp;<img src="Apex%20Logo.JPG" /></div>
    <div style="padding: 10px; margin: 10px; background-color: #CCCCCC; font-family: Arial, Helvetica, sans-serif; font-size: medium; font-weight: bolder; text-align: center;">
        Think you know the answer to this week&#39;s Apex Cougar trivia question? Send us 
        your answer below. The winner will be randomly selected from all the correct 
        answers submitted.
   </div>
   <div style="text-align: center">
    <form runat="server" id="form1">
        
        <table class="style1">
            <tr>
                <td class="style2">
                    Your Name:</td>
                <td class="style3">
                    <asp:TextBox ID="EntryName" runat="server"  
                        Width="300px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="EntryName" ErrorMessage="Please supply your name"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    Email address:</td>
                <td class="style3">
                    <asp:TextBox ID="EntryEmail" runat="server" Width="300px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ControlToValidate="EntryEmail" Display="Dynamic" 
                        ErrorMessage="Please supply your email address"></asp:RequiredFieldValidator>
&nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                        ControlToValidate="EntryEmail" ErrorMessage="Address not properly formatted" 
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    Trivia question&#39;s answer:</td>
                <td class="style3">
                    <asp:TextBox ID="EntryAnswer" runat="server" Rows="5" TextMode="MultiLine" 
                        Width="300px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="EntryAnswer" ErrorMessage="Please submit an answer"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    &nbsp;</td>
                <td class="style3">
                    <asp:Button ID="Button1" runat="server" Text="Submit your answer" 
                        onclick="Button1_Click" />
                </td>
            </tr>
        </table>
        <br />
&nbsp;<input type="hidden" name="subject" value="Apex trivia contest answer" />
<input type="hidden" name="redirect" value="/iathletics/apex/TriviaThankYou.html" />
        <br />
        </form>
   </div>

</body>
</html>
