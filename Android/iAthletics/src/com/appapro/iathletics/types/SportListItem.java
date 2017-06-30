package com.appapro.iathletics.types;

public class SportListItem  implements Comparable<SportListItem>
{
	String			sportName;
	iAthleticsImage	image;
	String			teamName;
	Integer			teamId;
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
	
	// compares to sports to each other for sorting
	// sorting is based upon the sport name then the team name
	//
	public int compareTo(SportListItem arg0)
	{
		int comp;
		// first compare the sports to each other
		//
		comp = this.sportName.compareTo(arg0.sportName);
		
		if(comp == 0)
		{
			comp = this.teamName.compareTo(arg0.teamName);
		}
		
		return comp;
	}
	
	public String getFullName()
	{
		return teamName + " " + sportName;
	}
}
