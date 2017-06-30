package com.appapro.iathletics.types;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import com.appapro.iathletics.activities.iAthleticsActivity;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

public class iAthleticsImage 
{
	private String imageUrl;
	private Bitmap theImage;
	private Context context; // this will be invalid when the orientation changes
	private long startTime;
	
	public iAthleticsImage(String imageUrl, iAthleticsActivity activity)
	{
		this.context = activity.getContext();
		this.startTime = activity.startTime();
		
		createImage(imageUrl);
	}
	
	private Bitmap createImage(String imageUrl)
	{
		this.imageUrl = imageUrl;
		
		return getBitmap();
	}
	
	public Bitmap getBitmap()
	{
		// check to see if we already loaded the image
		//
		if(this.theImage == null)
		{
			// get the image from cache 
			//
			InputStream urlData = loadFromRecientCache();
			
			if(urlData != null)
			{

				this.theImage = BitmapFactory.decodeStream(urlData);
			}
			else 
			{
				// load from the network if the cached image was stale
				// or not there
				try
				{
					URL url = new URL(this.imageUrl);

					//synchronous request on the thread called
					//
					urlData = new BufferedInputStream(url.openStream());
				}
				catch(Exception e)
				{
					
				}
				
				if(urlData != null)
				{	
					// we got data from the network, so cache it
					//
					cacheImageData(urlData);
				}

				// at this point we have either just read the file from the network
				// and cached it or we need to use what ever is in the cache
				//
				urlData = loadCachedImage();
				if(urlData != null)
				{
					this.theImage = BitmapFactory.decodeStream(urlData);
				}
			}
		}
		
		return this.theImage;
	}

	private InputStream loadFromRecientCache()
	{
		InputStream retval = null;
		
		String filePath = getCacheFileName();
		File file = new File(filePath);
		
		if(file.exists())
		{
			// check to see if we created the cache
			//
			if(file.lastModified() > this.startTime)
			{
				retval = loadCachedImage();
			}

		}
		else
		{
			retval = null;
		}
			
		return retval;	
	}

	private InputStream loadCachedImage()
	{
		BufferedInputStream retval = null;
		
		String dataPath = getCacheFileName();
		File file = new File(dataPath);
		
		if (file.exists()) 
		{
			try 
			{
				retval = new BufferedInputStream(new FileInputStream(file));
			} 
			catch (FileNotFoundException e) 
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return retval;
	}

	// this will create a new cached file in the cache directory
	// with the data specified in inStream
	//
	private Boolean cacheImageData(InputStream inStream)
	{
	    String dataPath = getCacheFileName();
	    File newFile = new File(dataPath);
	    Boolean retval = false;
	    
	    // delete the file if it exists.
	    //
	    newFile.delete();
	    
	    // now create the file
	    //
	    try {
	    	newFile.createNewFile();
	    	
	    	BufferedOutputStream buf = new BufferedOutputStream(new FileOutputStream(newFile));
	    	
	    	byte[] buffer = new byte[1024];
	    	int bytesRead;
	    	
	    	while((bytesRead = inStream.read(buffer)) != -1)
	    	{
	    		buf.write(buffer, 0, bytesRead);
	    	}
	    	
	    	buf.close();		
	    	
	    	retval = true;
	    }
	    catch(IOException e) {
	    	retval = false;
	    }
		
		return retval;
	}

	private String getCacheFileName()
	{
		// shorten the file name to what's ever after the last slash
		// include the last slash too.
		//
		String fileName = context.getCacheDir() +  
				imageUrl.substring(this.imageUrl.lastIndexOf("/")) + ".img";
		
		return fileName;
	}
		
}
