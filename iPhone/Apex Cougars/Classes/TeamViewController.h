//
//  TeamViewController.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/16/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamInfo.h"
#import "RosterViewController.h"
#import "TeamScheduleViewController.h"
#import "iAthleticsViewController.h"


#define SECTION_TEAM_INFO 0
#define SECTION_TEAM_NEWS 1
#define NUM_SECTIONS (SECTION_TEAM_NEWS + 1)

#define TEAM_INFO_ROSTER 0
#define TEAM_INFO_SCHEDULE 1
#define NUM_TEAM_INFO_ROWS (TEAM_INFO_SCHEDULE + 1)

@interface TeamViewController : iAthleticsViewController 
					<UITableViewDelegate, UITableViewDataSource>
{
	NSInteger	teamId;
	NSString	*fullTeamName;
	TeamInfo	*teamInfo;
	UIImageView	*teamPhoto;
	UITableView	*myTableView;
}

@property(nonatomic,assign)NSInteger			teamId;
@property(nonatomic,retain)NSString				*fullTeamName;
@property(nonatomic,retain)TeamInfo				*teamInfo;
@property(nonatomic,retain)IBOutlet	UIImageView *teamPhoto;
@property(nonatomic,retain)IBOutlet UITableView	*myTableView;

// constructors
//
-(id)initWithTeamId:(NSInteger)anId teamName:(NSString *)aName;


-(UITableViewCell *)tableView:(UITableView *)tableView cellForTeamInfoRow:(NSUInteger)row;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForTeamNewsRow:(NSUInteger)row;

@end
