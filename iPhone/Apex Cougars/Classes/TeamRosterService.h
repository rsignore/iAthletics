//
//  TeamRosterService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/17/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsService.h"
#import "Athlete.h"

@interface TeamRosterService : iAthleticsService 
{
	NSMutableArray	*athletes;
	
@private
	Athlete *currentAthlete;
}

@property(nonatomic,retain)NSMutableArray	*athletes;
@property(nonatomic,retain)Athlete			*currentAthlete;

// methods to request service
//
-(NSArray *)requestServiceWithTeamId:(NSInteger)teamId;

@end
