//
//  iAthleticsApplication.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/11/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "iAthleticsApplication.h"


@implementation iAthleticsApplication

@synthesize teamName;
@synthesize appId;
@synthesize	appVersion;
@synthesize serviceUrl;
@synthesize supportEmail;
@synthesize	applicationLink;
@synthesize startDateTime;
@synthesize showSplash;
@synthesize hasSplash;
@synthesize clickedSplash;
@synthesize showViewFirst;
@synthesize showAlertFirst;

- (void)dealloc
{
	[self.teamName release];
	[self.serviceUrl release];
	[self.supportEmail release];
	[self.applicationLink release];
	[self.startDateTime release];

    if(self.showViewFirst != nil)
    {
        [self.showViewFirst release];
    }
    
    if(showAlertFirst != nil)
        [self.showAlertFirst release];
	
	[super dealloc];
}

@end
