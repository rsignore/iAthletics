package com.appapro.iathletics.activities;

import com.appapro.iathletics.R;
import com.appapro.iathletics.services.SplashService;
import com.appapro.iathletics.types.Ad;
import com.appapro.iathletics.types.iAthleticsImage;



import android.app.AlertDialog;
import android.app.Dialog;

import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;

import android.os.Bundle;
import android.view.View;

import android.widget.ImageView;

public class SplashAdActivity extends iAthleticsActivity
	implements View.OnClickListener, DialogInterface.OnClickListener
{
	private Ad splashAd;
	private ImageView adImage;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) 
    { 
    	super.onCreate(savedInstanceState);
    	
    	setContentView(R.layout.splash_ad);
    	
    	// save the ad image and it's on-click listener
    	//
    	this.adImage = (ImageView)this.findViewById(R.id.splashAd);
    	adImage.setOnClickListener(this);
    	
    	//set the close button event click listener
    	//
    	this.findViewById(R.id.closeButton).setOnClickListener(this);
    	
    }

    // implements the view onClick listener to capture the tapping of the
    // close button or the ad image itself
    //
	public void onClick(View arg0)
	{
		if(arg0.getId() == R.id.closeButton)
		{
			this.finish();
		}	
		else if(arg0.getId() == R.id.splashAd &&
				this.splashAd.getAdUrl() != null && this.splashAd.getAdUrl().length() > 0)
		{
			this.showDialog(iAthleticsActivity.VISIT_SPONSOR_DIALOG);
		}
	}
	
	@Override
	protected Boolean hasBannerAdOnActivity()
	{
		return false;
	}

	@Override
	void loadData()
	{
		SplashService svc = new SplashService(this);
		
		this.splashAd = svc.getNextSplash();
	}

	@Override
	void finishedLoadData()
	{
		iAthleticsImage image = new iAthleticsImage(
				this.splashAd.getImageUrl(), (iAthleticsActivity) this.getContext());
		this.adImage.setImageBitmap(image.getBitmap());
		
	}

	@Override
	protected Boolean loadDataOnCreate()
	{
		return true;
	}

	public void onClick(DialogInterface arg0, int arg1) 
	{
		Uri url = Uri.parse(this.splashAd.getAdUrl());
		Intent webIntent = new Intent(Intent.ACTION_VIEW, url);
		
		this.getContext().startActivity(webIntent);	
		
		// close this activity, the ad has done it's work
		//
		this.finish();
	}
	
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
				       .setPositiveButton(R.string.ok, this)
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
