//
//  RootViewController.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/10/10.
//  Copyright Appapro 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SeasonsService.h"
#import "NextEventService.h"
#import "AppEvent.h"
#import "NewsService.h"
#import	"UpcomingEventsViewController.h"
#import	"iAthleticsViewController.h"

// main menu
//
#define SECTION_TEAMS		0
#define SECTION_CALENDAR	1
#define SECTION_NEWS		2
#define SECTION_SUPPORT		3

#define NUM_SECTIONS		(SECTION_SUPPORT + 1)


// Support menu section
//
#define SUPPORT_SHARE_APP			0
#define SUPPORT_CONTACT_SUPPORT		1
#define NUM_SUPPORT_ROWS			(SUPPORT_CONTACT_SUPPORT + 1)

@interface RootViewController : iAthleticsViewController 
								<UITableViewDelegate, UITableViewDataSource, 
								MFMailComposeViewControllerDelegate, UIAlertViewDelegate>
{
	// controls
	//
	UITableView	*mainMenuTable;	
	
	// data used to display the UI
	//
	NSArray		*seasons;
	NSArray		*newsLinks;
	AppEvent	*nextEvent;
	
	// application status fields;
	NSString *appMessage;
	NSString *currentVersionUrl;
	NSString *status;
    NSDate  *loadDateTime;

}

@property(nonatomic,retain)NSString *appMessage;
@property(nonatomic,retain)NSString *currentVersionUrl;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain) IBOutlet UITableView *mainMenuTable;

@property(nonatomic,retain) NSArray		*seasons;
@property(nonatomic,retain) NSArray		*newsLinks;
@property(nonatomic,retain) AppEvent	*nextEvent;
@property(nonatomic,retain) NSDate		*loadDateTime;

- (UITableViewCell *)cellForCalendarRow:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForSupportRow:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForTeamsRow:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForNewsRow:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// handle the selection of rows in each section
//
- (void)handleSupportSelectedRow:(UITableView *)tableVilew indexPath:(NSIndexPath *)indexPath;
- (void)handleTeamsSelectedRow:(UITableView *)tableVilew indexPath:(NSIndexPath *)indexPath;

// methods to load the data from the web services
//
- (void) loadSeasonsData;
- (void) loadNewsData;
-(void)loadCalendarData;
@end
