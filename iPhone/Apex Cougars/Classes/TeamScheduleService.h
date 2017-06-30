//
//  TeamScheduleService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/21/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpcomingEventsService.h"


@interface TeamScheduleService : UpcomingEventsService 
{
	// this array will hold the events that are
	// already completed
	//
	NSMutableArray *resultsArray;

}

@property(nonatomic,retain)NSMutableArray *resultsArray;

// methods to request service
//
-(void)requestServiceWithTeamId:(NSInteger)teamId;

//private functions
//
-(NSDate *)yesterday;

@end
