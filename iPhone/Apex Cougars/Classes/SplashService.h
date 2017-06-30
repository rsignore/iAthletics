//
//  AdService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/26/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsImage.h"
#import "iAthleticsService.h"


@interface SplashService : iAthleticsService 
{
	NSString		*splashUrl;
	iAthleticsImage *image;

}

@property(nonatomic,retain)NSString			*splashUrl;
@property(nonatomic,retain)iAthleticsImage	*image;

-(void)requestService;

@end
