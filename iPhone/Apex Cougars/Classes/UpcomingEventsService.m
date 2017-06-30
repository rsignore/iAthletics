//
//  UpcommingEventsService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/19/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "UpcomingEventsService.h"


@implementation UpcomingEventsService

@synthesize events;

#pragma mark Constructors / Destructors


-(void)dealloc
{
	[events release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Service methods

-(void)requestService
{
	[self requestServiceName:@"GetUpcommingEvents" parameters:nil];
}

#pragma mark -
#pragma mark Parsing methods

-(void) elementStart:(NSString *)elementName
{
	// prepare to receive a new series of event Info
	//
	if([elementName compare:@"Events"] == NSOrderedSame)
	{
		NSMutableDictionary *newDict =[[NSMutableDictionary alloc]initWithCapacity:100];
		self.events = newDict;
		[newDict release];
	}
	else 
	{
		[super elementStart:elementName];
	}
}

-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	// if this is the end of an event then add it to the 
	// dictionary of events
	//
	if([elementName compare:@"Event"] == NSOrderedSame)	
	{
		[self addCurrentItemToDictionary];
	}
	else 
	{
		[super elementEnd:elementName withText:text];
	}
}

-(void)addCurrentItemToDictionary
{
	// get all the current keys in the dictionary
	// the keys used is the event long date
	//
	NSArray *keys = [self.events allKeys];
	
	if(keys == nil || [keys count] == 0)
	{
		[self addNewKeyAndValueToDictionary];
	}
	else 
	{
		// see if the key is in the dictionary
		// already. If so then add the current item to the array
		//
		for(int i=0; i < [keys count]; i++)
		{
			NSString *curKey = (NSString *)[keys objectAtIndex:i];
			
			if([curKey compare:[self.nextEvent longDate]] == NSOrderedSame)
			{
				// add the current list item to the array for the key
				//
				NSMutableArray *arrayForKey = (NSMutableArray *)[events objectForKey:curKey];
				[arrayForKey addObject:self.nextEvent];
				
				// we're done so return
				//
				return;
			}
		}

		// if we got this far then the key does not exist in the array
		// so add it anew
		//
		[self addNewKeyAndValueToDictionary];
	}
}

-(void)addNewKeyAndValueToDictionary
{
	// the key for the item is the long date format of "EEEE, MMMM d" (ie. Tuesday, September 3)
	//
	NSString *key = [self.nextEvent longDate];
	
	// create a new array and put the current list item
	// in it
	//
	NSMutableArray *valueArray = [[NSMutableArray alloc]initWithCapacity:100];
	[valueArray addObject:self.nextEvent];
	
	[self.events setObject:valueArray forKey:key];
	
	[valueArray release];
}

@end
