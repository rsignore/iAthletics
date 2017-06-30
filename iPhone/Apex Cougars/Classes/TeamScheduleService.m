//
//  TeamScheduleService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/21/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "TeamScheduleService.h"

@implementation TeamScheduleService

@synthesize resultsArray;

-(void)dealloc
{
	[self.resultsArray release];
	
	[super dealloc];
}

-(void)requestServiceWithTeamId:(NSInteger)teamId
{
	// create the parameter string
	//
	NSString *paramString = [[NSString alloc]initWithFormat:@"teamId=%d", teamId];
	[self requestServiceName:@"GetCompleteTeamSchedule" parameters:paramString];
	
	[paramString release];
}

-(void)addCurrentItemToDictionary
{
	// check to see if the next event is an event in the past. If so
	// well add the event to the "Results" mutable array
	//
	NSDate *yesterday = [self yesterday];
	NSComparisonResult compResult = [yesterday compare:self.nextEvent.eventDateTime];
	if( compResult != NSOrderedAscending)
	{
		if(self.resultsArray == nil)
		{
			NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:100];
			self.resultsArray = newArray;
			[newArray release];
		}
		
		// add the event to the results array
		//
		[self.resultsArray addObject:self.nextEvent];
	}
	else 
	{
		[super addCurrentItemToDictionary];
	}

}

-(NSDate *)yesterday
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = [gregorian components:NSDayCalendarUnit | 
								NSMonthCalendarUnit | NSYearCalendarUnit
								fromDate:[NSDate date]];
	
	// zero out the hour minute and second
	//
	[comps setHour:00];
	[comps setMinute:00];
	[comps setSecond:00];
	
	NSDate *yesterday = [gregorian dateFromComponents:comps];
/*									   
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];


	// Calculate yesterday
	//
	[offsetComponents setDay:-1];
	NSDate *yesterday = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];	
	
	[offsetComponents release];
	
	// strip the time
	//
	NSDateComponents *components =
	[gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:yesterday];	

	yesterday = [gregorian dateFromComponents:components];
*/	
	[gregorian release];
	
	return yesterday;
}

@end
