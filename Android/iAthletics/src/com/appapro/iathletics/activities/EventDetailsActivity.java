/**
 * 
 */
package com.appapro.iathletics.activities;

import com.appapro.iathletics.R;
import com.appapro.iathletics.iAthleticsApplication;
import com.appapro.iathletics.types.AppEvent;
import com.appapro.iathletics.types.AppVenu;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * @author robert
 *
 */
public class EventDetailsActivity extends iAthleticsActivity 
	implements OnClickListener
{	
	private AppEvent eventDetails;
	
	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		setContentView(R.layout.event_details);
		
		// get the data from a configuration change, if any
		//
		eventDetails = (AppEvent)getLastNonConfigurationInstance();
		
		if(eventDetails == null)
		{
			// get the event to display from global member variable on the application
			//
			eventDetails = ((iAthleticsApplication) getApplication()).getSelectedEvent();
		}
		
		// should not be null at this point
		//
		if(eventDetails != null)
		{
			ImageView icon = (ImageView)this.findViewById(R.id.icon);
			TextView teamSportName = (TextView)this.findViewById(R.id.teamSportName);
			TextView eventName = (TextView)this.findViewById(R.id.eventName);
			TextView eventDateTime = (TextView)this.findViewById(R.id.eventDateTime);
			TextView venuName = (TextView)this.findViewById(R.id.venuName);
			TextView address1 = (TextView)this.findViewById(R.id.address1);
			TextView address2 = (TextView)this.findViewById(R.id.address2);
			TextView address3 = (TextView)this.findViewById(R.id.address3);
			
			icon.setImageBitmap(eventDetails.getImage().getBitmap());
			teamSportName.setText(eventDetails.getTeamName() + " " + eventDetails.getSportName());
			eventName.setText(eventDetails.getEventName());
			
			String dateTimeString = eventDetails.getEventDateFormatted("EEEE, MMMM d 'at' h:mm a");
			eventDateTime.setText(dateTimeString);
			venuName.setText(eventDetails.getVenu().getVenuName());
			address1.setText(eventDetails.getVenu().getAddress1());
			address2.setText(eventDetails.getVenu().getAddress2());
			address3.setText(String.format("%s, %s %s", 
					eventDetails.getVenu().getCity(), eventDetails.getVenu().getState(),
					eventDetails.getVenu().getZip()));
			
		}
		
		//set the buttons's click listeners
		//
		this.findViewById(R.id.mapButton).setOnClickListener(this);
		this.findViewById(R.id.shareButton).setOnClickListener(this);
		
		// call the super iAthleticsActivity to set up
		// the ad image properly
		//
		super.onCreate(savedInstanceState);

	}

	@Override
	void loadData()
	{
		// TODO Auto-generated method stub
		
	}

	@Override
	void finishedLoadData()
	{
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see com.appapro.iathletics.activities.iAthleticsActivity#loadDataOnCreate()
	 */
	@Override
	protected Boolean loadDataOnCreate()
	{
		// TODO Auto-generated method stub
		return false;
	}

	public void onClick(View arg0)
	{
		switch(arg0.getId())
		{
			case R.id.mapButton:
			{
				// use the google maps API to launch a map of the location
				//
				AppVenu venu = eventDetails.getVenu();
				String uriString = "http://maps.google.com/?q=" + venu.getAddress1() + "," +
						venu.getCity() + "," + venu.getState() + "," + venu.getZip();
				Uri mapUri =  Uri.parse(uriString);
				
				Intent mapIntent = new Intent(Intent.ACTION_VIEW, mapUri);
				startActivity(mapIntent);
				break;
			}
			case R.id.shareButton:
			{
				AppVenu venu = eventDetails.getVenu();
				
				// set the subject line of the email
				//
				String uriString = "mailto:?subject=" + 
						String.format(getString(R.string.shareEventWithFriendsEmailSubject),
								getString(R.string.app_name), eventDetails.getTeamName(),
								eventDetails.getSportName(), eventDetails.getEventDateFormatted("EEEE, MMMM d"));
				// now set the body
				//
				uriString += "&body=" + 
						String.format(getString(R.string.shareEventWithFriendsEmailBody),
								getString(R.string.app_name), eventDetails.getTeamName(),
								eventDetails.getSportName(), venu.getVenuName(),
								eventDetails.getEventDateFormatted("EEEE, MMMM d '@' h:mm a"),
								String.format("%s, %s %s, %s", venu.getAddress1(),
										venu.getCity(), venu.getState(), venu.getZip()),
								String.format("http://maps.google.com/?q=%s,%s,%s,%s",
										venu.getAddress1(), venu.getCity(), venu.getState(), 
										venu.getZip()));
				
				Intent emailIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(uriString));
				startActivity(emailIntent);
				break;
			}
		}
	}
	
	@Override
	public Object onRetainNonConfigurationInstance ()
	{
		return this.eventDetails;
	}
}
