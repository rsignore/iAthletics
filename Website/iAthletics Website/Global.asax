<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        // Code that runs on application startup

        //save the DB connection string for faster access in the application
        //
        ConnectionStringsSection connStrings =
        System.Web.Configuration.WebConfigurationManager.GetSection("connectionStrings")
        as ConnectionStringsSection;

        if (connStrings.ConnectionStrings.Count > 0)
        {
            ConnectionStringSettings settings = connStrings.ConnectionStrings["iAthleticsConnectionString"];

            if (settings != null)
            {
                Application["DB_CONNECTION_STRING"] = settings.ConnectionString;
                Application["DB_CONNECTION_STRING_LIVE"] = settings.ConnectionString;
            }
        }
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
       
</script>
