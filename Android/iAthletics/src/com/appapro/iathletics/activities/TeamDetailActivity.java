package com.appapro.iathletics.activities;

import java.util.ArrayList;

import com.appapro.iathletics.R;
import com.appapro.iathletics.iAthleticsApplication;
import com.appapro.iathletics.services.TeamDetailService;
import com.appapro.iathletics.services.TeamRosterService;
import com.appapro.iathletics.services.TeamScheduleService;
import com.appapro.iathletics.types.AppEvent;
import com.appapro.iathletics.types.Athlete;
import com.appapro.iathletics.types.NewsLink;
import com.appapro.iathletics.types.TeamInfo;
import com.appapro.menus.CalendarExpandableMenu;
import com.appapro.menus.ExpandableMenuItem;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.TextView;

public class TeamDetailActivity extends iAthleticsActivity
	implements ExpandableListView.OnChildClickListener, ExpandableListView.OnGroupExpandListener,
		ExpandableListView.OnGroupClickListener
{
	private BaseExpandableListAdapter 		menuAdapter;
	private ExpandableListView 				teamMenu;
	private TeamInfo 						teamInfo;
	private ArrayList<ExpandableMenuItem> 	menuItems = new ArrayList<ExpandableMenuItem>(3);
	private ImageView						teamImage;
	Boolean isRecreate = false;
	
	/* (non-Javadoc)
	 * @see com.appapro.iathletics.activities.iAthleticsActivity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
        setContentView(R.layout.team_details);
        
        // get a pointer to the list view that acts as the app's main menu
        //
        teamMenu = (ExpandableListView)this.findViewById(R.id.teamMenuView);
        
        // get a pointer to the image view with the team image
        //
        teamImage = (ImageView)findViewById(R.id.teamPhoto);
        
        teamMenu.setAdapter(menuAdapter = new MenuAdapter());
        teamMenu.setOnChildClickListener(this);
        teamMenu.setOnGroupClickListener(this);
        teamMenu.setOnGroupExpandListener(this);
        
        // check to see if we are restoring from a config change.
        // if so. just load the data we got the last time, not need
        // to call the network or the cache again.
        //
        RestoreObject oldData = (RestoreObject) getLastNonConfigurationInstance();
        if(oldData != null)
        {
        	this.isRecreate = true;
        	
        	this.teamInfo = oldData.teamInfo;
        	this.menuItems = oldData.menuItems;
        	
        	reloadData();
        }
        
        super.onCreate(savedInstanceState);
	}
	
	private void reloadData()
	{

	}

	@Override
	void loadData()
	{
		TeamDetailService svc = new TeamDetailService(this);
		iAthleticsApplication app = (iAthleticsApplication) getApplication();
		
		this.teamInfo = svc.getTeamInfo(app.getTeamId());
	}

	private void createMenu()
	{
		this.menuItems.add(new RosterMenu());
		this.menuItems.add(new TeamEventsMenu(this, "Calendar & Results"));
		
		// only add the news menu if the team actually has news items
		//
		if(this.teamInfo.getNewsLinks().size() > 0)
		{
			this.menuItems.add(new NewsMenu());
		}
	}
	
	@Override
	void finishedLoadData()
	{
		createMenu();
		
		// load the team picture
		//
		if(this.teamInfo.getPhoto() != null)
		{
			this.teamImage.setImageBitmap(this.teamInfo.getPhoto().getBitmap());
		}
		
		// set the title bar text
		//
		setTitle(getString(R.string.app_name) + " " + 
				teamInfo.getTeamName() + " " + teamInfo.getSportName());
		
		// redraw the menu
    	//
    	this.menuAdapter.notifyDataSetChanged();
	}

	public boolean onGroupClick(ExpandableListView arg0, View arg1, int arg2,
			long arg3)
	{
		return false;
	}

	public void onGroupExpand(int groupPosition)
	{
		menuItems.get(groupPosition).onGroupExpand();
	}

	public boolean onChildClick(ExpandableListView parent, View v,
			int groupPosition, int childPosition, long id)
	{
		return(this.menuItems.get(groupPosition).onChildClick(childPosition));
	}
	
	@Override
	public Object onRetainNonConfigurationInstance ()
	{
		RestoreObject toSave = new RestoreObject();
		
		toSave.teamInfo = this.teamInfo;
		toSave.menuItems = this.menuItems;
		
		return toSave;
	}

	private class MenuAdapter extends BaseExpandableListAdapter
	{
		public Object getChild(int groupPosition, int childPosition)
		{
			return TeamDetailActivity.this.menuItems.
					get(groupPosition).getChild(childPosition);			
		}

		public long getChildId(int arg0, int arg1)
		{
			return 0;
		}

		public View getChildView(int groupPosition, int childPosition, boolean isLastChild, 
				View convertView, ViewGroup parent)
		{
			return TeamDetailActivity.this.menuItems.get(groupPosition).
					getChildView(childPosition, convertView);
		}

		public int getChildrenCount(int arg0)
		{
			return TeamDetailActivity.this.menuItems.get(arg0).getChildrenCount();
		}

		public Object getGroup(int arg0)
		{
			return TeamDetailActivity.this.menuItems.get(arg0);
		}

		public int getGroupCount()
		{
			int retVal = 0;
			
			if(TeamDetailActivity.this.menuItems != null)
			{
				retVal = TeamDetailActivity.this.menuItems.size();
			}
			
			return retVal;
		}

		public long getGroupId(int arg0)
		{
			return arg0;
		}

		public View getGroupView(int groupPosition, boolean isExpanded, 
				View convertView, ViewGroup parent)
		{
			return TeamDetailActivity.this.menuItems.get(groupPosition).
					getGroupView(isExpanded, convertView);
		}

		public boolean hasStableIds()
		{
			return true;
		}

		public boolean isChildSelectable(int groupPosition, int childPosition)
		{
			return TeamDetailActivity.this.menuItems.get(groupPosition).
					isChildSelectable(childPosition);
		}
	}
	
	private class RestoreObject
	{
		private TeamInfo 						teamInfo;
		private ArrayList<ExpandableMenuItem> 	menuItems;
	}

	@Override
	protected Boolean loadDataOnCreate()
	{
		return !this.isRecreate;
	}
	
	private class RosterMenu extends ExpandableMenuItem
	{
		ArrayList<Athlete> athletes;
		boolean hasLoadedAthletes = false;

		@Override
		public View getChildView(int childPosition, View convertView)
		{
			// A ViewHolder keeps references to children views to avoid unnecessary calls
			// to findViewById() on each row.
			//
			AthleteViewHolder holder; 

			// When convertView is not null, we can reuse it directly, there is no need
			// to reinflate it. We only inflate a new View when the convertView supplied
			// by ListView is null.
			// We also need to double check that the converted view is of suitable type
			// to meet our needs.
			//
			if (convertView == null || 
	     		!this.convertViewIsTagedWith(convertView, AthleteViewHolder.class)) 
			{
				convertView = TeamDetailActivity.this.getLayoutInflater().
	        		 inflate(R.layout.roster_list_view, null);

				// Creates a ViewHolder and store references to the two children views
				// we want to bind data to.
				//
				holder = new AthleteViewHolder();
				holder.number = (TextView)convertView.findViewById(R.id.number);
				holder.name = (TextView)convertView.findViewById(R.id.name);
				holder.year = (TextView)convertView.findViewById(R.id.year);
				holder.height = (TextView)convertView.findViewById(R.id.height);
				holder.weight = (TextView)convertView.findViewById(R.id.weight);
				holder.positions = (TextView)convertView.findViewById(R.id.positions);

				// save the tag on the convert view
				//
				convertView.setTag(holder);
			} 
			else 
			{	
				// Get the ViewHolder back to get fast access to the TextView
				// and the ImageView.
				//
				holder = (AthleteViewHolder) convertView.getTag();
			}

			Athlete athlete = this.athletes.get(childPosition);
			// Bind the data efficiently with the holder.
			//
			holder.number.setText(athlete.getNumber());
			holder.name.setText(athlete.getName()); 
			holder.year.setText(athlete.getGrade()); 
			holder.height.setText(athlete.getHeight()); 
			holder.weight.setText(athlete.getWeight()); 
			holder.positions.setText(athlete.getPositions());

			convertView.setMinimumHeight(50);
			return convertView;
		}
		
		@Override
		public void onGroupExpand()
		{
			if(!this.hasLoadedAthletes)
			{
				this.hasLoadedAthletes = true;

				// load the events in the background
				//
				AthleteLoader loader = new AthleteLoader();
				loader.execute();
			}
		}

		@Override
		public View getGroupView(boolean isExpanded, View convertView)
		{
			return this.getItemIconGroupView(
					TeamDetailActivity.this.getLayoutInflater(), "Team Roster", 
					getResources().getDrawable(R.drawable.page_table32), convertView);
		}

		@Override
		public int getChildrenCount()
		{
			int retVal = 0;
			
			if(athletes != null)
			{
				retVal = athletes.size();
			}
			
			return retVal;
		}

		@Override
		public Object getChild(int childPosition)
		{
			return athletes.get(childPosition);
		}
		
		private class AthleteLoader extends AsyncTask<Void, Void, ArrayList<Athlete>>
		{
			Dialog progressDlg;
			
			/* (non-Javadoc)
			 * @see android.os.AsyncTask#onPostExecute(java.lang.Object)
			 */
			@Override
			protected void onPostExecute(ArrayList<Athlete> result)
			{
				progressDlg.dismiss();
				
				// save the list of events returned by the service
				//
				RosterMenu.this.athletes = result;

				// tell the expandable list to re-draw itself to show the
				// upcoming events
				//
				TeamDetailActivity.this.menuAdapter.notifyDataSetChanged();
			}

			@Override
			protected ArrayList<Athlete> doInBackground(Void... arg0)
			{
		    	TeamRosterService service = new TeamRosterService(TeamDetailActivity.this);
		    	
		    	return service.getAthleties(TeamDetailActivity.this.teamInfo.getTeamId());
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
				this.progressDlg = ProgressDialog.show(TeamDetailActivity.this, "", 
						getString(R.string.loading), false);
			}	
		}

		/* (non-Javadoc)
		 * @see com.appapro.menus.ExpandableMenuItem#isChildSelectable(int)
		 */
		@Override
		public boolean isChildSelectable(int childPosition)
		{
			return false;
		}
	}
	
	private class TeamEventsMenu extends CalendarExpandableMenu
	{
		public TeamEventsMenu(iAthleticsActivity activity, String menuName)
		{
			super(activity, menuName);
		}
		
		/* (non-Javadoc)
		 * @see com.appapro.menus.ExpandableMenuItem#isChildSelectable(int)
		 */
		@Override
		public boolean isChildSelectable(int childPosition)
		{
			return !events.get(childPosition).pastEvent();
		}
	
		private View getResultView(int childPosition, View convertView)
		{
			LayoutInflater inflator = this.getActivity().getLayoutInflater();
			// A ViewHolder keeps references to children views to avoid unnecessary calls
	        // to findViewById() on each row.
			//
			ResultViewHolder holder; 

	        // When convertView is not null, we can reuse it directly, there is no need
	        // to reinflate it. We only inflate a new View when the convertView supplied
	        // by ListView is null.
	        // We also need to double check that the converted view is of suitable type
	        // to meet our needs.
	        //
	        if (convertView == null || 
	        		!this.convertViewIsTagedWith(convertView, ResultViewHolder.class)) 
	        {
	            convertView = inflator.inflate(R.layout.past_events_list_view, null);

	            // Creates a ViewHolder and store references to the two children views
	            // we want to bind data to.
	            //
	            holder = new ResultViewHolder();
	            holder.eventDate = (TextView) convertView.findViewById(R.id.eventDate);
	            holder.results = (TextView) convertView.findViewById(R.id.results);
	            holder.eventName = (TextView) convertView.findViewById(R.id.eventName);

	            // save the tag on the convert view
	            //
	            convertView.setTag(holder);
	        } 
	        else 
	        {
	            // Get the ViewHolder back to get fast access to the TextView
	            // and the ImageView.
	        	//
	            holder = (ResultViewHolder) convertView.getTag();
	        }

	        // Bind the data efficiently with the holder.
	        //

	        AppEvent event = this.events.get(childPosition); 

	        holder.eventName.setText(event.getEventName());
	        holder.eventDate.setText(event.getEventDateFormatted("EEEE, MMMM d"));
	        holder.results.setText(event.getResults());
	        
	        convertView.setBackgroundResource(R.color.dark_gray);

	        return convertView;
		}

		@Override
		public View getChildView(int childPosition, View convertView)
		{
			View retView = null;
			
			if(events.get(childPosition).pastEvent())
			{
				retView = this.getResultView(childPosition, convertView);
			}
			else
			{
				// call the version of get child view that allows me to specify we should 
				// show the home/away flag
				//
				retView = super.getChildView(childPosition, convertView, true);
			}
			
			return retView;
		}

		@Override
		public View getGroupView(boolean isExpanded, View convertView)
		{
			// A ViewHolder keeps references to children views to avoid unnecessary calls
			// to findViewById() on each row.
			//
			TeamEventsViewGroupHolder holder; 

			// When convertView is not null, we can reuse it directly, there is no need
			// to reinflate it. We only inflate a new View when the convertView supplied
			// by ListView is null.
			// We also need to double check that the converted view is of suitable type
			// to meet our needs.
			//
			if (convertView == null || 
					!this.convertViewIsTagedWith(convertView, TeamEventsViewGroupHolder.class)) 
			{
				convertView = TeamDetailActivity.this.getLayoutInflater().
						inflate(R.layout.schedule_results_group_view, null);

				// Creates a ViewHolder and store references to the two children views
				// we want to bind data to.
				//
				holder = new TeamEventsViewGroupHolder();
				holder.text = (TextView) convertView.findViewById(R.id.text);
				holder.icon = (ImageView) convertView.findViewById(R.id.icon);
				holder.results = (TextView) convertView.findViewById(R.id.results);
				
				// save the tag on the convert view
				//
				convertView.setTag(holder);
			} 
			else 
			{
				// Get the ViewHolder back to get fast access to the TextView
				// and the ImageView.
				//
				holder = (TeamEventsViewGroupHolder) convertView.getTag();
			}

			// Bind the data efficiently with the holder.
			//
			holder.text.setText("Calendar & Results");
			holder.icon.setImageResource(R.drawable.calendar48);
			
			// set the results line provided that the team has some results
			//
			String results = TeamDetailActivity.this.teamInfo.getOverallResults();
			if(results != null)
			{
				holder.results.setText(results);
				holder.results.setVisibility(View.VISIBLE);
			}
			else
			{
				holder.results.setVisibility(View.INVISIBLE);
			}

			return convertView;
		}

		@Override
		protected ArrayList<AppEvent> loadEvents()
		{
			TeamScheduleService svc = new TeamScheduleService(TeamDetailActivity.this);
			
			return svc.getTeamSchedule(TeamDetailActivity.this.teamInfo.getTeamId());
		}

		@Override
		protected void finishLoadEvents()
		{
			// tell the expandable list to re-draw itself to show the
			// upcoming events
			//
			TeamDetailActivity.this.menuAdapter.notifyDataSetChanged();
		}
	}
	
	private class NewsMenu extends ExpandableMenuItem
	{
		Boolean hasLoadedLinks = false;
		ArrayList<NewsLink> newsLinks;

		public NewsMenu()
		{
			super();

		}

		/* (non-Javadoc)
		 * @see com.appapro.iathletics.activities.HomeScreenActivity.ExpandableMenuItem#onGroupExpand()
		 */
		@Override
		public void onGroupExpand()
		{
			if(!this.hasLoadedLinks)
			{
				// the news links were actually loaded when the view Activity loaded
				//
				newsLinks = TeamDetailActivity.this.teamInfo.getNewsLinks();
				this.hasLoadedLinks = true;
				
				// redraw the menu
		    	//
		    	TeamDetailActivity.this.menuAdapter.notifyDataSetChanged();
			}
		}
		
		@Override
		public View getChildView(int childPosition, View convertView)
		{
			return this.getItemIconChildView(TeamDetailActivity.this.getLayoutInflater(), newsLinks.get(childPosition).getLinkName(), 
					newsLinks.get(childPosition).getImage().getBitmap(), convertView, View.VISIBLE);
		}

		@Override
		public View getGroupView(boolean isExpanded, View convertView)
		{
			return this.getItemIconGroupView(TeamDetailActivity.this.getLayoutInflater(), "News & Information", 
					getResources().getDrawable(R.drawable.news48), convertView);
		}

		@Override
		public int getChildrenCount()
		{
			return newsLinks != null ? newsLinks.size() : 0;
		}

		/* (non-Javadoc)
		 * @see com.appapro.iathletics.types.ExpandableMenuItem#onChildClick(int)
		 */
		@Override
		public boolean onChildClick(int childPosition)
		{
			NewsLink newsLink = newsLinks.get(childPosition);
			
			if(newsLink.getLinkType() == NewsLink.LINKTYPE_WEB)
			{		
				// just call the devices default browser to
				// handle the web page.
				//
				Uri url = Uri.parse(newsLink.getLinkUrl());
				Intent intent = new Intent(Intent.ACTION_VIEW, url);
				
			        startActivity(intent);
			}
			else if(newsLink.getLinkType() == NewsLink.LINKTYPE_RSS)
			{
				iAthleticsApplication app = (iAthleticsApplication)
						TeamDetailActivity.this.getApplication();
				
				app.setSelectedNewsLink(newsLink);
				
				Intent newsIntent = new Intent(TeamDetailActivity.this, 
						 RssNewsActivity.class);
			        startActivity(newsIntent);
			}
			
			return true;
		}

		@Override
		public Object getChild(int childPosition)
		{
			return this.newsLinks.get(childPosition);
		}
	}
	
	class TeamEventsViewGroupHolder
	{
		TextView text;
		ImageView icon;
		TextView results;
	}
	 
	class ResultViewHolder
	{
		TextView eventDate;
		TextView eventName;
		TextView results;
	}
	
	class AthleteViewHolder
	{
		TextView number;
		TextView name;
		TextView year, height, weight;
		TextView positions;
	}
}
