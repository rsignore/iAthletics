package com.appapro.iathletics.types;

public class NewsLink 
{
	public static final int LINKTYPE_RSS = 1;
	public static final int LINKTYPE_WEB = 2;
	
	private String			linkName;
	private String			linkDescription;
	private String			linkUrl;
	private iAthleticsImage	image;
	private Integer			linkType;
	/**
	 * @return the linkName
	 */
	public String getLinkName()
	{
		return linkName;
	}
	/**
	 * @param linkName the linkName to set
	 */
	public void setLinkName(String linkName)
	{
		this.linkName = linkName;
	}
	/**
	 * @return the linkDescription
	 */
	public String getLinkDescription()
	{
		return linkDescription;
	}
	/**
	 * @param linkDescription the linkDescription to set
	 */
	public void setLinkDescription(String linkDescription)
	{
		this.linkDescription = linkDescription;
	}
	/**
	 * @return the linkUrl
	 */
	public String getLinkUrl()
	{
		return linkUrl;
	}
	/**
	 * @param linkUrl the linkUrl to set
	 */
	public void setLinkUrl(String linkUrl)
	{
		this.linkUrl = linkUrl;
	}
	/**
	 * @return the image
	 */
	public iAthleticsImage getImage()
	{
		return image;
	}
	/**
	 * @param image the image to set
	 */
	public void setImage(iAthleticsImage image)
	{
		this.image = image;
	}
	/**
	 * @return the linkType
	 */
	public Integer getLinkType()
	{
		return linkType;
	}
	/**
	 * @param linkType the linkType to set
	 */
	public void setLinkType(Integer linkType)
	{
		this.linkType = linkType;
	}
}
