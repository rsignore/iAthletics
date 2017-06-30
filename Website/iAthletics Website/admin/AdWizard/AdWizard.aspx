<%@ Page Title="Ad Wizard" Language="C#" MasterPageFile="~/admin/AdminMasterPage.master" AutoEventWireup="true"
    CodeFile="AdWizard.aspx.cs" Inherits="_Default" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="head">
    <style type="text/css">
        .style1
        {
            height: 57px;
        }
        .style2
        {
            width: 150px;
        }
        .style3
        {
            width: 100px;
        }
        .style4
        {
            width: 511px;
        }
        .style5
        {
            font-size: small;
        }
    </style>
    </asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div style="float: left" id="marketing content">
        <asp:Image ID="Image2" runat="server" 
            ImageUrl="~/images/football screenshot small.png" />
        
    </div>
    <div id="center page" style="margin-top: 20px; margin-left: 260px;">
        <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </asp:ToolkitScriptManager>
        <br />
        <asp:MultiView ID="AdCreateWizard" runat="server" ActiveViewIndex="0">
            <asp:View ID="Welcome" runat="server">
                <asp:LinkButton ID="LinkButton6" runat="server" Text="&lt; Cancel" 
                    PostBackUrl="~/admin/ApplicationAds.aspx"></asp:LinkButton>
                &nbsp;<asp:Button ID="BeginButton1" runat="server" Text="Begin >" 
                    CommandArgument="Step1" CommandName="SwitchViewByID" />
            <h3>Welcome to the Ad Wizard</h3>
            <p style="width: 75%">The Ad Wizard let&#39;s you create new ads in your iAthletics app. There 
                are two ways to create banner ads. You can upload a completed 320 pixel wide by 
                50 pixels high image, or you can upload a business card, logo, or some
                other marketing material and Appapro will create the ad for you (for an additional $25.00).</p>
            <p style="width: 75%">Ads are purchased to run in 3-month increments up to a full 
                year. The length of the ad you can purchase is limited to the amount of time 
                left on your current Appapro iAthletics subscription. See the table below for 
                the current ad rates:</p>
            <div align="center"><table><tr bgcolor="#999999"><td><b>Ad Duration</b></td><td><b>Pre-made 320x50 image</b></td><td><b>Appapro created image<br />
                <span class="style5">(additional $25.00 graphic artist fee applied)</span> </b></td></tr>
                <tr>
                    <td bgcolor="#999999">
                        3-months</td>
                    <td>
                        $12.65</td>
                    <td>
                        $37.65</td>
                </tr>
                <tr>
                    <td bgcolor="#999999">
                        6-months</td>
                    <td bgcolor="#CCCCCC">
                        $23.75</td>
                    <td bgcolor="#CCCCCC">
                        $48.75</td>
                </tr>
                <tr>
                    <td bgcolor="#999999">
                        9-months</td>
                    <td>
                        $33.65</td>
                    <td>
                        $58.65</td>
                </tr>
                <tr>
                    <td bgcolor="#999999">
                        12-months</td>
                    <td bgcolor="#CCCCCC">
                        $42.30</td>
                    <td bgcolor="#CCCCCC">
                        $67.30</td>
                </tr>
                </table>
            </div>
                <asp:LinkButton ID="LinkButton7" runat="server" 
                    PostBackUrl="~/admin/ApplicationAds.aspx">&lt; Cancel</asp:LinkButton>
                &nbsp;<asp:Button ID="BeginButton2" runat="server" Text="Begin >" 
                    CommandArgument="Step1" CommandName="SwitchViewByID" />
            </asp:View>
            <asp:View ID="Step1" runat="server"><h3>
            <strong>Step 1:</strong> Enter contact information for the advertiser</h3>
