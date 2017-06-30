//
//  AdService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/26/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "SplashService.h"


@implementation SplashService

@synthesize splashUrl;
@synthesize image;


-(void)dealloc
{
	[self.splashUrl release];
	[self.image release];
	
	[super dealloc];
}

-(void)requestService
{
	// we don't want to cache the network call if possible
	//
	[self turnCacheOff];
	
	[self requestServiceName:@"GetNextSplash" parameters:nil];
	
}

#pragma mark -
#pragma mark iAthleticsService ABSTRACT methods


-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	// ad URL
	//
	if([elementName compare:@"SplashUrl"] == NSOrderedSame)
	{
		self.splashUrl = text;
	}
	
	
	// the ad image
	//
	else if([elementName compare:@"SplashImageUrl"] == NSOrderedSame)
	{
		iAthleticsImage *newImage = [[iAthleticsImage alloc]initWithUrl:text];
		self.image = newImage;
		
		[newImage release];
	}
}

@end
