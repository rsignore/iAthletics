//
//  EventInfoService.h
//  iAthletics
//
//  Created by Robert Signore on 11/25/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import "NextEventService.h"

@interface EventInfoService : NextEventService

// methods to request service
//
-(void)requestServiceWithScheduleId:(NSInteger)scheduleId;

@end
