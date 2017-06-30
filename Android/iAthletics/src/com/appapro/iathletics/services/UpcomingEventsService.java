/**
 * 
 */
package com.appapro.iathletics.services;

import java.util.ArrayList;
import java.util.Collections;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.AppEvent;

/**
 * @author robert
 *
 */
public class UpcomingEventsService extends NextEventService
{
	private static final String EVENTS_TAG = "Events";
	private static final String EVENT_TAG = "Event"; 
	
	protected ArrayList<AppEvent>	events;

	public UpcomingEventsService(iAthleticsActivity activity)
	{
		super(activity);

	}
	
	public ArrayList<AppEvent> getUpcomingEvents()
	{
		this.requestService("GetUpcommingEvents", null);
		
		Collections.sort(this.events);
		return this.events;
	}

	/* (non-Javadoc)
	 * @see com.appapro.iathletics.services.NextEventService#elementStart(java.lang.String)
	 */
	@Override
	protected void elementStart(String elementName)
	{
		// allocate and event array if the tag is the Events (with an S) tag
		//
		if(elementName.compareTo(EVENTS_TAG) == 0)
		{
			this.events = new ArrayList<AppEvent>(50);
		}
		else
		{
			super.elementStart(elementName);
		}
	}

	/* (non-Javadoc)
	 * @see com.appapro.iathletics.services.NextEventService#elementEnd(java.lang.String, java.lang.String)
	 */
	@Override
	protected void elementEnd(String elementName, String text)
	{
		// check to see if we got all the data for the event.
		// if so, then add it to the event array
		//
		if(elementName.compareTo(EVENT_TAG) == 0)
		{
			this.events.add(this.nextEvent);
		}
		else
		{
			super.elementEnd(elementName, text);
		}
	}

}
