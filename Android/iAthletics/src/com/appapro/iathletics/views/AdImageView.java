package com.appapro.iathletics.views;
import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.services.AdService;
import com.appapro.iathletics.types.Ad;
import com.appapro.iathletics.types.iAthleticsImage;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Handler;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.view.View;


public class AdImageView extends ImageView 
	implements View.OnClickListener, DialogInterface.OnClickListener
{
//	private Long lastLoad = 0L;
	private Ad ad;
	
	// constructors
	//
	public AdImageView(Context context)
	{
		super(context);
	}
	

	public AdImageView(Context context, AttributeSet attrs, int defStyle)
	{
		super(context, attrs, defStyle);
	}

	public AdImageView(Context context, AttributeSet attrs)
	{
		super(context, attrs);
	}
	
	
	public void loadNextAd(Boolean forceLoad)
	{
		// only call the network for a new ad if the view is visible
		// or we are called with the forceload flag set
		//
		if(this.isShown() || forceLoad)
		{
		// get the next ad from the service in the background
		// but display it on the foreground
		//
			AdLoader adLoader = new AdLoader();
			adLoader.execute((iAthleticsActivity)this.getContext());
		}
		else
		{
			// don't load an ad if the user can not see the view, but call
			// me again in 20 secs just in case I become visible
			//
			updateAdHandler.removeCallbacks(updateAdTask);
			updateAdHandler.postDelayed(updateAdTask, 20000);
		}
	
	}
	
	// AsyncTask for loading the image in the background
	//
	private class AdLoader extends AsyncTask<iAthleticsActivity, Void, Ad>
	{
		@Override
		protected Ad doInBackground(iAthleticsActivity... arg0)
		{
			Ad ad = null;
			
			// load an ad if we've never loaded one before
			// or if the last ad loaded is 20 seconds or older
			//
//			if(lastLoad < (System.currentTimeMillis() - 20000))
			{
				AdService adSvc = new AdService(arg0[0]);
				
				ad = adSvc.getNextAd();
			}
			return ad;
		}

		/* (non-Javadoc)
		 * @see android.os.AsyncTask#onPostExecute(java.lang.Object)
		 */
		@Override
		protected void onPostExecute(Ad result)
		{
			// did an ad come back and is there an image.
			//
			if(result != null && result.getImageUrl() != null)
			{
				AdImageView.this.ad = result;
				
				iAthleticsImage image = new iAthleticsImage(
						AdImageView.this.ad.getImageUrl(), (iAthleticsActivity) AdImageView.this.getContext());
				
				AdImageView.this.setImageBitmap(image.getBitmap());
				
				// the the auto-update handler to run an ad update again in 20 seconds
				//
				updateAdHandler.removeCallbacks(updateAdTask);
				updateAdHandler.postDelayed(updateAdTask, 20000);
			}
		}
	}

	// this listener is listening for the user's selection on the
	// dialog box that asked if they want to visit the ad's website
	//
	// this will only be called for the OK button
	//
	public void onClick(DialogInterface arg0, int arg1)
	{
		Uri url = Uri.parse(this.ad.getAdUrl());
		Intent webIntent = new Intent(Intent.ACTION_VIEW, url);
		
		this.getContext().startActivity(webIntent);
	}
	
	// This onClick listener is listening for a tap on the ad itself
	//
	public void onClick(View v)
	{
		// display a dialog box to the user if the ad had an
		// associated URL
		//
		if(this.ad != null && this.ad.getAdUrl() != null && this.ad.getAdUrl().length() > 0)
		{
			((Activity) this.getContext()).showDialog(iAthleticsActivity.VISIT_SPONSOR_DIALOG);
		}
	}
	
	// Members that automatically update the ad every 20 seconds
	//
	private Handler updateAdHandler = new Handler();
	
	// updateAdTask is called from the Handler class every 20 seconds
	//
	private Runnable updateAdTask = new Runnable()
	{
		public void run()
		{
			AdImageView.this.loadNextAd(false);
		}
	};

}
