package com.appapro.iathletics.services;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.Ad;

public class AdService extends iAthleticsService
{
	private Ad nextAd = null;
	
	public AdService(iAthleticsActivity activity)
	{
		super(activity);
	}
	
	// getNextAd()
	//
	// this calls the iAthletics service to get the information
	// about the next ad. It does not get the image, just the
	// descriptive information
	//
	public Ad getNextAd()
	{	
		// call the service, but force a network attempt so that
		// we will get the absolute information latest information
		// unless we are off the network. If that is the case
		// they we will just show the last ad we got when on the network
		//
		this.requestService("GetNextAd", null, false);
		
		return this.nextAd;
	}
	
	@Override
	protected void elementStart(String elementName)
	{
		// look for the start tag. that's the clue the data is coming
		//
		if(elementName.compareTo("GetNextAd1_0") == 0)
		{
			// allocate an Ad object
			//
			this.nextAd = new Ad();
		}
	}

	@Override
	protected void elementEnd(String elementName, String text)
	{
		// ad URL
		//
		if(elementName.compareTo("AdUrl") == 0)
		{
			this.nextAd.setAdUrl(text);
		}
		
		// the ad image url
		//
		else if(elementName.compareTo("AdImageUrl") == 0)
		{
			this.nextAd.setImageUrl(text);
		}
	}

}
