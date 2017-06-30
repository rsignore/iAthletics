//
//  GetAppInfoService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/25/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "GetAppInfoService.h"


@implementation GetAppInfoService

@synthesize status;
@synthesize message;
@synthesize currentVersionUrl;
@synthesize hasSplashAds;

-(id) initWithApplication:(iAthleticsApplication *)theApp
{
	self = [super initWithApplication:theApp];
	
	self.hasSplashAds = false;
	
	return self;
}

-(void)dealloc
{
	[self.status release];
	[self.message release];
	[self.currentVersionUrl release];
	
	[super dealloc];
}

-(void)requestService
{
	iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication];
	
	NSString *parameters = [NSString stringWithFormat:@"deviceOS=iPhone&deviceVer=%f", app.appVersion];
	
	[self requestServiceName:@"GetAppInfo" parameters:parameters];
	
	// check for a network error, that way the UI can alert the user of not having
	// network access and that the application is using cached data
	//
	if(self.anError != nil)
	{
		self.status = @"Available";
		self.message = @"Network";
	}
}

#pragma mark -
#pragma mark iAthleticsService ABSTRACT methods


-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	
	// status
	//
	if([elementName compare:@"Status"] == NSOrderedSame)
	{
		self.status = text;
	}
	
	// message
	//
	else if([elementName compare:@"Message"] == NSOrderedSame)
	{
		self.message = text;
	}	
	// upgrade url
	//
	else if([elementName compare:@"CurrentVersionUrl"] == NSOrderedSame)
	{
		self.currentVersionUrl = text;
	}	
    else if([elementName compare:@"HasSplashAds"] == NSOrderedSame)
	{
		if([text compare:@"true"] == NSOrderedSame)
        {
            self.hasSplashAds = true;
        }
	}	
}


@end