&nbsp;<table>
                    <tr>
                        <td align="right">
                            *Advertiser Name:</td>
                        <td>
                            <asp:TextBox ID="BusinessName" runat="server" Width="100%"></asp:TextBox>
                        </td>
                        <td>
                            <asp:RequiredFieldValidator ID="BusinessNameValidator" runat="server" 
                                ControlToValidate="BusinessName" Display="None" 
                                ErrorMessage="Please enter the name of the advertiser." ForeColor="Red" 
                                ValidationGroup="Step1" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                <asp:ValidatorCalloutExtender
                                    ID="ValidatorCalloutExtender1" runat="server" 
                                TargetControlID="BusinessNameValidator"></asp:ValidatorCalloutExtender>
                        </td>
                    </tr>
                <tr>
                    <td align="right">
                        Address</td>
                    <td>
                        <asp:TextBox ID="Address1" runat="server" Width="100%"></asp:TextBox>
                    </td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td align="right">
                        &nbsp;</td>
                    <td>
                        <asp:TextBox ID="Address2" runat="server" Width="100%"></asp:TextBox>
                    </td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td align="right">
                        City:</td>
                    <td>
                        <asp:TextBox ID="City" runat="server"></asp:TextBox>
                        &nbsp;State:
                        <asp:DropDownList ID="State" runat="server" DataSourceID="StateList" 
                            DataTextField="stateAbv" DataValueField="stateAbv" 
                            ondatabound="State_DataBound">
                            <asp:ListItem>NC</asp:ListItem>
                            <asp:ListItem>SC</asp:ListItem>
                            <asp:ListItem>TN</asp:ListItem>
                        </asp:DropDownList>
                        &nbsp;Zip:
                        <asp:TextBox ID="Zip" runat="server" MaxLength="10" Width="75px"></asp:TextBox>
                        <asp:MaskedEditExtender ID="Zip_MaskedEditExtender" runat="server" 
                            CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
                            CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
                            CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
                            Mask="99999-9999" TargetControlID="Zip"></asp:MaskedEditExtender>
                        <asp:SqlDataSource ID="StateList" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>" 
                            SelectCommand="SELECT [stateAbv] FROM [States] ORDER BY [stateAbv]">
                        </asp:SqlDataSource>
                    </td>
                    <td>
                        <asp:RegularExpressionValidator ID="ZipRegularExpressionValidator" runat="server" 
                            ControlToValidate="Zip" Display="None" 
                            ErrorMessage="The zip code entered is not properly formatted." 
                            ValidationExpression="\d{5}(\d{4})?" ValidationGroup="Step1"></asp:RegularExpressionValidator>
                        <asp:ValidatorCalloutExtender ID="ZipRegularExpressionValidator_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="ZipRegularExpressionValidator"></asp:ValidatorCalloutExtender>
                    </td>
                </tr>
                    <tr>
                        <td align="right">
                            Contact Name:</td>
                        <td>
                            <asp:TextBox ID="ContactName" runat="server" Width="100%"></asp:TextBox>
                        </td>
                        <td>
                            &nbsp;</td>
                    </tr>
                <tr>
                    <td align="right">
                        Email Address:</td>
                    <td>
                        <asp:TextBox ID="Email1" runat="server" Width="100%"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RegularExpressionValidator ID="EmailExpressionValidator" runat="server" 
                            ControlToValidate="Email1" Display="None" ErrorMessage="The format of the email entered is not valid" 
                            ForeColor="Red" 
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                            ValidationGroup="Step1" SetFocusOnError="True">Invalid email</asp:RegularExpressionValidator>
                        <asp:ValidatorCalloutExtender ID="EmailExpressionValidator_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="EmailExpressionValidator"></asp:ValidatorCalloutExtender>
                    </td>
                </tr>
                    <tr>
                        <td align="right">
                            Phone Number:</td>
                        <td>
                            <asp:TextBox ID="PhoneNumber" runat="server" Width="100px" MaxLength="17"></asp:TextBox>
                            <asp:MaskedEditExtender ID="PhoneNumber_MaskedEditExtender" runat="server" 
                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="" 
                                CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" 
                                CultureThousandsPlaceholder="" CultureTimePlaceholder="" Enabled="True" 
                                Mask=" (999) 999-9999" TargetControlID="PhoneNumber"></asp:MaskedEditExtender>
                        </td>
                        <td>
                            <asp:RegularExpressionValidator ID="PhoneNumberValidator" runat="server" 
                                ControlToValidate="PhoneNumber" Display="None" 
                                ErrorMessage="The format of the phone number is not valid." ForeColor="Red" 
                                SetFocusOnError="True" 
                                ValidationExpression="\d{10}" 
                                ValidationGroup="Step1"></asp:RegularExpressionValidator>
                            <asp:ValidatorCalloutExtender ID="PhoneNumberValidator_ValidatorCalloutExtender" 
                                runat="server" Enabled="True" TargetControlID="PhoneNumberValidator"></asp:ValidatorCalloutExtender>
                        </td>
                    </tr>
                <tr>
                    <td align="right">
                        * = required field</td>
                    <td align="right">
                        <asp:Button ID="Step1Button" runat="server" Text="Proceed to step 2 &gt;" 
                            CommandArgument="Step2" CommandName="SwitchViewByID" 
                            ValidationGroup="Step1" />
                    </td>
                    <td align="right">
                        &nbsp;</td>
                </tr>
            </table>
            </asp:View>
            <asp:View ID="Step2" runat="server"><h3>
            <strong>Step 2:</strong> how would you like to create your ad?</h3>
