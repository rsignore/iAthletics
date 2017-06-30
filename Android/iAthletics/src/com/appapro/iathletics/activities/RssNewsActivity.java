package com.appapro.iathletics.activities;

import java.util.ArrayList;
import com.appapro.iathletics.R;
import com.appapro.iathletics.iAthleticsApplication;
import com.appapro.iathletics.services.RssService;
import com.appapro.iathletics.types.NewsLink;
import com.appapro.iathletics.types.RssItem;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

public class RssNewsActivity extends iAthleticsActivity implements OnItemClickListener
{
	// a pointer the the ListView
	//
	ListView articleView;
	RssFeedAdapter feedAdapter;

	// storage for the rss items in the feed
	//
	ArrayList<RssItem> rssItems;
	
	/* (non-Javadoc)
	 * @see com.appapro.iathletics.activities.iAthleticsActivity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		iAthleticsApplication app = (iAthleticsApplication)getApplication();
		NewsLink selectedLink = app.getSelectedNewsLink();
		
		setContentView(R.layout.rss_reader);
		
		// set the title of the view to the news feed we were given in the object
		//
		this.setTitle(selectedLink.getLinkName());
		
		// save a pointer to the list view that holds the articles
		//
		 articleView = (ListView) findViewById(R.id.articleView);
		 
		 feedAdapter = new RssFeedAdapter();
		 articleView.setAdapter(feedAdapter);
		 articleView.setOnItemClickListener(this);
		 
		 //read the RSS feed
		 //
		 RssUrlReader reader = new RssUrlReader();
		 reader.execute(selectedLink.getLinkUrl());
	 
		 // call the super class to handle the ads
		 //
		 super.onCreate(savedInstanceState);
	}

	@Override
	void loadData() {}

	@Override
	void finishedLoadData() {}

	@Override
	protected Boolean loadDataOnCreate()
	{
		// this view does not need the traditional data loading 
		//
		return false;
	}
	
	private class RssUrlReader extends AsyncTask<String, Void, ArrayList<RssItem>>
	{
		private Dialog dialog;

		@Override
		protected void onPostExecute(ArrayList<RssItem> rssItems) 
		{
			// get rid of the progress dialog
			//
			dialog.dismiss();
			
			RssNewsActivity.this.rssItems = rssItems;
			
			RssNewsActivity.this.feedAdapter.notifyDataSetChanged();
		}

		@Override
		protected void onPreExecute() 
		{
			// display a progress dialog
			//
			dialog = ProgressDialog.show(RssNewsActivity.this, "", 
					getString(R.string.loading), false);
		}

		@Override
		protected ArrayList<RssItem> doInBackground(String... arg0)
		{
			RssService svc = new RssService();
			
			ArrayList<RssItem> items = svc.getRssItems(arg0[0]);
			 
			return items; 
		}	
	}
	
	private class RssFeedAdapter extends BaseAdapter
	{
		public int getCount()
		{
			int retVal = 0;
			
			if(rssItems != null)
			{
				retVal = RssNewsActivity.this.rssItems.size();
			}
			
			return retVal;
		}

		public Object getItem(int childPosition)
		{
			return childPosition;
//			return RssNewsActivity.this.rssItems.get(childPosition);
		}

		public long getItemId(int childPosition)
		{
			return childPosition;
		}

		public View getView(int childPosition, View convertView, ViewGroup viewGroup)
		{
			// A ViewHolder keeps references to children views to avoid unnecessary calls
			// to findViewById() on each row.
			//
			RssItemViewHolder holder; 

			// When convertView is not null, we can reuse it directly, there is no need
			// to reinflate it. We only inflate a new View when the convertView supplied
			// by ListView is null.
			// We also need to double check that the converted view is of suitable type
			// to meet our needs.
			//
			if (convertView == null) 
			{
				convertView = RssNewsActivity.this.getLayoutInflater().
						inflate(R.layout.rss_news_item_list, null);

				// Creates a ViewHolder and store references to the two children views
				// we want to bind data to.
				//
				holder = new RssItemViewHolder();
				holder.pubDate = (TextView) convertView.findViewById(R.id.pubDate);
				holder.title = (TextView)convertView.findViewById(R.id.title);
				holder.description = (TextView)convertView.findViewById(R.id.description);

				// save the tag on the convert view
				//
				convertView.setTag(holder);
			} 
			else 
			{
				// Get the ViewHolder back to get fast access to the TextView
				// and the ImageView.
				//
				holder = (RssItemViewHolder) convertView.getTag();
			}

			// Bind the data efficiently with the holder.
			//
			RssItem item = RssNewsActivity.this.rssItems.get(childPosition);
			holder.description.setText(item.getDescription());
			holder.title.setText(item.getTitle());
			holder.pubDate.setText(item.getPubDateFormatted("EEEE',' MMMM d"));

			return convertView;
		}
	}
	
	private static class RssItemViewHolder
	{
		TextView pubDate;
		TextView title;
		TextView description;
	}

	public void onItemClick(AdapterView<?> parent, View view, int position, long id)
	{
		RssItem item = this.rssItems.get(position);
		// just call the devices default browser to
		// handle the web page.
		//
		Uri url = Uri.parse(item.getLink());
		Intent intent = new Intent(Intent.ACTION_VIEW, url);

		startActivity(intent);

	}
}
