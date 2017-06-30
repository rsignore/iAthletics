package com.appapro.iathletics.services;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import com.appapro.iathletics.types.RssItem;

public class RssService
{
	ArrayList<RssItem> rssItems = new ArrayList<RssItem>(10);
	RssItem				curItem;
	
	public ArrayList<RssItem> getRssItems(String urlStr)
	{
		try
		{
			BufferedInputStream rssStream;
			URL url = new URL(urlStr);

			// create a stream from the url so we can parse it
			//
			rssStream = new BufferedInputStream(url.openStream());
			
			this.parse(rssStream);
		}
		catch(Exception e) // thrown by URL and openStream
		{
//			didError = true;
//			errMsg = e.getMessage();
		}
		
		return rssItems;
	}
	
	private void parse(InputStream rssFeed)
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
			RssHandler handler = new RssHandler();
			xr.setContentHandler(handler);		
        
			xr.parse(new InputSource(rssFeed));
		}
		catch(Exception e)
		{
//			didError = true;
//			errMsg = e.getMessage();
		}
	}
	
	private class RssHandler extends DefaultHandler
	{
		String currentString;
		RssItem curItem;
		Boolean inItem = false;

		/* (non-Javadoc)
		 * @see org.xml.sax.helpers.DefaultHandler#characters(char[], int, int)
		 */
		@Override
		public void characters(char[] ch, int start, int length) throws SAXException
		{
			currentString += new String(ch, start, length);	
		}

		/* (non-Javadoc)
		 * @see org.xml.sax.helpers.DefaultHandler#endElement(java.lang.String, java.lang.String, java.lang.String)
		 */
		@Override
		public void endElement(String uri, String localName, String qName) throws SAXException
		{
			if(inItem)
			{
				if(localName.compareTo("title") == 0)
				{
					curItem.setTitle(currentString);
				}
				else if(localName.compareTo("link") == 0)
				{
					curItem.setLink(currentString);
				}
				else if(localName.compareTo("description") == 0)
				{
					curItem.setDescription(currentString);
				}
				else if(localName.compareTo("pubDate") == 0)
				{
					curItem.setPubDate(currentString);
				}
				else if(localName.compareTo("item") == 0)
				{
					inItem = false;
					rssItems.add(curItem);
				}
			}	
		}

		/* (non-Javadoc)
		 * @see org.xml.sax.helpers.DefaultHandler#startElement(java.lang.String, java.lang.String, java.lang.String, org.xml.sax.Attributes)
		 */
		@Override
		public void startElement(String uri, String localName, String qName,
				Attributes attributes) throws SAXException
		{
			// new element, then a new string for it's content
			//
			currentString = "";
			
			// see if this is a new <item> tag. if so, allocate space to hold the
			// data for this item
			//
			if(localName.compareTo("item") == 0)
			{
				inItem = true;
				curItem = new RssItem();
			}
		}
	}

}