&nbsp;<table style="width: 544px">
                <tr>
                    <td align="right" width="100px" valign="top">
                        Choose:</td>
                    <td class="style4">
                        <asp:RadioButton ID="BuildRadio" runat="server" 
                            Text="Build an ad using a logo, business card, or some other image and  text. ($25.00 graphic artist services included)" 
                            GroupName="BuildOrUpload" />
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        &nbsp;</td>
                    <td class="style4">
                        <asp:RadioButton ID="UploadRadio" runat="server" GroupName="BuildOrUpload" 
                            Text="Upload a 320px wide by 50px high ad you already have available." 
                            Checked="True" />
                    </td>
               </tr>
                <tr>
                    <td align="right">
                        &nbsp;</td>
                    <td align="right" class="style4">
                        <asp:LinkButton ID="LinkButton1" runat="server" CommandArgument="Step1" 
                            CommandName="SwitchViewByID">&lt; back</asp:LinkButton>
                        &nbsp;
                        <asp:Button ID="Step2NextBtn" runat="server" Text="Proceed to step 3 &gt;" 
                            onclick="Step2NextBtn_Click" />
                    </td>
                </tr>
            </table>
            <h3>Not sure which option to choose?</h3>
            
                <p>
                    Choose the <b>upload</b> option if you already created a 320 pixels wide and 50 
                    pixels high image.</p>
                    <p>Choose the <b>build</b> option to use a business card, company logo, or some 
                        other image to have Appapro create the ad for you. You can also specifiy up to 
                        three lines of text to include in your ad. We will send you a proof of the ad 
                        before it is run in the mobile app.</p>
            
            </asp:View><asp:View ID="StepUpload" runat="server">
                <h3>
                    Step 3: upload a banner ad
                </h3>
                <asp:Panel ID="StepUploadErrorPanel" runat="server" style="color: #FF0000; border: solid; border-width: 2px; padding: 5px; text-align: center; width: 100%;">
                <asp:Label ID="StepUploadError" runat="server" 
                    Text="Error" 
                    >
                    </asp:Label>
                   </asp:Panel>
                
