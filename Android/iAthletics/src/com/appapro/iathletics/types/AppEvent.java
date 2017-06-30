package com.appapro.iathletics.types;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class AppEvent implements Comparable<AppEvent>
{
	private Integer			eventId;
	private Date			eventDateTime;
	private String			teamName;
	private String			sportName;
	private String			eventName;
	private iAthleticsImage	image;
	private Boolean 		awayEvent;
	private Boolean			conferenceEvent;
	private AppVenu			venu;
	private String			note;
	private String			results;
	/**
	 * @return the eventId
	 */
	public Integer getEventId()
	{
		return eventId;
	}
	/**
	 * @param eventId the eventId to set
	 */
	public void setEventId(Integer eventId)
	{
		this.eventId = eventId;
	}
	/**
	 * @return the eventDateTime
	 */
	public Date getEventDateTime()
	{
		return eventDateTime;
	}
	/**
	 * @param eventDateTime the eventDateTime to set
	 */
	public void setEventDateTime(Date eventDateTime)
	{
		this.eventDateTime = eventDateTime;
	}
	/**
	 * @return the teamName
	 */
	public String getTeamName()
	{
		return teamName;
	}
	/**
	 * @param teamName the teamName to set
	 */
	public void setTeamName(String teamName)
	{
		this.teamName = teamName;
	}
	/**
	 * @return the sportName
	 */
	public String getSportName()
	{
		return sportName;
	}
	/**
	 * @param sportName the sportName to set
	 */
	public void setSportName(String sportName)
	{
		this.sportName = sportName;
	}
	/**
	 * @return the eventName
	 */
	public String getEventName()
	{
		return eventName;
	}
	/**
	 * @param eventName the eventName to set
	 */
	public void setEventName(String eventName)
	{
		this.eventName = eventName;
	}
	/**
	 * @return the image
	 */
	public iAthleticsImage getImage()
	{
		return image;
	}
	/**
	 * @param image the image to set
	 */
	public void setImage(iAthleticsImage image)
	{
		this.image = image;
	}
	/**
	 * @return the awayEvent
	 */
	public Boolean getAwayEvent()
	{
		return awayEvent;
	}
	/**
	 * @param awayEvent the awayEvent to set
	 */
	public void setAwayEvent(Boolean awayEvent)
	{
		this.awayEvent = awayEvent;
	}
	/**
	 * @return the conferenceEvent
	 */
	public Boolean getConferenceEvent()
	{
		return conferenceEvent;
	}
	/**
	 * @param conferenceEvent the conferenceEvent to set
	 */
	public void setConferenceEvent(Boolean conferenceEvent)
	{
		this.conferenceEvent = conferenceEvent;
	}
	/**
	 * @return the venu
	 */
	public AppVenu getVenu()
	{
		return venu;
	}

	/**
	 * @return the note
	 */
	public String getNote()
	{
		return note;
	}
	/**
	 * @param note the note to set
	 */
	public void setNote(String note)
	{
		this.note = note;
	}
	/**
	 * @return the results
	 */
	public String getResults()
	{
		return results;
	}
	/**
	 * @param results the results to set
	 */
	public void setResults(String results)
	{
		this.results = results;
	}
	
	// allocate space for the venu
	//
	public AppEvent()
	{
		this.venu = new AppVenu();
	}
	
	// this method is used to compare the events times of 2 events
	// It is used to sort events by their times
	//
	public int compareTo(AppEvent otherEvent)
	{
		return this.eventDateTime.compareTo(otherEvent.eventDateTime);
	}
	
	public String getEventDateFormatted(String asFormat)
	{
		String dateStr = null;
		SimpleDateFormat formatter = new SimpleDateFormat();
		formatter.applyPattern(asFormat);

		dateStr = formatter.format(this.eventDateTime);

		return dateStr;
	}
	
	public Boolean pastEvent()
	{
		GregorianCalendar midnight = new GregorianCalendar();
		GregorianCalendar evtAsCal = new GregorianCalendar();
		
		// convert the event's date to a Calendar date for manipulation
		//
		evtAsCal.setTime(this.getEventDateTime());
		
		// an event is considered in the past if it occurred earlier 
		// than midnight on the current day
		//
		midnight.setTimeInMillis(System.currentTimeMillis());
		midnight.set(Calendar.HOUR, 0);
		midnight.set(Calendar.MINUTE, 0);
		midnight.set(Calendar.SECOND, 0);
		
		int compVal = evtAsCal.compareTo(midnight);
		return  compVal < 0;
	}

}
