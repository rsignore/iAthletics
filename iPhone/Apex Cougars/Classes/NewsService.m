//
//  GetNewsService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "NewsService.h"


@implementation NewsService

@synthesize links;
@synthesize currentLink;

-(void)dealloc
{
	[self.links release];
	[self.currentLink release];
	
	[super dealloc];
}

-(id) initWithApplication:(iAthleticsApplication *)theApp
{
	self = [super initWithApplication:theApp];
	
	NSMutableArray *newLinks = [[NSMutableArray alloc]initWithCapacity:10];
	self.links = newLinks;
	
	[newLinks release];
	
	return self;
}


-(NSArray *)requestService
{
	[self requestServiceName:@"GetAppNewsLinks" parameters:nil];
	
	return self.links;
}

#pragma mark -
#pragma mark iAthleticsService ABSTRACT methods


-(void) elementStart:(NSString *)elementName
{
	// prepare to receive new AppSeason Info
	//
	if([elementName compare:@"NewsLink"] == NSOrderedSame)
	{
		NewsLink *newNews = [[NewsLink alloc]init];
		self.currentLink = newNews;
		
		[newNews release];
	}
}

-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	// link name
	//
	if([elementName compare:@"LinkName"] == NSOrderedSame)
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
		[self.links addObject:self.currentLink];
	}
}

@end
