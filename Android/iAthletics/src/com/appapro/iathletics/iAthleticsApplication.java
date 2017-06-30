package com.appapro.iathletics;
import com.appapro.iathletics.types.AppEvent;
import com.appapro.iathletics.types.NewsLink;

import android.app.Application;


public class iAthleticsApplication extends Application
{
	private long startTime = 0L;
	
	private AppEvent selectedEvent;
	private int teamId;
	
	private NewsLink selectedNewsLink;

	/**
	 * @return the selectedNewsLink
	 */
	public NewsLink getSelectedNewsLink()
	{
		return selectedNewsLink;
	}

	/**
	 * @param selectedNewsLink the selectedNewsLink to set
	 */
	public void setSelectedNewsLink(NewsLink selectedNewsLink)
	{
		this.selectedNewsLink = selectedNewsLink;
	}

	/**
	 * @return the teamId
	 */
	public int getTeamId()
	{
		return teamId;
	}

	/**
	 * @param teamId the teamId to set
	 */
	public void setTeamId(int teamId)
	{
		this.teamId = teamId;
	}

	/* (non-Javadoc)
	 * @see android.app.Application#onCreate()
	 */
	@Override
	public void onCreate()
	{
		this.startTime = System.currentTimeMillis();
		
		super.onCreate();
	}
	
	public long getStartTime()
	{
		return this.startTime;
	}

	/**
	 * @return the selectedEvent
	 */
	public AppEvent getSelectedEvent()
	{
		return selectedEvent;
	}

	/**
	 * @param selectedEvent the selectedEvent to set
	 */
	public void setSelectedEvent(AppEvent selectedEvent)
	{
		this.selectedEvent = selectedEvent;
	}
}
