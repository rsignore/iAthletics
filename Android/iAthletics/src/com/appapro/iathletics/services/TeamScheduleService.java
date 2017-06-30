package com.appapro.iathletics.services;

import java.util.ArrayList;
import java.util.Collections;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.AppEvent;

// this service class works a little different than the others
// it basically uses the parsing code from it's super class
// but calls a different service.
//
public class TeamScheduleService extends UpcomingEventsService
{

	public TeamScheduleService(iAthleticsActivity activity)
	{
		super(activity);
	}
	
	public ArrayList<AppEvent> getTeamSchedule(int teamId)
	{
		String parameters = "teamId=" + Integer.toString(teamId);
		
		this.requestService("GetCompleteTeamSchedule", parameters);
		
		Collections.sort(events);
		return events;
	}
}
