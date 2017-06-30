//
//  TeamDetailService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/17/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsService.h"
#import "TeamInfo.h"
#import "NewsLink.h"


@interface TeamDetailService : iAthleticsService 
{
	TeamInfo *teamInfo;

@private
	NSMutableArray	*newsLinks;
	NewsLink		*currentLink;
}

@property(nonatomic,retain)TeamInfo	*teamInfo;
@property(nonatomic,retain)NewsLink	*currentLink;
@property(nonatomic,retain)NSMutableArray *newsLinks;

// methods to request service
//
-(TeamInfo *)requestServiceWithTeamId:(NSInteger)teamId;

@end
