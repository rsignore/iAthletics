package com.appapro.iathletics.services;

import com.appapro.iathletics.activities.iAthleticsActivity;
import com.appapro.iathletics.types.NewsLink;
import com.appapro.iathletics.types.TeamInfo;
import com.appapro.iathletics.types.iAthleticsImage;

public class TeamDetailService extends iAthleticsService
{
	TeamInfo teamInfo = new TeamInfo();
	NewsLink currentLink;

	public TeamDetailService(iAthleticsActivity activity)
	{
		super(activity);
	}

	public TeamInfo getTeamInfo(int teamId)
	{
		// create the parameter string
		//
		String parameters = "teamId=" + Integer.toString(teamId);

		this.requestService("GetTeamInfo", parameters);
		
		return this.teamInfo;		
	}

	@Override
	protected void elementStart(String elementName)
	{
		// prepare to receive new news link Info
		//
		if(elementName.compareTo("NewsLink") == 0)
		{
			this.currentLink = new NewsLink();
		}
	}

	@Override
	protected void elementEnd(String elementName, String text)
	{
		
		// team id
		//
		if(elementName.compareTo("TeamId") == 0)
		{
			this.teamInfo.setTeamId(Integer.valueOf(text));
		}
		
		// overall results
		//
		else if(elementName.compareTo("TeamOverallResults") == 0)
		{
			this.teamInfo.setOverallResults(text);
		}	
		// sport name
		//
		else if(elementName.compareTo("SportName") == 0)
		{
			this.teamInfo.setSportName(text);
		}	
		
		// team name
		//
		else if(elementName.compareTo("TeamName") == 0)
		{
			this.teamInfo.setTeamName(text);
		}
		
		// team photo?
		//
		else if(elementName.compareTo("TeamPhotoUrl") == 0)
		{
			this.teamInfo.setPhoto(new iAthleticsImage(text, this.getActivity()));
		}

		/////
		//
		// parsing for the NewsLinks in the message
		//
		/////
		
		// link name
		//
		else if(elementName.compareTo("LinkName") == 0)
		{
			this.currentLink.setLinkName(text);
		}
		
		// link description
		//
		else if(elementName.compareTo("LinkDescription") == 0)
		{
			this.currentLink.setLinkDescription(text);
		}
		
		// the link URL
		//
		else if(elementName.compareTo("LinkUrl") == 0)
		{
			this.currentLink.setLinkUrl(text);
		}
		
		// the icon URL?
		//
		else if(elementName.compareTo("LinkIconUrl") == 0)
		{
		
			this.currentLink.setImage(new iAthleticsImage(text, this.getActivity()));
		}
		
		else if(elementName.compareTo("LinkTypeId") == 0)
		{
			this.currentLink.setLinkType(Integer.valueOf(text));
		}
		
		// if this is the end of the NewsLink then add the currentLink to the 
		// links array
		else if(elementName.compareTo("NewsLink") == 0)
		{
			this.teamInfo.addNewsLink(this.currentLink);
		}
	}

}
