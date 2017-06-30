package com.appapro.iathletics.services;

import java.util.ArrayList;
import java.util.Collections;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.SportListItem;
import com.appapro.iathletics.types.iAthleticsImage;

public class SportsListService extends iAthleticsService
{
	ArrayList<SportListItem> sports = new ArrayList<SportListItem>(10);
	SportListItem currentSport = null;
	
	public SportsListService(iAthleticsActivity activity)
	{
		super(activity);
	}
	
	public ArrayList<SportListItem> getSportsForSeason(int seasonId)
	{
		String parameters = "seasonId=" + Integer.toString(seasonId);
		
		this.requestService("GetSportListForSeason", parameters);
		
		Collections.sort(this.sports);
		
		return this.sports;
	}

	@Override
	protected void elementStart(String elementName)
	{
		// prepare to receive new a new sport list item Info
		//
		if(elementName.compareTo("SportListItem") == 0)
		{
			this.currentSport = new SportListItem();
		}
	}

	@Override
	protected void elementEnd(String elementName, String text)
	{
		// Sport Name
		//
		if(elementName.compareTo("SportName") == 0)
		{
			this.currentSport.setSportName(text);
		}
		
		// team name
		//
		else if(elementName.compareTo("TeamName") == 0)
		{
			this.currentSport.setTeamName(text);
		}
		
		// the icon URL?
		//
		else if(elementName.compareTo("SportIconUrl") == 0)
		{
			iAthleticsImage newImage = new iAthleticsImage(text, this.getActivity());
			this.currentSport.setImage(newImage);
		}
		
		// the team id
		//
		else if(elementName.compareTo("TeamId") == 0)
		{
			this.currentSport.setTeamId(Integer.valueOf(text));
		}
		
		// if this is the end of the SportListItem then add the currentLink to the 
		// dictionary
		//
		else if(elementName.compareTo("SportListItem") == 0)
		{
			// add the currentSport to the dictionary
			//
			this.sports.add(this.currentSport);
		}	
	}

}
