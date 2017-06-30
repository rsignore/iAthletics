package com.appapro.iathletics.types;

import java.util.ArrayList;

public class TeamInfo 
{
	Integer			teamId;
	String			teamName;
	String			sportName;
	iAthleticsImage	photo;
	String			overallResults;
	
	ArrayList<NewsLink>		newsLinks = new ArrayList<NewsLink>(3);

	/**
	 * @return the teamId
	 */
	public Integer getTeamId()
	{
		return teamId;
	}

	/**
	 * @param teamId the teamId to set
	 */
	public void setTeamId(Integer teamId)
	{
		this.teamId = teamId;
	}

	/**
	 * @return the teamName
	 */
	public String getTeamName()
	{
		return teamName;
	}

	/**
	 * @param teamName the teamName to set
	 */
	public void setTeamName(String teamName)
	{
		this.teamName = teamName;
	}

	/**
	 * @return the sportName
	 */
	public String getSportName()
	{
		return sportName;
	}

	/**
	 * @param sportName the sportName to set
	 */
	public void setSportName(String sportName)
	{
		this.sportName = sportName;
	}

	/**
	 * @return the photo
	 */
	public iAthleticsImage getPhoto()
	{
		return photo;
	}

	/**
	 * @param photo the photo to set
	 */
	public void setPhoto(iAthleticsImage photo)
	{
		this.photo = photo;
	}

	/**
	 * @return the overallResults
	 */
	public String getOverallResults()
	{
		return overallResults;
	}

	/**
	 * @param overallResults the overallResults to set
	 */
	public void setOverallResults(String overallResults)
	{
		this.overallResults = overallResults;
	}

	/**
	 * @return the newsLinks
	 */
	public ArrayList<NewsLink> getNewsLinks()
	{
		return newsLinks;
	}

	/**
	 * @param newsLinks the newsLinks to set
	 */
	public void addNewsLink(NewsLink newLink)
	{
		this.newsLinks.add(newLink);
	}
}
