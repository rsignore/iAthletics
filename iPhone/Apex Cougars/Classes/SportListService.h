//
//  SportListService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/16/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsService.h"
#import "SportListItem.h"

@interface SportListService : iAthleticsService 
{
	NSMutableDictionary *sportsList;
	
@private
	
	SportListItem *currentListItem;

}

@property(nonatomic,retain)NSMutableDictionary	*sportsList;
@property(nonatomic,retain)SportListItem		*currentListItem;


// methods to request service
//
-(NSDictionary *)requestServiceWithSeasonId:(NSInteger)seasonId;

// private methods DO NOT CALL OUTSIDE OF CLASS
//
-(void)addCurrentItemToDictionary;
-(void)addNewKeyAndValueToDictionary;

@end
