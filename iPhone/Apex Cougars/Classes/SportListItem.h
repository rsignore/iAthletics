//
//  SportListItem.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/16/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsImage.h"

@interface SportListItem : NSObject 
{
	NSString		*sportName;
	iAthleticsImage	*image;
	NSString		*teamName;
	NSInteger		teamId;
}

@property(nonatomic,retain)NSString			*sportName;
@property(nonatomic,retain)iAthleticsImage	*image;
@property(nonatomic,retain)NSString			*teamName;
@property(nonatomic,assign)NSInteger		teamId;

@end
