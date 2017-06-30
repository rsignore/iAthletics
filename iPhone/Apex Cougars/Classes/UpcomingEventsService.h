//
//  UpcommingEventsService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/19/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NextEventService.h"

@interface UpcomingEventsService : NextEventService 
{
	NSMutableDictionary *events;
}

@property(nonatomic,retain)NSMutableDictionary *events;

// private methods
//
-(void)addCurrentItemToDictionary;
-(void)addNewKeyAndValueToDictionary;

// private methods
//
-(void)elementEnd:(NSString *)elementName withText:(NSString *)text;
-(void)addCurrentItemToDictionary;
@end
