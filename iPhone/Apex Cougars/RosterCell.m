//
//  RosterCell.m
//  Apex Athletics
//
//  Created by Robert Signore on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RosterCell.h"


@implementation RosterCell

@synthesize playerNumber;
@synthesize playerName;
@synthesize playerClass;
@synthesize playerPosition;
@synthesize playerHeight;
@synthesize playerWeight;

- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		
	}
	
	return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

-(void)dealloc
{
	[playerNumber release];
	[playerName release];
	[playerClass release];
	[playerPosition release];
	[playerHeight release];
	[playerWeight release];
	
	[super dealloc];
}

@end
