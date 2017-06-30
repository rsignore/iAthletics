//
//  TeamScheduleViewController.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/21/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"UpcomingEventsViewController.h"


@interface TeamScheduleViewController : UpcomingEventsViewController 
{
	NSInteger teamId;
	
	NSArray	*completedEvents;
    
    // a dictionary to hold the COMPLTED (Results) event views
	// opened by the user
	//
	NSMutableDictionary	*resultViews;
	

}

@property(nonatomic,assign)NSInteger            teamId;
@property(nonatomic,retain)NSArray              *completedEvents;
@property(nonatomic,retain)NSMutableDictionary  *resultViews;

// method declrations
//
-(void)showCompletedEvent:(NSIndexPath *)indexPath;

@end
