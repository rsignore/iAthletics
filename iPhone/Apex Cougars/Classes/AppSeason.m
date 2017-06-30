//
//  AppSeason.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/12/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "AppSeason.h"


@implementation AppSeason

@synthesize seasonName;
@synthesize image;
@synthesize seasonId;


-(void)dealloc
{
	[self.seasonName release];
	[self.image release];

	[super dealloc];
}


@end
