package com.appapro.iathletics.services;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

import android.content.Context;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import com.appapro.iathletics.R;
import com.appapro.iathletics.activities.iAthleticsActivity;

public abstract  class iAthleticsService 
{
	private BufferedInputStream xmlData;
	private iAthleticsActivity activity;
	
	protected iAthleticsActivity getActivity()
	{
		return activity;
	}
	
	private Boolean networkAvailable;
	
	// getters and setters
	//
	public Boolean isNetworkAvailable() 
	{
		return networkAvailable;
	}
	
	protected long getStartTime()
	{
		return activity.startTime();
	}
	
	protected Context getContext()
	{
		return activity.getContext();
	}

	public iAthleticsService(iAthleticsActivity activity)
	{
		super();
		
		// save some information about the activity we are associated with
		// we will need it later
		//
		this.activity = activity;
	}
	
	private String getDeviceIdString()
	{
		String deviceId = Uri.encode(Build.MODEL) + ":" + 
				Uri.encode(Build.VERSION.RELEASE) + ":" /* +
				Uri.encode(Settings.Secure.ANDROID_ID)*/;
		
		String serialNo = Settings.Secure.getString(activity.getContentResolver(), Settings.Secure.ANDROID_ID);
		
		if(serialNo == null)
		{
			// make a 15 digit unique ID up based upon the data in the Build class
			//
			serialNo = "35"
					+ // we make this look like a valid IMEI
					Build.BOARD.length() % 10 + Build.BRAND.length() % 10
					+ Build.CPU_ABI.length() % 10 + Build.DEVICE.length() % 10
					+ Build.DISPLAY.length() % 10 + Build.HOST.length() % 10
					+ Build.ID.length() % 10 + Build.MANUFACTURER.length() % 10
					+ Build.MODEL.length() % 10 + Build.PRODUCT.length() % 10
					+ Build.TAGS.length() % 10 + Build.TYPE.length() % 10
					+ Build.USER.length() % 10; 
		}
		
		deviceId += serialNo;
		
		return deviceId;
	}
	
	private Boolean cacheResultOfService(String serviceName, String parameters)
	{	
	    String dataPath = getCacheFileName(serviceName, parameters);
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
	    	
	    	while((bytesRead = xmlData.read(buffer)) != -1)
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
	
	protected void requestService(String serviceName, String parameters)
	{
		requestService(serviceName, parameters, true);
	}
	
	protected void requestService(String serviceName, String parameters, 
			Boolean useCacheIfAvailable)
	{
		// assume the network is working
		//
		this.networkAvailable = true;
		
		if(!useCacheIfAvailable || !loadFromRecientCache(serviceName, parameters))
		{
			// build the URL string starting with the service URL
			//
			String urlString = getContext().getString(R.string.iAthleticsServiceUrl);

			//append the service name to call
			//
			urlString += serviceName;
			
			// add the ? and the appId parameter
			//
			urlString += "?appId=" + getContext().getString(R.string.iAthleticsAppId);
			
			// add the device Id
			//
			urlString += "&deviceId=" + getDeviceIdString();
			
			// add parameters if any
			//
			urlString += "&" + parameters;
			
			try {
				URL url = new URL(urlString);
				
				// create a stream from the url so we can parse it
				//
				this.xmlData = new BufferedInputStream(url.openStream());
				
				this.cacheResultOfService(serviceName, parameters);
				
				// the trick here is that we have just created a cache file
				// so we can just parse that file
				//
			} 
			catch (MalformedURLException e) // happens on new URL()	
			{ 
				// need to look at this possibility in the debugger. Should not happen
				//
				this.networkAvailable = false;

			}
			catch (IOException e) 
			{
				// there is a problem with the network
				// set the network available flag to unavailable so that if 
				// somebody wants to know the availability of live connection they can
				//
				this.networkAvailable = false;
			} 
	
			// at this point use the cache because we either just read it from the network or
			// we are forced to use an old cache
			
			this.loadFromCacheService(serviceName, parameters);
		}
		
		this.parseData();
	}
	
	private String getCacheFileName(String serviceName, String parameters)
	{
		// add the full path to the file name
		//
		String actualFileName = getContext().getCacheDir() + "/" + serviceName;
		
		// if there are parameters then add them to the file name
		//
		if(parameters != null)
		{
			actualFileName += parameters;
		}
		
		// add the extension
		//
		actualFileName += ".xml";
		
		return actualFileName;
	}
	
	private Boolean loadFromCacheService(String serviceName, String parameters)
	{
		Boolean retval = false;
				
		String dataPath = getCacheFileName(serviceName, parameters);
		File file = new File(dataPath);
		
		if (file.exists()) 
		{
			try 
			{
				this.xmlData = new BufferedInputStream(new FileInputStream(file));
				
				retval = true;
			} 
			catch (FileNotFoundException e) 
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return retval;
	}
	
	private Boolean loadFromRecientCache(String serviceName, String parameters)
	{
		Boolean retval = false;
		
		String filePath = getCacheFileName(serviceName, parameters);
		File file = new File(filePath);
		
		if(file.exists())
		{
			// check to see if we created the cache
			//
			if(file.lastModified() > this.getStartTime())
			{
				retval = loadFromCacheService(serviceName, parameters);
			}

		}
		else
		{
			retval = false;
		}
			
		return retval;	
	}
	
	private void parseData()
	{
		try
		{
			// Get a SAXParser from the SAXPArserFactory. 
			//
			SAXParserFactory spf = SAXParserFactory.newInstance();
			SAXParser sp = spf.newSAXParser();
			// Get the XMLReader of the SAXParser we created.
			//
			XMLReader xr = sp.getXMLReader();
	        // Create a new ContentHandler and apply it to the XML-Reader
	        //
	        iAthleticsHandler handler = new iAthleticsHandler();
	        xr.setContentHandler(handler);		
	        
	        xr.parse(new InputSource(this.xmlData));
	    }
		catch(IOException e)
		{
			
		}
		catch(SAXException e)
		{
		} catch (ParserConfigurationException e) {

			e.printStackTrace();
		}
	}
	
	protected class iAthleticsHandler extends DefaultHandler
    {
		String currentString;

		@Override
		public void characters(char[] ch, int start, int length) throws SAXException 
		{
			currentString += new String(ch, start, length);	
		}

		@Override
		public void endElement(String uri, String localName, String qName) throws SAXException 
		{
			iAthleticsService.this.elementEnd(localName, currentString);
		}

		@Override
		public void startElement(String uri, String localName, String qName,
				Attributes attributes) throws SAXException 
		{
			currentString = "";
			iAthleticsService.this.elementStart(localName);
		}        
		
    }
	
	protected void preParse() {}
	protected void postParse() {}
	abstract protected void elementStart(String elementName);
	abstract protected void elementEnd(String elementName, String text);

}
