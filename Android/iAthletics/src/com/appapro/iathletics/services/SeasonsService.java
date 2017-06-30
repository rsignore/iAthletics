package com.appapro.iathletics.services;

import java.util.ArrayList;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.AppSeason;
import com.appapro.iathletics.types.iAthleticsImage;

public class SeasonsService extends iAthleticsService
{
	// constant for Api call
	//
	private static final String SERVICE_NAME = "GetAppSeasons";
	
	// constants for tags in the XML
	//
	private static final String APPSEASON_TAG = "AppSeason";
	private static final String SEASONNAME_TAG = "SeasonName";
	private static final String SEASONID_TAG = "SeasonId";
	private static final String ICONURL_TAG = "IconUrl";
	
	ArrayList<AppSeason> seasons;
	AppSeason curSeason = null;

	public SeasonsService(iAthleticsActivity activity)
	{
		super(activity);
		
		// allocate some space
		//
		seasons = new ArrayList<AppSeason>(3);

	}
	
	// call this function to get the season data for the organization
	//
	public ArrayList<AppSeason> getSeasons()
	{
		this.requestService(SeasonsService.SERVICE_NAME, null);
		
		return this.seasons;
	}

	@Override
	protected void elementStart(String elementName)
	{
		// prepare to receive new AppSeason Info
		//
		if(elementName.compareTo(SeasonsService.APPSEASON_TAG) == 0)
		{
			this.curSeason = new AppSeason();
		}
	}

	@Override
	protected void elementEnd(String elementName, String text)
	{
		// is this the season's name
		//
		if(elementName.compareTo(SeasonsService.SEASONNAME_TAG) == 0)
		{
			this.curSeason.setSeasonName(text);
		}
		
		// the season ID?
		//
		else if(elementName.compareTo(SeasonsService.SEASONID_TAG) == 0)
		{
			this.curSeason.setSeasonId(Integer.valueOf(text));
		}
		
		// the icon URL?
		//
		else if(elementName.compareTo(SeasonsService.ICONURL_TAG) == 0)
		{
			this.curSeason.setImage(new iAthleticsImage(text, getActivity()));
		}
		
		// if this is the end of the AppSeason then add the curSeason to the 
		// seasons array
		//
		else if(elementName.compareTo(SeasonsService.APPSEASON_TAG) == 0)
		{
			this.seasons.add(curSeason);
		}
	}

}
