//
//  TeamDetailService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/17/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "TeamDetailService.h"


@implementation TeamDetailService

@synthesize teamInfo;
@synthesize currentLink;
@synthesize newsLinks;

#pragma mark Constructors/Destructors

-(id) initWithApplication:(iAthleticsApplication *)theApp
{
	self = [super initWithApplication:theApp];
	
	TeamInfo *newInfo = [[TeamInfo alloc]init];
	
	self.teamInfo = newInfo;
	[newInfo release];
	
	NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:20];
	self.newsLinks = newArray;
	[newArray release];
	
	return self;
}

-(void)dealloc
{
	[self.teamInfo release];
	[self.currentLink release];
	[self.newsLinks release];
	
	[super dealloc];
}

#pragma mark service request methods

-(TeamInfo *)requestServiceWithTeamId:(NSInteger)teamId
{
	// create the parameter string
	//
	NSString *paramString = [NSString stringWithFormat:@"teamId=%d", teamId];
	[self requestServiceName:@"GetTeamInfo" parameters:paramString];
	
	if([newsLinks count] > 0)
	{
		self.teamInfo.newsLinks = [NSArray arrayWithArray:self.newsLinks];
	}
	
	return self.teamInfo;		
}

#pragma mark -
#pragma mark iAthleticsService ABSTRACT methods

-(void) elementStart:(NSString *)elementName
{
	// prepare to receive new AppSeason Info
	//
	if([elementName compare:@"NewsLink"] == NSOrderedSame)
	{
		NewsLink *newLink = [[NewsLink alloc]init];
		self.currentLink = newLink;
		[newLink release];
	}
}

-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	
	// team id
	//
	if([elementName compare:@"TeamId"] == NSOrderedSame)
	{
		self.teamInfo.teamId = [text intValue];
	}
	
	// overall results
	//
	else if([elementName compare:@"TeamOverallResults"] == NSOrderedSame)
	{
		self.teamInfo.overallResults = text;
	}	
	// sport name
	//
	else if([elementName compare:@"SportName"] == NSOrderedSame)
	{
		self.teamInfo.sportName = text;
	}	
	
	// team name
	//
	else if([elementName compare:@"TeamName"] == NSOrderedSame)
	{
		self.teamInfo.teamName = text;
	}
	
	// team photo?
	//
	else if([elementName compare:@"TeamPhotoUrl"] == NSOrderedSame)
	{
		iAthleticsImage *newImage = [[iAthleticsImage alloc]initWithUrl:text];
		self.teamInfo.photo = newImage;
		[newImage release];
	}

	/////
	//
	// parsing for the NewsLinks in the message
	//
	/////
	
	// link name
	//
	else if([elementName compare:@"LinkName"] == NSOrderedSame)
	{
		self.currentLink.linkName = text;
	}
	
	// link description
	//
	else if([elementName compare:@"LinkDescription"] == NSOrderedSame)
	{
		self.currentLink.linkDescription = text;
	}
	
	// the link URL
	//
	else if([elementName compare:@"LinkUrl"] == NSOrderedSame)
	{
		self.currentLink.linkUrl = text;
	}
	
	// the icon URL?
	//
	else if([elementName compare:@"LinkIconUrl"] == NSOrderedSame)
	{
		iAthleticsImage *newImage = [[iAthleticsImage alloc]initWithUrl:text];		
		self.currentLink.image = newImage;
		[newImage release];
	}
	
	else if([elementName compare:@"LinkTypeId"] == NSOrderedSame)
	{
		self.currentLink.linkType = [text intValue];
	}
	
	// if this is the end of the NewsLink then add the currentLink to the 
	// links array
	else if([elementName compare:@"NewsLink"] == NSOrderedSame)
	{
		[self.newsLinks addObject:self.currentLink];
	}
}


@end
