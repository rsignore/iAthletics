package com.appapro.menus;

import java.util.ArrayList;

import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.appapro.iathletics.R;
import com.appapro.iathletics.iAthleticsApplication;
import com.appapro.iathletics.activities.EventDetailsActivity;
import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.AppEvent;


//implements the calendar menu
	//
public abstract class CalendarExpandableMenu extends ExpandableMenuItem
{
	protected ArrayList<AppEvent> events;
	Boolean hasLoadedEvents = false;
	iAthleticsActivity activity;
	String menuName;
	
	/**
	 * @return the activity
	 */
	public iAthleticsActivity getActivity()
	{
		return activity;
	}

	public CalendarExpandableMenu(iAthleticsActivity activity, String menuName)
	{
		this.activity = activity;
		this.menuName = menuName;
		
	}
	
	@Override
	public View getChildView(int childPosition, View convertView)
	{
		return getChildView(childPosition, convertView, false);
	}
	
	public View getChildView(int childPosition, View convertView, Boolean showHomeAway)
	{
		LayoutInflater inflator = activity.getLayoutInflater();
		// A ViewHolder keeps references to children views to avoid unnecessary calls
        // to findViewById() on each row.
		//
        EventViewHolder holder; 

        // When convertView is not null, we can reuse it directly, there is no need
        // to reinflate it. We only inflate a new View when the convertView supplied
        // by ListView is null.
        // We also need to double check that the converted view is of suitable type
        // to meet our needs.
        //
        if (convertView == null || 
        		!this.convertViewIsTagedWith(convertView, EventViewHolder.class)) 
        {
            convertView = inflator.inflate(R.layout.upcoming_events_list_view, null);

            // Creates a ViewHolder and store references to the two children views
            // we want to bind data to.
            //
            holder = new EventViewHolder();
            holder.eventDate = (TextView) convertView.findViewById(R.id.eventDate);
            holder.teamSportName = (TextView) convertView.findViewById(R.id.teamSportName);
            holder.eventName = (TextView) convertView.findViewById(R.id.eventName);
            holder.eventTime = (TextView) convertView.findViewById(R.id.eventTime);
           	holder.icon = (ImageView) convertView.findViewById(R.id.icon);

            // save the tag on the convert view
            //
            convertView.setTag(holder);
        } 
        else 
        {
            // Get the ViewHolder back to get fast access to the TextView
            // and the ImageView.
        	//
            holder = (EventViewHolder) convertView.getTag();
        }

        // Bind the data efficiently with the holder.
        //

        AppEvent event = this.events.get(childPosition); 

        holder.teamSportName.setText(event.getTeamName() + " " +
        		event.getSportName());
        holder.eventName.setText(event.getEventName());
        
        if(!showHomeAway)
        {
        	holder.icon.setImageBitmap(event.getImage().getBitmap());
        }
        else
        {
        	holder.icon.setImageResource(event.getAwayEvent() == true ? R.drawable.car_green_48 : R.drawable.home_48);
        }

        holder.eventDate.setText(event.getEventDateFormatted("EEEE, MMMM d"));
        holder.eventTime.setText(event.getEventDateFormatted("h:mm aa"));

        return convertView;
	}

	@Override
	public View getGroupView(boolean isExpanded, View convertView)
	{
		// the standard ItemIcon works here
		//
		return getItemIconGroupView(activity.getLayoutInflater(), 
				menuName, activity.getResources().getDrawable(R.drawable.calendar48), 
				convertView);
	}

	@Override
	public int getChildrenCount()
	{
		return events != null ?events.size() : 0;
	}

	/* (non-Javadoc)
	 * @see com.appapro.iathletics.activities.HomeScreenActivity.ExpandableMenuItem#onGroupExpand()
	 */
	@Override
	public void onGroupExpand()
	{
		if(!this.hasLoadedEvents)
		{
			this.hasLoadedEvents = true;

			// load the events in the background
			//
			EventsLoader eventLoader = new EventsLoader();
			eventLoader.execute();
		}
	}
	
	protected abstract ArrayList<AppEvent>loadEvents();
	protected abstract void finishLoadEvents();
	
	private class EventsLoader extends AsyncTask<Void, Void, ArrayList<AppEvent>>
	{
		Dialog progressDlg;

		@Override
		protected ArrayList<AppEvent> doInBackground(Void... arg0)
		{
			return loadEvents();
		}

		/* (non-Javadoc)
		 * @see android.os.AsyncTask#onPostExecute(java.lang.Object)
		 */
		@Override
		protected void onPostExecute(ArrayList<AppEvent> events)
		{			
			progressDlg.dismiss();

			// save the list of events returned by the service
			//
			CalendarExpandableMenu.this.events = events;
			
			finishLoadEvents();
		}

		/* (non-Javadoc)
		 * @see android.os.AsyncTask#onPreExecute()
		 */
		@Override
		protected void onPreExecute()
		{
			super.onPreExecute();

			// display a progress dialog
			//
			this.progressDlg = ProgressDialog.show(activity, "", 
					activity.getString(R.string.loading), false);
		}	
	}

	/* (non-Javadoc)
	 * @see com.appapro.iathletics.types.ExpandableMenuItem#onChildClick(int)
	 */
	@Override
	public boolean onChildClick(int childPosition)
	{
		// set the application global variable with the selected event
		//
		iAthleticsApplication app = (iAthleticsApplication)activity.getApplication();

		app.setSelectedEvent(events.get(childPosition));

		// load the EventDetails Activity screen
		//
		Intent eventDetails = new Intent(activity, EventDetailsActivity.class);
		activity.startActivity(eventDetails);

		return true;
	}

	@Override
	public Object getChild(int childPosition)
	{
		return this.events.get(childPosition);
	}		
	
	static class EventViewHolder
	{
		ImageView icon;
		TextView eventDate;
		TextView teamSportName, eventName, eventTime;
	}
}
