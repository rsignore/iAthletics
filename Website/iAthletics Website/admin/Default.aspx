<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="admin_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Panel ID="AdminPanel" runat="server">
    <h2>
        Master Application Data</h2>
    <p>
        <asp:HyperLink ID="HyperLink5" runat="server" 
            NavigateUrl="~/admin/LinkTypes.aspx">Link types</asp:HyperLink>
</p>
    <p>
        <asp:HyperLink ID="HyperLink8" runat="server" 
            NavigateUrl="~/admin/Clients.aspx">Mobile clients</asp:HyperLink>
</p>
    <p>
        <asp:HyperLink ID="HyperLink4" runat="server" 
            NavigateUrl="~/admin/Seasons.aspx">Seasons</asp:HyperLink>
</p>
    <p>
        <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl="~/admin/Sports.aspx">Sports</asp:HyperLink>
</p>
    <p>
        <asp:HyperLink ID="HyperLink6" runat="server" NavigateUrl="~/admin/States.aspx">States</asp:HyperLink>
</p>
</asp:Panel>
    <h2>
        Application Configuration</h2>
    <p>
        <asp:HyperLink ID="HyperLink7" runat="server" NavigateUrl="~/admin/Venus.aspx">Manage venue list</asp:HyperLink>
&nbsp;</p>
    <p>
        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/admin/Applications.aspx">Manage application Information</asp:HyperLink>
        &nbsp;(includes teams, news, ads, supporting links, and schedules)</p>
</asp:Content>

