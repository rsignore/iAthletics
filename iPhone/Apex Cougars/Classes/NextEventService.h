//
//  NextEventService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsService.h"
#import "AppEvent.h"

@interface NextEventService : iAthleticsService {
	
	AppEvent *nextEvent;

}

@property(nonatomic,retain)AppEvent *nextEvent;

-(void)requestService;

@end
