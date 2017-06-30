//
//  AppEvent.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "AppEvent.h"


@implementation AppEvent

@synthesize eventId;
@synthesize eventDateTime;
@synthesize teamName;
@synthesize sportName;
@synthesize eventName;
@synthesize image;
@synthesize awayEvent;
@synthesize conferenceEvent;
@synthesize	venu;
@synthesize note;
@synthesize results;

@synthesize resultId;
@synthesize resultDetailsUrl;

-(id)init
{
	self = [super init];
	
	AppVenu *newVenu = [[AppVenu alloc]init];
	self.venu = newVenu;
	
	[newVenu release];
	
	return self;
}

-(void)dealloc
{
	[self.venu release];
	[self.eventDateTime release];
	[self.teamName release];
	[self.sportName release];
	[self.eventName release];
	[self.image release];
	[self.note	release];
	[self.results release];
    
    [self.resultDetailsUrl release];

	[super dealloc];
}

#pragma mark -
#pragma mark Date formatting functions

// returns a date ie. Tuesday, April 10
//
-(NSString *)longDate
{	
	return [self stringFromEventDate:@"EEEE, MMMM d, yyyy"];
}

// returns a date ie. 8/20
//
-(NSString *)shortDate
{	
	return [self stringFromEventDate:@"M/d"];
}

// returns the time ie. 4:30 pm
//
-(NSString *)time
{
	return [self stringFromEventDate:@"h:mm a"];		
}

// returns a fully formatted date ie. Monday, August 16 4:00 PM
-(NSString *)longDateTime
{
	return [self stringFromEventDate:@"EEEE, MMMM d 'at' h:mm a"];
}

-(NSString *)stringFromEventDate:(NSString *)formatString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	
	[dateFormatter setDateFormat:formatString];
	NSString *dateString = [dateFormatter stringFromDate:self.eventDateTime];
	
	[dateFormatter release];
	
	return dateString;		
}

// returns just the date component of the NSDate, no time
//
-(NSDate *)dateOnly
{
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *components =
	[gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.eventDateTime];	
	
	NSDate *justDate = [gregorian dateFromComponents:components];
	
	[gregorian release];
	
	return justDate;
}

@end
