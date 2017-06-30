package com.appapro.iathletics.services;

import java.util.ArrayList;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.NewsLink;
import com.appapro.iathletics.types.iAthleticsImage;

public class NewsService extends iAthleticsService
{

	private ArrayList<NewsLink> links;
	private NewsLink	currentLink;
	
	public NewsService(iAthleticsActivity activity)
	{
		super(activity);
		
		// allocate some space for storage
		//
		links = new ArrayList<NewsLink>(5);
		currentLink = null;
	}
	
	private static final String NEWSLINK_TAG = "NewsLink";

	@Override
	protected void elementStart(String elementName)
	{
		// prepare to receive a new news link
		//
		if(elementName.compareTo(NewsService.NEWSLINK_TAG) == 0)
		{
			this.currentLink = new NewsLink();
		}
	}

	private static final String LINKNAME_TAG = "LinkName";
	private static final String LINKDESCRIPTION_TAG = "LinkDescription";
	private static final String LINKURL_TAG = "LinkUrl";
	private static final String LINKICONURL_TAG = "LinkIconUrl";
	private static final String LINKTYPEID_TAG = "LinkTypeId";
	
	@Override
	protected void elementEnd(String elementName, String text)
	{
		// link name
		//
		if(elementName.compareTo(LINKNAME_TAG) == 0)
		{
			this.currentLink.setLinkName(text);
		}
		
		// link description
		//
		else if(elementName.compareTo(LINKDESCRIPTION_TAG) == 0)
		{
			this.currentLink.setLinkDescription(text);
		}
		
		// the link URL
		//
		else if(elementName.compareTo(LINKURL_TAG) == 0)
		{
			this.currentLink.setLinkUrl(text);
		}
		
		// the icon URL?
		//
		else if(elementName.compareTo(LINKICONURL_TAG) == 0)
		{
			this.currentLink.setImage(new iAthleticsImage(text, getActivity()));
		}
		
		else if(elementName.compareTo(LINKTYPEID_TAG) == 0)
		{
			this.currentLink.setLinkType(Integer.valueOf(text));
		}
		
		// if this is the end of the NewsLink then add the currentLink to the 
		// links array
		else if(elementName.compareTo(NEWSLINK_TAG) == 0)
		{
			this.links.add(this.currentLink);
		}		
	}
	
	private static final String SERVICE_NAME = "GetAppNewsLinks";

	public ArrayList<NewsLink>getNewsLinks()
	{
		this.requestService(SERVICE_NAME, null);
		
		return this.links;
	}
}
