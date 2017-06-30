//
//  TeamRosterService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/17/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "TeamRosterService.h"


@implementation TeamRosterService

@synthesize athletes;
@synthesize currentAthlete;

#pragma mark Constructors/Destructors

-(id) initWithApplication:(iAthleticsApplication *)theApp
{
	self = [super initWithApplication:theApp];
	
	NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:100];
	self.athletes = newArray;
	[newArray release];
	
	return self;
}

-(void)dealloc
{
	[self.athletes release];
	[self.currentAthlete release];
	
	[super dealloc];
}

#pragma mark service request methods

-(NSArray *)requestServiceWithTeamId:(NSInteger)teamId
{
	// create the parameter string
	//
	NSString *paramString = [[NSString alloc]initWithFormat:@"teamId=%d", teamId];
	[self requestServiceName:@"GetTeamRoster" parameters:paramString];
	
	[paramString release];
	
	
	return self.athletes;		
}

#pragma mark -
#pragma mark iAthleticsService ABSTRACT methods

-(void) elementStart:(NSString *)elementName
{
	// prepare to receive new AppSeason Info
	//
	if([elementName compare:@"Player"] == NSOrderedSame)
	{
		self.currentAthlete = nil;
		
		Athlete *newAthlete = [[Athlete alloc]init];
		self.currentAthlete = newAthlete;
		[newAthlete release];
	}
}

-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	
	// player name
	//
	if([elementName compare:@"Name"] == NSOrderedSame)
	{
		self.currentAthlete.name = text;
	}
	
	// player number
	//
	else if([elementName compare:@"Number"] == NSOrderedSame)
	{
		self.currentAthlete.number = text;
	}	
	
	// grade
	//
	else if([elementName compare:@"Grade"] == NSOrderedSame)
	{
		self.currentAthlete.grade = text;
	}	
	
	// height
	//
	else if([elementName compare:@"Height"] == NSOrderedSame)
	{
		self.currentAthlete.height = text;
	}
	
	// weight
	//
	else if([elementName compare:@"Weight"] == NSOrderedSame)
	{
		self.currentAthlete.weight = text;
	}
	
	// positions
	//
	else if([elementName compare:@"Positions"] == NSOrderedSame)
	{
		self.currentAthlete.positions = text;
	}
	
	// if this is the end of the NewsLink then add the currentLink to the 
	// links array
	else if([elementName compare:@"Player"] == NSOrderedSame)
	{
		[self.athletes addObject:self.currentAthlete];
	}
}

@end
