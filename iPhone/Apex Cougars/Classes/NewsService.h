//
//  GetNewsService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsService.h"
#import "NewsLink.h"

@interface NewsService : iAthleticsService {
	
	NSMutableArray *links;
	
@private
	NewsLink	*currentLink;
}

@property(nonatomic,retain)NSMutableArray	*links;
@property(nonatomic,retain)NewsLink			*currentLink;

-(NSArray *)requestService;

@end
