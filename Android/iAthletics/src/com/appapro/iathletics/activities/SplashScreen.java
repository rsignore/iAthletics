package com.appapro.iathletics.activities;

import com.appapro.iathletics.R;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;

public class SplashScreen extends Activity 
{
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash);
        
        // wait a while on the background thread and then show the apps main screen
        //
        new SplashSleeper().execute();
        
    }
    
    private class SplashSleeper extends AsyncTask<Void, Void, Void>
    {

		protected Void doInBackground(Void...voids) 
		{
			try 
			{
				Thread.sleep(1000);
			} 
			catch (InterruptedException e) 
			{
			}
			return null;

		}
		
		protected void onPostExecute(Void result)
		{
	        // load the main screen
	        //
	        Intent homescreen = new Intent(SplashScreen.this, HomeScreenActivity.class);
	        startActivity(homescreen);
	        
	        // kill the splash screen
	        //
			SplashScreen.this.finish();
		}
    }
}
