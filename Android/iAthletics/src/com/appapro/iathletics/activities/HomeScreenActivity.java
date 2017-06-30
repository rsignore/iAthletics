package com.appapro.iathletics.activities;

import java.util.ArrayList;
import com.appapro.iathletics.R;
import com.appapro.iathletics.iAthleticsApplication;
import com.appapro.iathletics.services.AppInfoService;
import com.appapro.iathletics.services.NewsService;
import com.appapro.iathletics.services.SeasonsService;
import com.appapro.iathletics.services.SportsListService;
import com.appapro.iathletics.services.UpcomingEventsService;
import com.appapro.iathletics.types.AppEvent;
import com.appapro.iathletics.types.AppSeason;
import com.appapro.iathletics.types.NewsLink;
import com.appapro.iathletics.types.SportListItem;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;
import com.appapro.menus.CalendarExpandableMenu;
import com.appapro.menus.ExpandableMenuItem;

public class HomeScreenActivity extends iAthleticsActivity 
	implements ExpandableListView.OnChildClickListener, ExpandableListView.OnGroupExpandListener,
		ExpandableListView.OnGroupClickListener
{	
	// dialog identifiers
	//
	static final int MESSAGE_DIALOG = 1;

	// main menu view object
	//
	private ExpandableListView mainMenuView;
	private BaseExpandableListAdapter menuAdapter;
	
	// variables for the results of the appStatus call
	//
	private String status, appMessage;
	
	// members for the data displayed on this view
	// This data should be saved between configuration changes
	//
	ArrayList<AppSeason> 	seasons;
	ArrayList<ExpandableMenuItem> menuItems;
//	Boolean hasLoadedEvents = false;
	Boolean appIsAvailable = true;
	Boolean hasSplashAds = false;
	
	Boolean isRecreate = false;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {    
        setContentView(R.layout.homescreen);
        
        // get a pointer to the list view that acts as the app's main menu
        //
        mainMenuView = (ExpandableListView)this.findViewById(R.id.MainMenuView);
        
        mainMenuView.setAdapter(menuAdapter = new MenuListAdapter());
        mainMenuView.setOnChildClickListener(this);
        mainMenuView.setOnGroupClickListener(this);
        mainMenuView.setOnGroupExpandListener(this);
        
        // check to see if we are restoring from a config change.
        // if so. just load the data we got the last time, not need
        // to call the network or the cache again.
        //
        RestoreObject oldData = (RestoreObject) getLastNonConfigurationInstance();
        if(oldData != null)
        {
        	this.isRecreate = true;
        	
        	this.seasons = oldData.seasons;
 //       	this.hasLoadedEvents = oldData.hasLoadedEvents;
        	this.appIsAvailable = oldData.appIsAvailable;
        	this.menuItems = oldData.menuItems;
        }
        
        super.onCreate(savedInstanceState);
    }
    
    private void loadSeasonsData()
    {
    	SeasonsService seasonService = new SeasonsService(this);
    	
    	this.seasons = seasonService.getSeasons();
    }

    private void createMenu()
    {
    	// create the menu structure
    	//
    	this.menuItems = new ArrayList<ExpandableMenuItem>(6);
    	
    	// start with the seasons
    	//
    	for(int i = 0; i < this.seasons.size(); i++)
    	{
    		SeasonMenu seasonMenu = new SeasonMenu(this.seasons.get(i));
    		
    		this.menuItems.add(seasonMenu);
    	}
    	
    	// add the upcoming events
    	//
    	this.menuItems.add(new HomeCalendarMenu(this));
    	
    	// add the news & Information
    	//
    	this.menuItems.add(new NewsMenu());
    	
    	// add the support menu
    	//
    	this.menuItems.add(new SupportMenu());
    	
    	// redraw the menu
    	//
    	this.menuAdapter.notifyDataSetChanged();
    }
    
	@Override
	void loadData() 
	{
		// call the app information service to see if this is still a working app
		//
		AppInfoService appStat = new AppInfoService(this);
		appStat.getAppInfo();
		
		// save the results
		//
		this.status = appStat.getStatus();
		this.appMessage = appStat.getMessage();
		this.hasSplashAds = appStat.getHasSplashAds();
		
//		appStat.getCurrentVersionUrl();
		
		if(appStat.isAppAvailable())
		{
			//load the other data
			//
			// unlike the iPhone, we are not going to get the next event to display on the
			// main screen. Since we are using an expandable list, we will wait for the user to
			// expand the calendar to get the list of upcoming events
			// 
//			this.loadNewsData();		
			this.loadSeasonsData();
		}		
		else
		{
			this.appIsAvailable = false;
		}
	}

	@Override
	void finishedLoadData() 
	{
		// if the status returned in either unavailable or caching we need to tell tell
		// the user
		//
		if(this.status.compareTo(AppInfoService.APP_UNAVAILABLE_STR) == 0 ||
				this.status.compareTo(AppInfoService.APP_CACHING_STR) == 0)
		{
			this.showDialog(MESSAGE_DIALOG);
		}	
		
		// create the menu if we are good to go.
		//
		if(this.appIsAvailable)
		{
			createMenu();
			
			// show a splash ad if this app has splash ads available
			//
			if(this.hasSplashAds)
			{
				Intent splashAdIntent = new Intent(this, SplashAdActivity.class);
		        startActivity(splashAdIntent);
			}
		}
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onCreateDialog(int)
	 */
	@Override
	protected Dialog onCreateDialog(int id) 
	{
		Dialog dlg = null;
		switch(id)
		{
			case MESSAGE_DIALOG:
				// create a dialog box that displays the messaged returned by AppInfoService
				//
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setMessage(this.appMessage)
				       .setCancelable(false)
				       .setNegativeButton(R.string.ok, new DialogInterface.OnClickListener() {
				           public void onClick(DialogInterface dialog, int id) {
				                dialog.cancel();
				           }
				       });
				AlertDialog alert = builder.create();
				dlg = alert;
				break;
			default:
				// maybe the super class called me
				//
				dlg = super.onCreateDialog(id);
				break;
		}
		
		return dlg;
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onPrepareDialog(int, android.app.Dialog)
	 */
	@Override
	protected void onPrepareDialog(int id, Dialog dialog) 
	{
		switch(id)
		{
			case MESSAGE_DIALOG:
				// if for some reason the message has changed since the dialog was created
				// re-set the message
				//
				AlertDialog alert = (AlertDialog)dialog;
				alert.setMessage(this.appMessage);
				break;
			default:
				super.onPrepareDialog(id, dialog);
				break;
		}
	}
	
	// List adapter
	//
	private class MenuListAdapter extends BaseExpandableListAdapter
	{		
		public MenuListAdapter()
		{
			super();
		}
		
		public Object getChild(int groupPosition, int childPosition)
		{
			return HomeScreenActivity.this.menuItems.get(groupPosition).getChild(childPosition);
		}

		public long getChildId(int groupPosition, int childPosition)
		{
			return groupPosition<<(Long.SIZE/2) | childPosition;
		}
		
		public View getChildView(int groupPosition, int childPosition, boolean isLastChild, 
				View convertView, ViewGroup parent)
		{
			ExpandableMenuItem menuItem = HomeScreenActivity.this.menuItems.get(groupPosition);
			return menuItem.getChildView(childPosition, convertView);
		}

		public int getChildrenCount(int groupPosition)
		{
			return HomeScreenActivity.this.menuItems.get(groupPosition).getChildrenCount();
		}

		public Object getGroup(int groupPosition)
		{
			// return the menu item at the given position
			//
			return HomeScreenActivity.this.menuItems.get(groupPosition);
		}
		
		public int getGroupCount()
		{
			return HomeScreenActivity.this.menuItems != null ? 
					HomeScreenActivity.this.menuItems.size() : 0;
		}

		public long getGroupId(int groupPosition)
		{
			return groupPosition;
		}

		public View getGroupView(int groupPosition, boolean isExpanded, 
				View convertView, ViewGroup parent)
		{
			ExpandableMenuItem menuItem = HomeScreenActivity.this.menuItems.get(groupPosition);
			
            return menuItem.getGroupView(isExpanded, convertView);
		}

		public boolean hasStableIds()
		{
			return true;
		}

		public boolean isChildSelectable(int groupPosition, int childPosition)
		{
			return HomeScreenActivity.this.menuItems.get(groupPosition).isChildSelectable(childPosition);
		}
	}
	
	// this is the tap handler for the expandable list view
	//
	public boolean onChildClick(ExpandableListView parent, View v,
			int groupPosition, int childPosition, long id)
	{
		return(this.menuItems.get(groupPosition).onChildClick(childPosition));
	}

	// this handles the expansion of top menu categories
	//
	public boolean onGroupClick(ExpandableListView parent, View v,
			int groupPosition, long id)
	{
		return false;
	}

	public void onGroupExpand(int groupPosition)
	{
		// if the app is not available, there's no sense it doing any of the work on the menu
		//
		if(this.appIsAvailable)
		{
			// let the menu handle it's own expansion
			//
			menuItems.get(groupPosition).onGroupExpand();
		}
	}
	
	// RestoreObject is used to restore this activity when ever the configuration of 
	// the device changes. There is no reason to go and get the data again from the
	// the network of even the cache we can save our data and restore it on the change
	//
	private class RestoreObject
	{
		// members for the data displayed on this view
		//
		ArrayList<AppSeason> 	seasons;
		ArrayList<ExpandableMenuItem> menuItems;
		
		Boolean appIsAvailable = true;
	}
	
	@Override
	public Object onRetainNonConfigurationInstance ()
	{
		RestoreObject toSave = new RestoreObject();
		
		toSave.seasons = this.seasons;
		toSave.menuItems = this.menuItems;
		
		toSave.appIsAvailable = this.appIsAvailable;
		
		return toSave;
	}

	/* (non-Javadoc)
	 * @see com.appapro.iathletics.activities.iAthleticsActivity#loadDataOnCreate()
	 */
	@Override
	protected Boolean loadDataOnCreate()
	{
		return !this.isRecreate;
	}
	
	// implements the calendar menu
	//
	private class HomeCalendarMenu extends CalendarExpandableMenu
	{
		public HomeCalendarMenu(iAthleticsActivity activity)
		{
			super(activity, "Upcoming Events");
		}

		@Override
		protected ArrayList<AppEvent> loadEvents()
		{
			UpcomingEventsService ues = new UpcomingEventsService(HomeScreenActivity.this);

			return ues.getUpcomingEvents();
		}

		@Override
		protected void finishLoadEvents()
		{
			// tell the expandable list to re-draw itself to show the
			// upcoming events
			//
			HomeScreenActivity.this.menuAdapter.notifyDataSetChanged();
		}			
	}
	
	// implementation of the Seasons menu in the expandable list
	//
	private class SeasonMenu extends ExpandableMenuItem
	{
		private AppSeason season;
		Boolean hasLoadedSports = false;
		ArrayList<SportListItem> sports;
		
		public SeasonMenu(AppSeason season)
		{
			this.season = season;
		}
		
		/* (non-Javadoc)
		 * @see com.appapro.iathletics.activities.HomeScreenActivity.ExpandableMenuItem#onGroupExpand()
		 */
		@Override
		public void onGroupExpand()
		{
			if(!this.hasLoadedSports)
			{
				this.hasLoadedSports = true;

				// load the events in the background
				//
				SportsLoader loader = new SportsLoader();
				loader.execute();
			}
		}

		@Override
		public View getGroupView(boolean isExpanded, View convertView)
		{
			return this.getItemIconGroupView(HomeScreenActivity.this.getLayoutInflater(),
					this.season.getSeasonName() + " Teams", this.season.getImage().getBitmap(), convertView);
		}

		@Override
		public int getChildrenCount()
		{
			return this.sports != null ? this.sports.size() : 0;
		}

		@Override
		public View getChildView(int childPosition, View convertView)
		{
			return this.getItemIconChildView(HomeScreenActivity.this.getLayoutInflater(), sports.get(childPosition).getFullName(), 
					sports.get(childPosition).getImage().getBitmap(), convertView, View.VISIBLE);
		}

		@Override
		public Object getChild(int childPosition)
		{
			return this.sports != null ? this.sports.get(childPosition) : null;
		}
		
		private class SportsLoader extends AsyncTask<Void, Void, ArrayList<SportListItem>>
		{
			Dialog progressDlg;

			@Override
			protected ArrayList<SportListItem> doInBackground(Void... arg0)
			{
		    	SportsListService service = new SportsListService(HomeScreenActivity.this);
		    	
		    	return service.getSportsForSeason(SeasonMenu.this.season.getSeasonId());

			}

			/* (non-Javadoc)
			 * @see android.os.AsyncTask#onPostExecute(java.lang.Object)
			 */
			@Override
			protected void onPostExecute(ArrayList<SportListItem> sports)
			{			
				progressDlg.dismiss();
				
				// save the list of events returned by the service
				//
				SeasonMenu.this.sports = sports;

				// tell the expandable list to re-draw itself to show the
				// upcoming events
				//
				HomeScreenActivity.this.menuAdapter.notifyDataSetChanged();
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
				this.progressDlg = ProgressDialog.show(HomeScreenActivity.this, "", 
						getString(R.string.loading), false);
			}	
		}

		/* (non-Javadoc)
		 * @see com.appapro.iathletics.types.ExpandableMenuItem#onChildClick(int)
		 */
		@Override
		public boolean onChildClick(int childPosition)
		{
			// set the application global variable with the selected team
			//
			iAthleticsApplication app = (iAthleticsApplication)getApplication();
			
			app.setTeamId(this.sports.get(childPosition).getTeamId());
			
			// load the team Details Activity screen
	        //
	        Intent teamDetails = new Intent(HomeScreenActivity.this, TeamDetailActivity.class);
	        startActivity(teamDetails);
			
			return true;
		}
	}

	// implementation of the support menu in the expandable list
	//
	private class SupportMenu extends ExpandableMenuItem
	{
		// CONSTs for the support menu
		//
		private static final int SUPPORT_SHARE = 0;
		private static final int SUPPORT_SUPPORT = 1;
		
		private String supportMenuItems[];
		
		public SupportMenu()
		{
			super();
			
			supportMenuItems = HomeScreenActivity.this.getResources().getStringArray(R.array.sharingAndSupportMenuChoices);
		}
		
		@Override
		public View getChildView(int childPosition, View convertView)
		{
			return this.getItemIconChildView(HomeScreenActivity.this.getLayoutInflater(), supportMenuItems[childPosition], getResources().getDrawable(R.drawable.transparent48), convertView, View.INVISIBLE);
		}

		@Override
		public View getGroupView(boolean isExpanded, View convertView)
		{
			return this.getItemIconGroupView(HomeScreenActivity.this.getLayoutInflater(), "Sharing & Support", getResources().getDrawable(R.drawable.help48), convertView);
		}

		@Override
		public int getChildrenCount()
		{
			return supportMenuItems.length;
		}

		/* (non-Javadoc)
		 * @see com.appapro.iathletics.types.ExpandableMenuItem#onChildClick(int)
		 */
		@Override
		public boolean onChildClick(int childPosition)
		{
			String mailtoUrl = "mailto:";
			
			switch(childPosition)
			{
				case SUPPORT_SHARE:
					mailtoUrl += "?subject=" + 
							String.format(getString(R.string.shareWithFriendsEmailSubject), 
									getString(R.string.app_name)) +
							"&body=" + String.format(getString(R.string.shareWithFirendsEmailBody), 
									getString(R.string.app_name), 
									getString(R.string.iAthleticsLinkToApplication));
					break;
				case SUPPORT_SUPPORT:
					mailtoUrl += getString(R.string.iAthleticsSupportEmail) +
						"?subject=Technical support for Android " + getString(R.string.app_name);
			}
			
			// ask the OS to call the process for the mailto: URI
			//
			Uri url = Uri.parse(mailtoUrl);
			Intent webIntent = new Intent(Intent.ACTION_VIEW, url);
			startActivity(webIntent);
			
			return true;
		}

		@Override
		public Object getChild(int childPosition)
		{
			return this.supportMenuItems[childPosition];
		}
	}
	
	// implementation of the news menu in the expandable list
		//
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
				this.hasLoadedLinks = true;

				// load the events in the background
				//
				LinksLoader linksLoader = new LinksLoader();
				linksLoader.execute();
			}
		}
		
		@Override
		public View getChildView(int childPosition, View convertView)
		{
			return this.getItemIconChildView(HomeScreenActivity.this.getLayoutInflater(), newsLinks.get(childPosition).getLinkName(), 
					newsLinks.get(childPosition).getImage().getBitmap(), convertView, View.VISIBLE);
		}

		@Override
		public View getGroupView(boolean isExpanded, View convertView)
		{
			return this.getItemIconGroupView(HomeScreenActivity.this.getLayoutInflater(), "News & Information", 
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
						HomeScreenActivity.this.getApplication();
				
				app.setSelectedNewsLink(newsLink);
				
				Intent newsIntent = new Intent(HomeScreenActivity.this, 
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
		
		private class LinksLoader extends AsyncTask<Void, Void, ArrayList<NewsLink>>
		{
			Dialog progressDlg;

			@Override
			protected ArrayList<NewsLink> doInBackground(Void... arg0)
			{
		    	NewsService service = new NewsService(HomeScreenActivity.this);
		    	
		    	return service.getNewsLinks();

			}

			/* (non-Javadoc)
			 * @see android.os.AsyncTask#onPostExecute(java.lang.Object)
			 */
			@Override
			protected void onPostExecute(ArrayList<NewsLink> links)
			{			
				progressDlg.dismiss();
				
				// save the list of events returned by the service
				//
				NewsMenu.this.newsLinks = links;

				// tell the expandable list to re-draw itself to show the
				// upcoming events
				//
				HomeScreenActivity.this.menuAdapter.notifyDataSetChanged();
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
				this.progressDlg = ProgressDialog.show(HomeScreenActivity.this, "", 
						getString(R.string.loading), false);
			}	
		}
	}
}
