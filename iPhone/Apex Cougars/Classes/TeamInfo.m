//
//  TeamInfo.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/17/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "TeamInfo.h"


@implementation TeamInfo

@synthesize teamId;
@synthesize teamName;
@synthesize photo;
@synthesize newsLinks;
@synthesize sportName;
@synthesize overallResults;



-(id)init
{
	self = [super init];
	
	return self;
}

-(void)dealloc
{
	[self.teamName release];
	[self.photo release];
	[self.newsLinks release];
	[self.sportName release];
	[self.overallResults release];
	
	[super dealloc];
}

@end