&nbsp;<table>
                        <tr valign="top">
                            <td align="right">
                                1. Select the image file on your computer:</td>
                            <td>
                                <asp:FileUpload ID="FileUploadBanner" runat="server" Width="300px" />
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                2. Click the upload button:</td>
                            <td align="left">
                                <asp:Button ID="UploadBannerButton" runat="server" 
                                    onclick="UploadBannerButton_Click" Text="Upload" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" class="style1">
                                3: Verify the ad here:</td>
                            <td align="left" class="style1">
                                <asp:Image ID="UploadedBannerImage" runat="server" BorderColor="Black" 
                                    BorderStyle="Solid" BorderWidth="1px" Height="50px" ImageAlign="Middle" 
                                    ImageUrl="~/images/yourAdHere.png" Width="320px" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                &nbsp;</td>
                            <td align="right">
                                <asp:LinkButton ID="LinkButton2" runat="server" CommandArgument="Step2" 
                                    CommandName="SwitchViewByID">&lt; back</asp:LinkButton>
                                &nbsp;
                                <asp:Button ID="StepBannerNextButton" runat="server" Text="Proceed to step 4 &gt;" 
                                    CommandArgument="Step4" CommandName="SwitchViewByID" 
                                    CausesValidation="False" Enabled="False" 
                                    onprerender="StepBannerNextButton_PreRender" />
                            </td>
                        </tr>
                    </table>
                
                <h4>
                    Instructions</h4>
                <p>
                    The uploaded banner ad will be converted to measure exactally 320 pixels wide by 
                    50 pixels high. Please make sure the ad displays as you 
                    expect it to. If it does not display properly you should either edit the image to
                    measure 320x50 using an image editing program or let us help you build the ad uisng the 
                    <asp:LinkButton ID="GotoAdBuilderButton" runat="server" 
                        onclick="GotoAdBuilderButton_Click">ad builder</asp:LinkButton>. We might be able
                        to modify the image to the proper dimentions.</p>
                
        </asp:View><asp:View ID="StepBuild" runat="server">
                <h3>
                    Step 3: Build a banner ad</h3>&nbsp;<asp:Panel ID="StepBuildErrorPanel" 
                    runat="server" 
                    style="color: #FF0000; border: solid; border-width: 2px; padding: 5px; text-align: center; width: 100%;">
                    <asp:Label ID="StepBuildError" runat="server" Text="Error"></asp:Label>
                </asp:Panel>
