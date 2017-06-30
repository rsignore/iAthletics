//
//  EventInfoService.m
//  iAthletics
//
//  Created by Robert Signore on 11/25/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import "EventInfoService.h"

@implementation EventInfoService

// methods to request service
//
-(void)requestServiceWithScheduleId:(NSInteger)scheduleId
{
	// create the parameter string
	//
	NSString *paramString = [[NSString alloc]initWithFormat:@"eventId=%d", scheduleId];
	[self requestServiceName:@"GetEventInfo" parameters:paramString];
	
	[paramString release];
}
@end
