//
//  AppSeason.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/12/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsImage.h"


@interface AppSeason : NSObject {
	NSString		*seasonName;
	NSInteger		seasonId;

	iAthleticsImage *image;
}

@property(nonatomic,retain) NSString		*seasonName;
@property(nonatomic,retain) iAthleticsImage	*image;
@property(nonatomic,assign) NSInteger		seasonId;

@end
