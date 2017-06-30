package com.appapro.iathletics.services;

import com.appapro.iathletics.activities.iAthleticsActivity;

public class AppInfoService extends iAthleticsService 
{
	public static final String APP_AVAILABLE_STR = "Available";
	public static final String APP_CACHING_STR = "Available-Caching";
	public static final String APP_UNAVAILABLE_STR = "Unavailable";
	
	private String status;
	private String message;
	private String currentVersionUrl;
	private Boolean hasSplashAds = false;
	
	// Getters and Setters
	//
	public Boolean getHasSplashAds() {
		return hasSplashAds;
	}
	
	public String getStatus() {
		return status;
	}
	
	public String getMessage() {
		return message;
	}

	public String getCurrentVersionUrl() {
		return currentVersionUrl;
	}
	
	// constructor
	//
	public AppInfoService(iAthleticsActivity activity)
	{
		super(activity);
	}
	
	public void getAppInfo()
	{
		String parameters = "deviceOS=Android&deviceVer=1";
		
		this.requestService("GetAppInfo", parameters);;
		
		// check for a network error, that way the UI can alert the user of not having
		// network access and that the application is using cached data
		//
		if(!this.isNetworkAvailable())
		{
			// even though the network was not available 
			// set my status message to Available-Caching because it
			// still can use cached data.
			//
			this.status = AppInfoService.APP_CACHING_STR;
			this.message = "This application requires Internet access. Attempting to load cached content...";
		}	
	}
	
	public Boolean isAppAvailable()
	{
		return status.compareTo(AppInfoService.APP_AVAILABLE_STR) == 0 || status.compareTo(AppInfoService.APP_CACHING_STR) == 0;
	}
	
	public Boolean isCaching()
	{
		return status.compareTo(AppInfoService.APP_CACHING_STR) == 0;
	}
	
	

	// Abstract implementations
	//
	@Override
	protected void elementStart(String elementName) 
	{
		// nothing to do here
	}

	@Override
	protected void elementEnd(String elementName, String text) 
	{
		// status
		//
		if(elementName.compareTo("Status") == 0)
		{
			this.status = text;
		}
		
		// message
		//
		else if(elementName.compareTo("Message") == 0)
		{
			this.message = text;
		}	
		// sport name
		//
		else if(elementName.compareTo("CurrentVersionUrl") == 0)
		{
			this.currentVersionUrl = text;
		}	
		else if(elementName.compareTo("HasSplashAds") == 0)
		{
			if (text.compareTo("true") == 0)
			{
				this.hasSplashAds = true;
			}
			else
			{
				this.hasSplashAds = false;
			}
		}
	}

}
