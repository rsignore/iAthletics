//
//  SportListItem.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/16/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "SportListItem.h"


@implementation SportListItem

@synthesize sportName;
@synthesize image;
@synthesize teamName;
@synthesize teamId;

-(void)dealloc
{
	[self.sportName release];
	[self.image release];
	[self.teamName release];

	[super dealloc];
}

@end
