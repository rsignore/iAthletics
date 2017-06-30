//
//  TeamInfo.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/17/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsImage.h"


@interface TeamInfo : NSObject {
	
	NSInteger		teamId;
	NSString		*teamName;
	NSString		*sportName;
	iAthleticsImage	*photo;
	NSString		*overallResults;
	
	NSArray	*newsLinks;

}

@property(nonatomic,assign)NSInteger		teamId;
@property(nonatomic,retain)NSString			*teamName;
@property(nonatomic,retain)iAthleticsImage	*photo;
@property(nonatomic,retain)NSArray			*newsLinks;
@property(nonatomic,retain)NSString			*sportName;
@property(nonatomic,retain)NSString			*overallResults;

@end
