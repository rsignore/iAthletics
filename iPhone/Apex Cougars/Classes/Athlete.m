//
//  Athlete.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/17/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "Athlete.h"


@implementation Athlete

@synthesize name;
@synthesize number;
@synthesize grade;
@synthesize height;
@synthesize weight;
@synthesize positions;

-(void)dealloc
{
	[self.name release];
	[self.number release];
	[self.grade	release];
	[self.height release];
	[self.weight release];
	[self.positions release];
	
	[super dealloc];
}

-(NSInteger)compare:(Athlete *)otherAthlete
{
	NSInteger retval = NSOrderedSame;
	// compare numbers?
	//
	if(self.number != nil && otherAthlete.number != nil)
	{
		retval =  [self.number compare:otherAthlete.number];
	}
	
	// compare name if equal
	//
	if(retval == NSOrderedSame)
	{
		retval = [self.name compare:otherAthlete.name];
	}
	
	return retval;
}
@end