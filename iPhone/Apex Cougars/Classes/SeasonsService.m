//
//  SeasonsService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/13/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "SeasonsService.h"


@implementation SeasonsService

@synthesize seasons;
@synthesize curSeason;


#pragma mark constructors/destructors

-(id) initWithApplication:(iAthleticsApplication *)theApp
{
	self = [super initWithApplication:theApp];
	
	NSMutableArray *newMut = [[NSMutableArray alloc]initWithCapacity:10];
	self.seasons = newMut;
	
	[newMut release];
	
	return self;
}

-(void)dealloc
{
	[self.seasons release];
	[self.curSeason release];
	
	[super dealloc];
}

-(NSArray *)requestService
{
	[self requestServiceName:@"GetAppSeasons" parameters:nil];
	
	return self.seasons;
}

#pragma mark -
#pragma mark iAthleticsService ABSTRACT methods


-(void) elementStart:(NSString *)elementName
{
	// prepare to receive new AppSeason Info
	//
	if([elementName compare:@"AppSeason"] == NSOrderedSame)
	{
		AppSeason *newSeason = [[AppSeason alloc]init];
		self.curSeason = newSeason;
		
		[newSeason release];
	}
}

-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	// is this the season's name
	//
	if([elementName compare:@"SeasonName"] == NSOrderedSame)
	{
		self.curSeason.seasonName = text;
	}
	
	// the season ID?
	//
	else if([elementName compare:@"SeasonId"] == NSOrderedSame)
	{
		self.curSeason.seasonId = [text intValue];
	}
	
	// the icon URL?
	//
	else if([elementName compare:@"IconUrl"] == NSOrderedSame)
	{
		iAthleticsImage *newImage = [[iAthleticsImage alloc]initWithUrl:text];
		self.curSeason.image = newImage;
		
		[newImage release];
	}
	
	// if this is the end of the AppSeason then add the curSeason to the 
	// seasons array
	else if([elementName compare:@"AppSeason"] == NSOrderedSame)
	{
		[self.seasons addObject:self.curSeason];
	}
}


@end
