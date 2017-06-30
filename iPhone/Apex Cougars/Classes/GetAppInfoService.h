//
//  GetAppInfoService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/25/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"iAthleticsService.h"


@interface GetAppInfoService : iAthleticsService 
{
	NSString    *status;
	NSString    *message;
	NSString    *currentVersionUrl;
    BOOL        hasSplashAds;
    

}

@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString	*message;
@property(nonatomic,retain)NSString	*currentVersionUrl;
@property(nonatomic,assign)BOOL     hasSplashAds;

-(void)requestService;

@end