&nbsp;<table>
                        <tr valign="top">
                            <td align="right" width="250px">
                                1. Choose a scanned image of a business card,&nbsp; company logo, or other image you 
                                to build the ad from:</td>
                            <td>
                                <asp:FileUpload ID="FileUploadBuild" runat="server" Width="300px" />
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="middle" width="250px">
                                2. Click the upload button:</td>
                            <td>
                                <asp:Button ID="UploadBuildImage" runat="server" 
                                    onclick="UploadBuildImage_Click" Text="Upload" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                3. Verify the image displays here:</td>
                            <td>
                                <asp:Image ID="BuildImage" runat="server" BorderColor="Black" 
                                    BorderStyle="Solid" BorderWidth="1px" Height="182px" ImageAlign="Middle" 
                                    ImageUrl="~/images/yourBusinessCardOrLogo.png" Width="320px" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                &nbsp;</td>
                            <td align="right">
                                <asp:Button ID="ClearButton" runat="server" Font-Size="XX-Small" Height="20px" 
                                    onclick="ClearButton_Click" Text="Clear image" Width="70px" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                First line of text:</td>
                            <td>
                                <asp:TextBox ID="FirstLine" runat="server" MaxLength="40" Width="250px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Optional second line of text:</td>
                            <td>
                                <asp:TextBox ID="SecondLine" runat="server" Width="250px" MaxLength="40"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Optional third line of text:</td>
                            <td>
                                <asp:TextBox ID="ThirdLine" runat="server" Width="250px" MaxLength="40"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="top">
                                Instructions and/or additional informaiton:</td>
                            <td>
                                <asp:TextBox ID="Instructions" runat="server" Height="92px" TextMode="MultiLine" 
                                    Width="250px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                &nbsp;</td>
                            <td align="right">
                                <asp:LinkButton ID="LinkButton3" runat="server" CommandArgument="Step2" 
                                    CommandName="SwitchViewByID">&lt; back</asp:LinkButton>
                                &nbsp;<asp:Button ID="StepBuildNextButton" runat="server" CommandArgument="Step4" 
                                    CommandName="SwitchViewByID" Text="Proceed to step 4 &gt;" 
                                    CausesValidation="False" />
                            </td>
                        </tr>
                    </table>
                <h4>
                    Instructions</h4>
                <p>
                    Appapro can build a banner ad for you using a business card, logo, or other 
                    image. You can also enter up to 3 three lines of text on the ad. We will send 
                    you a proof for you to OK before the ad is run in the mobile app.</p>
        </asp:View>
            <asp:View ID="Step4" runat="server">
                <h3>
                    Step 4: what will the user see when they tap on the ad?</h3>
                &nbsp;
                <table>
                    <tr>
                        <td align="right">
                            URL to show the user:</td>
                        <td>
                            <asp:TextBox ID="Url" runat="server" Width="250px"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                                ControlToValidate="Url" Display="None" ErrorMessage="Please enter a valid URL that begins with either http:// or https://." 
                                ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?" 
                                ValidationGroup="Step4"></asp:RegularExpressionValidator>
                            <asp:ValidatorCalloutExtender ID="RegularExpressionValidator3_ValidatorCalloutExtender" 
                                runat="server" Enabled="True" TargetControlID="RegularExpressionValidator3"></asp:ValidatorCalloutExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            &nbsp;</td>
                        <td align="right">
                            <asp:LinkButton ID="Step4BackButton" runat="server" 
                                onclick="Step4BackButton_Click">&lt; back</asp:LinkButton>
                            &nbsp;<asp:Button ID="Step4NextButton" runat="server" Text="Step 5 &gt;" 
                                ValidationGroup="Step4" 
                                CommandArgument="AdDurationView" CommandName="SwitchViewByID" />
                        </td>
                    </tr>
                </table>
                <h4>instructions</h4>
                <p>Linking the ad is optional. You can link the ad to the home page of a website or 
                    to a page with coupons or special offers. You can also link the ad to a video or 
                    other multimedia sources on the internet. </p>
            </asp:View>
            <asp:View ID="AdDurationView" runat="server">
                <h3>
                    Step 5: How long will the ad run?</h3>
                <table><tr><td style="text-align: right">When will the ad first appear:</td><td>
                    <asp:TextBox ID="AdStartDate" runat="server" 
                        onload="AdStartDate_Load" AutoPostBack="True" CausesValidation="True" 
                        ontextchanged="AdStartDate_TextChanged1"></asp:TextBox>
                    <asp:CalendarExtender ID="AdStartDate_CalendarExtender" runat="server" 
                        Enabled="True" TargetControlID="AdStartDate"></asp:CalendarExtender>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="AdStartDate" Display="None" 
                        ErrorMessage="Please choose the date the ad should first appar in the app." 
                        ValidationGroup="Step5"></asp:RequiredFieldValidator>
                    <asp:ValidatorCalloutExtender ID="RequiredFieldValidator1_ValidatorCalloutExtender" 
                        runat="server" Enabled="True" TargetControlID="RequiredFieldValidator1"></asp:ValidatorCalloutExtender>
                    <asp:CompareValidator ID="AdStartValid" runat="server" 
                        ControlToValidate="AdStartDate" Display="None" 
                        ErrorMessage="Please enter a valid date" Operator="DataTypeCheck" Type="Date" 
                        ValidationGroup="Step5">Please enter a valid date</asp:CompareValidator>
                    <asp:ValidatorCalloutExtender ID="AdStartValid_ValidatorCalloutExtender" 
                        runat="server" Enabled="True" TargetControlID="AdStartValid"></asp:ValidatorCalloutExtender>
                </td></tr>
                    <tr>
                        <td>
                            Ad Duration:</td>
                        <td>
                            <asp:DropDownList ID="AdDurationCombo" runat="server" DataSourceID="GetValidAdDurations" 
                                DataTextField="AdName" DataValueField="AdRateId" 
                                onprerender="AdDurationCombo_PreRender" AutoPostBack="True">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="GetValidAdDurations" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:iAthleticsConnectionString %>"  
                                SelectCommand="SELECT dbo.CssAdRates.AdDescription + ' ($' + STR(dbo.CssAdRates.AdCost, 5, 2) + ')' AS AdName, DATEADD(month, dbo.CssAdRates.AdDurationMonths, @startDate) AS endOfAd, dbo.CssAdRates.AdRateId FROM dbo.CssAdRates INNER JOIN dbo.Applications ON DATEADD(month, dbo.CssAdRates.AdDurationMonths, @startDate) &lt;= dbo.Applications.endDate WHERE (dbo.CssAdRates.AdType = @adType) AND (dbo.Applications.appId = @app_id) ORDER BY dbo.CssAdRates.AdCost" 
                                >
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="AdStartDate" DefaultValue="1/1/1980" 
                                        Name="startDate" PropertyName="Text" />
                                    <asp:SessionParameter DefaultValue="0" Name="adType" SessionField="adType" />
                                    <asp:SessionParameter Name="app_id" SessionField="AppIdParam" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                <tr><td></td><td>
                    <asp:LinkButton ID="LinkButton5" runat="server" CommandArgument="Step4" 
                        CommandName="SwitchViewByID">&lt; Back</asp:LinkButton>
                    &nbsp;<asp:Button ID="Step5Button" runat="server" CommandArgument="ReviewAndSubmit" 
                        CommandName="SwitchViewByID" Text="Next &gt;" 
                        ValidationGroup="Step5" Enabled="False" />
                    </td></tr></table>
            </asp:View>
            <asp:View ID="ReviewAndSubmit" runat="server" onload="ReviewAndSubmit_Load" 
                onprerender="ReviewAndSubmit_PreRender">
                <h3>
                    Review and submit</h3>
                <h4>
                    Business and Contact Information</h4>
                <table>
                        <tr>
                            <td align="right">
                                Business Name:</td>
                            <td>
                                <asp:Label ID="LabelBusinessName" runat="server" style="font-weight: 700"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="top">
                                Address:</td>
                            <td>
                                <asp:Label ID="LabelAddress1" runat="server" style="font-weight: 700"></asp:Label>
                                <br />
                                <asp:Label ID="LabelAddress2" runat="server" style="font-weight: 700"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                &nbsp;</td>
                            <td>
                                <asp:Label ID="LabelCity" runat="server" style="font-weight: 700"></asp:Label>
                                ,
                                <asp:Label ID="LabelState" runat="server" style="font-weight: 700"></asp:Label>
                                &nbsp;<asp:Label ID="LabelZip" runat="server" style="font-weight: 700"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Contact Name:</td>
                            <td>
                                <asp:Label ID="LabelContactName" runat="server" style="font-weight: 700"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Contact Email:</td>
                            <td>
                                <asp:Label ID="LabelEmail" runat="server" style="font-weight: 700"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                Phone:</td>
                            <td>
                                <asp:Label ID="LabelPhone" runat="server" style="font-weight: 700"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                        </tr>
                    </table>
               
                   
                        <asp:MultiView ID="ReviewMultiView" runat="server" 
                    onload="ReviewMultiView_Load">
                            <asp:View ID="ReviewUpload" runat="server" onload="ReviewUpload_Load">
                                <h4>
                                    Ad Information<br />
                                </h4>
                                <table>
                                    <tr>
                                        <td valign="top" align="right">
                                            Ad Image:</td>
                                        <td>
                                            <asp:Image ID="LabelBannerAd" runat="server" BorderColor="Black" BorderWidth="1px" 
                                                Height="50px" Width="320px" />
                                        </td>
                                    </tr>
                                    </table>
                                    
                            </asp:View>
                            
                            <asp:View ID="ReviewBuild" runat="server" onload="ReviewBuild_Load">
                                <h4>Ad Information</h4>
                                <table>
                                    <tr>
                                        <td align="right" valign="top" >
                                            Business card, logo, or other image:</td>
                                        <td>
                                            <asp:Image ID="LabelBuildImage" runat="server" BorderColor="Black" 
                                                BorderStyle="Solid" BorderWidth="1px" Height="182px" ImageAlign="Middle" 
                                                ImageUrl="~/images/yourBusinessCardOrLogo.png" Width="320px" />
                                            <asp:Label ID="LabelNoBuildImage" runat="server" Text="- none -" 
                                                Visible="False"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" >
                                            First line of text:</td>
                                        <td>
                                            <asp:Label ID="LabelFirstLine" runat="server" style="font-weight: 700"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" >
                                            Optional second line of text:</td>
                                        <td>
                                            <asp:Label ID="LabelSecondLine" runat="server" style="font-weight: 700"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" >
                                            Optional third line of text:</td>
                                        <td>
                                            <asp:Label ID="LabelThirdLine" runat="server" style="font-weight: 700"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" valign="top" >
                                            Instructions and/or additional informaiton:</td>
                                        <td>
                                            <asp:Label ID="LabelInstructions" runat="server" style="font-weight: 700"></asp:Label>
                                        </td>
                                    </tr>
                                </table>

                            </asp:View>
                        </asp:MultiView>
                        <h4>
                            Link to website</h4>
                <table>
                    <tr>
                        <td align="right" class="style3">
                            URL:</td>
                        <td>
                            <asp:Label ID="LabelUrl" runat="server" style="font-weight: 700"></asp:Label>
                        </td>
                    </tr>
                </table>
                        <h4>Ad Duration and Cost</h4>
                        <table>
                                    <tr>
                                        <td valign="top" align="right">
                                            Ad Start Date:</td>
                                        <td>
                                            <asp:Label ID="LabelAdStartDate" runat="server" style="font-weight: 700"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" valign="top">
                                            Ad End Date:</td>
                                        <td>
                                            <asp:Label ID="LabelAdEndDate" runat="server" style="font-weight: 700"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" valign="top">
                                            Ad Type:</td>
                                        <td>
                                            <asp:Label ID="LabelAdType" runat="server" style="font-weight: 700"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" valign="top">
                                            Ad Cost:</td>
                                        <td>
                                            <asp:Label ID="LabelAdCost" runat="server" style="font-weight: 700"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                    <br />
                    <table>
                        <tr>
                            <td align="right" class="style3">
                                <asp:Label ID="AcceptCheckError" style="color: #FF0000" runat="server" 
                                    Text="You must check this box to pay for the ad ----&gt;" Visible="False" 
                                    BorderColor="Red" BorderStyle="Solid"></asp:Label></td>
                            <td>
                                <asp:CheckBox ID="Accept" runat="server" 
                                    Text="Yes, the information above is correct. Please proceed." />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;</td>
                            <td >
                                <span style="font-size: x-small">(Use the back button below 
                                to make corrections)</span></td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;</td>
                            <td>
                                <asp:LinkButton ID="LinkButton4" runat="server" CommandArgument="AdDurationView" 
                                    CommandName="SwitchViewByID">&lt; back</asp:LinkButton>
                                &nbsp;<asp:ImageButton ID="Submit" runat="server" 
                                    ImageUrl="https://www.paypalobjects.com/en_US/i/btn/btn_paynowCC_LG.gif" 
                                    ValidationGroup="SubmitGroup" onclick="Submit_Click" />
                            </td>
                        </tr>
                    </table>
                
            </asp:View>
            <asp:View ID="Thankyou" runat="server">
                Thank you for supporting ???. Your ad information was sucessfuly submitted.
            </asp:View>
        </asp:MultiView>
        <br />
        
        
        
    </div>
</asp:Content>
