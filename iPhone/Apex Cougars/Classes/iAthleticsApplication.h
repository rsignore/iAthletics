//
//  iAthleticsApplication.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/11/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface iAthleticsApplication : UIApplication {
	NSString	*teamName;
	NSInteger	appId;
	float		appVersion;
	NSString	*serviceUrl;
	NSString	*supportEmail;
	NSString	*applicationLink;
	NSDate		*startDateTime;
    BOOL        showSplash;
    BOOL        hasSplash;
    BOOL        clickedSplash;
    UIViewController    *showViewFirst;
    NSString            *showAlertFirst;
    
}

@property(nonatomic, retain) NSString	*teamName;
@property(nonatomic, assign) NSInteger	appId;
@property(nonatomic, assign) float		appVersion;
@property(nonatomic, retain) NSString	*serviceUrl;
@property(nonatomic, retain) NSString	*supportEmail;
@property(nonatomic, retain) NSString	*applicationLink;
@property(nonatomic,retain) NSDate		*startDateTime;
@property(nonatomic, assign)BOOL        showSplash;
@property(nonatomic, assign)BOOL        hasSplash;
@property(nonatomic, assign)BOOL        clickedSplash;
@property(nonatomic,retain)UIViewController     *showViewFirst;
@property(nonatomic,retain)NSString             *showAlertFirst;
@end
