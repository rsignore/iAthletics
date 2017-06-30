using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for version1_0
/// </summary>
[WebService(Namespace = "http://appapro.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class version1_0 : System.Web.Services.WebService {

    public version1_0 () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public GetAppInfo1_0 GetAppInfo(int appId, string deviceId, string deviceOS, float deviceVer)
    {
        GetAppInfo1_0 retVal = new GetAppInfo1_0(Context);

        retVal.ExecuteService(appId, deviceId, deviceOS, deviceVer);

        return retVal;
    }

    [WebMethod]
    public GetAppSeasons1_0 GetAppSeasons(int appId, string deviceId)
    {
        GetAppSeasons1_0 retVal = new GetAppSeasons1_0(Context);

        retVal.ExecuteService(appId, deviceId);

        return retVal;
    }

    [WebMethod]
    public GetNextEvent1_0 GetNextEvent(int appId, string deviceId)
    {
        GetNextEvent1_0 retval = new GetNextEvent1_0(Context);

        retval.ExecuteService(appId, deviceId);

        return retval;
    }

    [WebMethod]
    public GetAppNewsLinks1_0 GetAppNewsLinks(int appId, string deviceId)
    {
        GetAppNewsLinks1_0 retVal = new GetAppNewsLinks1_0(Context);

        retVal.ExecuteService(appId, deviceId);

        return retVal;
    }

    [WebMethod]
    public GetUpcommingEvents1_0 GetUpcommingEvents(int appId, string deviceId)
    {
        GetUpcommingEvents1_0 retVal = new GetUpcommingEvents1_0(Context);

        retVal.ExecuteService(appId, deviceId);

        return retVal;
    }

    [WebMethod]
    public GetSportListForSeason1_0 GetSportListForSeason(int appId, string deviceId, int seasonId)
    {
        GetSportListForSeason1_0 retVal = new GetSportListForSeason1_0(Context);

        retVal.ExecuteService(appId, deviceId, seasonId);

        return retVal;
    }

    [WebMethod]
    public GetTeamInfo1_0 GetTeamInfo(int appId, string deviceId, int teamId)
    {
        GetTeamInfo1_0 retVal = new GetTeamInfo1_0(Context);

        retVal.ExecuteService(appId, deviceId, teamId);

        return retVal;
    }

    [WebMethod]
    public GetTeamRoster1_0 GetTeamRoster(int appId, string deviceId, int teamId)
    {
        GetTeamRoster1_0 retval = new GetTeamRoster1_0(Context);

        retval.ExecuteService(appId, deviceId, teamId);

        return retval;
    }

    [WebMethod]
    public GetCompleteTeamSchedule1_0 GetCompleteTeamSchedule(int appId, string deviceId, int teamId)
    {
        GetCompleteTeamSchedule1_0 retval = new GetCompleteTeamSchedule1_0(Context);

        retval.ExecuteService(appId, deviceId, teamId);

        return retval;
    }

    [WebMethod]
    public GetNextAd1_0 GetNextAd(int appId, string deviceId)
    {
        GetNextAd1_0 retval = new GetNextAd1_0(Context);

        retval.ExecuteService(appId, deviceId);

        return retval;
    }
}

