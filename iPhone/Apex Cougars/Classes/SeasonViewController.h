//
//  SeasonViewComtroller.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"SportListService.h"
#import "iAthleticsViewController.h"


@interface SeasonViewController : iAthleticsViewController 
						<UITableViewDelegate, UITableViewDataSource>
{
	UITableView			*myTableView;
	
	NSInteger			seasonId;
	NSString			*seasonName;
	NSDictionary		*teamList;
	NSArray				*sportList;
}

@property(nonatomic,retain)IBOutlet UITableView			*myTableView;

@property(nonatomic,assign)NSInteger			seasonId;
@property(nonatomic,retain)NSString				*seasonName;
@property(nonatomic,retain)NSDictionary			*teamList;
@property(nonatomic,retain)NSArray				*sportList;

-(id)initWithSeasonId:(NSInteger)anId seasonName:(NSString *)name;

@end
