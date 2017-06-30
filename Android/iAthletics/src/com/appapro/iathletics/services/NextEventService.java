package com.appapro.iathletics.services;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.AppEvent;
import com.appapro.iathletics.types.iAthleticsImage;

public class NextEventService extends iAthleticsService
{	
	
	protected AppEvent nextEvent;
	
	public NextEventService(iAthleticsActivity activity)
	{
		super(activity);
	}
	
	public AppEvent getNextEvent()
	{
		this.requestService("GetNextEvent", null);
		
		return this.nextEvent;
	}

	protected void elementStart(String elementName)
	{
		// prepare to receive new event Info
		//
		if(elementName.compareTo("Event") == 0)
		{
			this.nextEvent = new AppEvent();
		}
	}

	protected void elementEnd(String elementName, String text)
	{
		// is this the event id
		//
		if(elementName.compareTo("eventId") == 0)
		{
			this.nextEvent.setEventId(Integer.valueOf(text));
		}
		
		// event date and time
		//
		else if(elementName.compareTo("EventDateTime") == 0)
		{
			SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
			
			try
			{
				this.nextEvent.setEventDateTime(dateFormatter.parse(text));
			}
			catch (ParseException e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if(elementName.compareTo("TeamName") == 0)
		{
			this.nextEvent.setTeamName(text);
		}
		
		else if(elementName.compareTo("SportName") == 0)
		{
			this.nextEvent.setSportName(text);
		}
		
		else if(elementName.compareTo("EventName") == 0)
		{
			this.nextEvent.setEventName(text);
		}
		else if(elementName.compareTo("IconUrl") == 0)
		{
			this.nextEvent.setImage(new iAthleticsImage(text, getActivity()));
		}
		else if(elementName.compareTo("AwayEvent") == 0)
		{
			this.nextEvent.setAwayEvent(Boolean.valueOf(text));
		}
		else if(elementName.compareTo("ConferenceEvent") == 0)
		{
			this.nextEvent.setConferenceEvent(Boolean.valueOf(text));
		}
		else if(elementName.compareTo("Notes") == 0)
		{
			this.nextEvent.setNote(text);
		}

		else if(elementName.compareTo("Results") == 0)
		{
			this.nextEvent.setResults(text);
		}
		
		// parse the venu information
		//
		else if(elementName.compareTo("Address1") == 0)
		{
			this.nextEvent.getVenu().setAddress1(text);
		}
		else if(elementName.compareTo("Address2") == 0)
		{
			this.nextEvent.getVenu().setAddress2(text);
		}	
		else if(elementName.compareTo("City") == 0)
		{
			this.nextEvent.getVenu().setCity(text);
		}
		else if(elementName.compareTo("State") == 0)
		{
			this.nextEvent.getVenu().setState(text);
		}
		else if(elementName.compareTo("Zip") == 0)
		{
			this.nextEvent.getVenu().setZip(text);
		}
		else if(elementName.compareTo("WebUrl") == 0)
		{
			this.nextEvent.getVenu().setWebUrl(text);
		}
		else if(elementName.compareTo("VenuName") == 0)
		{
			this.nextEvent.getVenu().setVenuName(text);
		}
	}
}
