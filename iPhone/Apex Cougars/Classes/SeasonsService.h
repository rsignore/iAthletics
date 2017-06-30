//
//  SeasonsService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/13/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsService.h"
#import "AppSeason.h"


@interface SeasonsService : iAthleticsService
{
	NSMutableArray *seasons;
	
@private
	AppSeason *curSeason;
}

@property(nonatomic, retain)NSMutableArray	*seasons;
@property(nonatomic, retain)AppSeason		*curSeason;

-(NSArray *)requestService;


@end
