package com.appapro.iathletics.activities;

import com.appapro.iathletics.R;
import com.appapro.iathletics.iAthleticsApplication;
import com.appapro.iathletics.views.AdImageView;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;


public abstract class iAthleticsActivity extends Activity
{
	public static final int VISIT_SPONSOR_DIALOG = 5000;
	
	private AdImageView	adView;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) 
	{
		super.onCreate(savedInstanceState);
		
		// load the data into the activity's view
		//
		if(loadDataOnCreate())
		{
			iAthleticsDataLoader dataloader = new iAthleticsDataLoader();
			dataloader.execute();
		}
		
		//find the ad image view and save a pointer to it
		//
		if(this.hasBannerAdOnActivity())
		{
			adView = (AdImageView) this.findViewById(R.id.adImageView);
			adView.setOnClickListener(adView);
			adView.loadNextAd(true);
		}
	}
	

	public Context getContext() 
	{
		return this;
	}

	public long startTime() 
	{
		return ((iAthleticsApplication) this.getApplication()).getStartTime();
	}
	
	// ABSTRACT methods that must be implemented by

	// this method is called by onCreate to load any needed
	// data. It is called on a background thread. at the end of
	// the implemented method call finishLoadData on the main thread.
	//
	abstract void loadData();

	// this method is called when the background data loading
	// process has completed. It is called on the UI thread
	//
	abstract void finishedLoadData();
	
	// this method is called to find it if we should load data
	// during onCreate.
	//
	protected abstract Boolean loadDataOnCreate();
	
	// override the method if the subclass activity does not have a banner ad on it
	//
	protected Boolean hasBannerAdOnActivity()
	{
		return true;
	}

	private class iAthleticsDataLoader extends AsyncTask<Void, Void, Void>
	{
		ProgressDialog dialog;

		@Override
		protected Void doInBackground(Void... arg0) 
		{
			// tell the implementing class it's time to load data
			//
			loadData();

			return null;
		}

		@Override
		protected void onPostExecute(Void result) 
		{
			super.onPostExecute(result);

			// get rid of the progress dialog
			//
			dialog.dismiss();

			// tell the implementing class that the data load is done
			//
			finishedLoadData();
		}

		@Override
		protected void onPreExecute() 
		{
			super.onPreExecute();

			// display a progress dialog
			//
			dialog = ProgressDialog.show(iAthleticsActivity.this, "", 
					getString(R.string.loading), false);
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
			case iAthleticsActivity.VISIT_SPONSOR_DIALOG:
				// create a dialog box that asks the user if they want to visit the sponsor's website
				//
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setMessage(getString(R.string.visit_website))
				       .setCancelable(false)
				       .setPositiveButton(R.string.ok, this.adView)
				       .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
				           public void onClick(DialogInterface dialog, int id) {
				                dialog.cancel();
				           }
				       });
				AlertDialog alert = builder.create();
				dlg = alert;
				break;
			default:
				dlg = super.onCreateDialog(id);
				break;
		}
		
		return dlg;
	}
}
