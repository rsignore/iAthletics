//
//  RosterCell.h
//  Apex Athletics
//
//  Created by Robert Signore on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ROSTER_CELL_ID		@"RosterCell"
#define ROSTER_ROW_HEIGHT	60

@interface RosterCell : UITableViewCell 
{
	UILabel *playerNumber;
	UILabel *playerName;
	UILabel	*playerClass;
	UILabel *playerPosition;
	UILabel *playerHeight;
	UILabel *playerWeight;
}

@property(nonatomic, retain) IBOutlet UILabel *playerNumber;
@property(nonatomic, retain) IBOutlet UILabel *playerName;
@property(nonatomic, retain) IBOutlet UILabel *playerClass;
@property(nonatomic, retain) IBOutlet UILabel *playerPosition;
@property(nonatomic, retain) IBOutlet UILabel *playerHeight;
@property(nonatomic, retain) IBOutlet UILabel *playerWeight;

@end
