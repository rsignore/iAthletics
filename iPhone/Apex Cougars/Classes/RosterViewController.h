//
//  RosterViewController.h
//  Apex Athletics
//
//  Created by Robert Signore on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAthleticsViewController.h"


@interface RosterViewController : iAthleticsViewController 
				<UITableViewDelegate, UITableViewDataSource>
{
	UITableView *myTableView;
	
@private
	NSInteger teamId;
	NSString *fullTeamName;	
	NSArray *athletes;

}

@property(nonatomic,assign)NSInteger	teamId;
@property(nonatomic,retain)NSString		*fullTeamName;
@property(nonatomic,retain)NSArray		*athletes;
@property(nonatomic,retain)IBOutlet UITableView *myTableView;

//constructors
//
-(id)initWithTeamId:(NSInteger)anId teamName:(NSString *)aName;
@end
