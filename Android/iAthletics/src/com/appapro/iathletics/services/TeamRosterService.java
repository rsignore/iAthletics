package com.appapro.iathletics.services;

import java.util.ArrayList;
import java.util.Collections;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.Athlete;

public class TeamRosterService extends iAthleticsService
{
	ArrayList<Athlete> athletes = new ArrayList<Athlete>(10);
	Athlete currentAthlete;
	
	public TeamRosterService(iAthleticsActivity activity)
	{
		super(activity);
	}
	
	

	public ArrayList<Athlete> getAthleties(int teamId)
	{
		String parameters = "teamId=" + String.valueOf(teamId);
		
		this.requestService("GetTeamRoster", parameters);
		
		Collections.sort(athletes);
		return athletes;
	}


	@Override
	protected void elementStart(String elementName)
	{
		// prepare to receive new athlete Info
		//
		if(elementName.compareTo("Player") == 0)
		{
			this.currentAthlete = new Athlete();
		}
	}

	@Override
	protected void elementEnd(String elementName, String text)
	{
		// player name
		//
		if(elementName.compareTo("Name") == 0)
		{
			this.currentAthlete.setName(text);
		}
		
		// player number
		//
		else if(elementName.compareTo("Number") == 0)
		{
			this.currentAthlete.setNumber(text);
		}	
		
		// grade
		//
		else if(elementName.compareTo("Grade") == 0)
		{
			this.currentAthlete.setGrade(text);
		}	
		
		// height
		//
		else if(elementName.compareTo("Height") == 0)
		{
			this.currentAthlete.setHeight(text);
		}
		
		// weight
		//
		else if(elementName.compareTo("Weight") == 0)
		{
			this.currentAthlete.setWeight(text);
		}
		
		// positions
		//
		else if(elementName.compareTo("Positions") == 0)
		{
			this.currentAthlete.setPositions(text);
		}
		
		// if this is the end of the Player then add the currentLink to the 
		// links array
		else if(elementName.compareTo("Player") == 0)
		{
			this.athletes.add(currentAthlete);
		}
	}
}
