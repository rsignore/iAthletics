package com.appapro.iathletics.types;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class RssItem
{	
	String link;
	String description;
	Date pubDate;
	String title;
	
	
	/**
	 * @return the title
	 */
	public String getTitle()
	{
		return title;
	}
	/**
	 * @param title the title to set
	 */
	public void setTitle(String title)
	{
		this.title = title;
	}
	/**
	 * @return the link
	 */
	public String getLink()
	{
		return link;
	}
	/**
	 * @param link the link to set
	 */
	public void setLink(String link)
	{
		this.link = link;
	}
	/**
	 * @return the description
	 */
	public String getDescription()
	{
		return description;
	}
	/**
	 * @param description the description to set
	 */
	public void setDescription(String description)
	{
		this.description = description;
	}
	/**
	 * @return the pubDate
	 */
	public Date getPubDate()
	{
		return pubDate;
	}
	
	/**
	 * @param pubDate the pubDate to set
	 */
	public void setPubDate(String pubDate)
	{
		SimpleDateFormat formatter = new SimpleDateFormat();
		formatter.applyPattern("EEE',' d MMM yyyy HH':'mm':'ss Z");
		
		try
		{
			this.pubDate = formatter.parse(pubDate);
		}
		catch (ParseException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public String getPubDateFormatted(String asFormat)
	{
		String dateStr = "";
		
		if(this.pubDate != null)
		{
			SimpleDateFormat formatter = new SimpleDateFormat();
			formatter.applyPattern(asFormat);

			dateStr = formatter.format(this.pubDate);
		}

		return dateStr;
	}
}
