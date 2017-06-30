package com.appapro.iathletics.services;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.Ad;

public class SplashService extends iAthleticsService
{
	private Ad nextSplash;
	

	public SplashService(iAthleticsActivity activity)
	{
		super(activity);
	}

	// getNextAd()
	//
	// this calls the iAthletics service to get the information
	// about the next ad. It does not get the image, just the
	// descriptive information
	//
	public Ad getNextSplash()
	{	
		// call the service, but force a network attempt so that
		// we will get the absolute information latest information
		// unless we are off the network. If that is the case
		// they we will just show the last ad we got when on the network
		//
		this.requestService("GetNextSplash", null, false);
		
		return this.nextSplash;
	}
	
	@Override
	protected void elementStart(String elementName)
	{
		// look for the start tag. that's the clue the data is coming
		//
		if(elementName.compareTo("GetNextSplash1_0") == 0)
		{
			// allocate an Ad object
			//
			this.nextSplash = new Ad();
		}
	}

	@Override
	protected void elementEnd(String elementName, String text)
	{
		// ad URL
		//
		if(elementName.compareTo("SplashUrl") == 0)
		{
			this.nextSplash.setAdUrl(text);
		}
		
		// the ad image url
		//
		else if(elementName.compareTo("SplashImageUrl") == 0)
		{
			this.nextSplash.setImageUrl(text);
		}
	}
}
