//
//  UpcomingEventsViewController.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/19/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"iAthleticsViewController.h"


@interface UpcomingEventsViewController : iAthleticsViewController 
						<UITableViewDelegate, UITableViewDataSource>
{
	// these are mutable so that 
	// derived classes can maniputate
	//
	NSMutableDictionary	*events;
	NSMutableArray		*dates;
	
	// a dictionary to hold the event views
	// opened by the user
	//
	NSMutableDictionary	*eventViews;
	
	UITableView		*myTableView;

}

@property(nonatomic,retain)NSMutableDictionary	*events;
@property(nonatomic,retain)NSMutableArray		*dates;

@property(nonatomic,retain)NSMutableDictionary *eventViews;

@property(nonatomic,retain)IBOutlet UITableView *myTableView;

// protected methods
//
-(void)sortData;

@end
