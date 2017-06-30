package com.appapro.iathletics.types;

public class AppSeason 
{
	private String seasonName;
	private Integer seasonId;
	
	private iAthleticsImage image;

	/**
	 * @return the seasonName
	 */
	public String getSeasonName()
	{
		return seasonName;
	}

	/**
	 * @param seasonName the seasonName to set
	 */
	public void setSeasonName(String seasonName)
	{
		this.seasonName = seasonName;
	}

	/**
	 * @return the seasonId
	 */
	public Integer getSeasonId()
	{
		return seasonId;
	}

	/**
	 * @param seasonId the seasonId to set
	 */
	public void setSeasonId(Integer seasonId)
	{
		this.seasonId = seasonId;
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

}
