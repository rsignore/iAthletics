//
//  AdService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/26/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "AdService.h"


@implementation AdService

@synthesize adUrl;
@synthesize image;
@synthesize adPhone;

-(void)dealloc
{
	[self.adUrl release];
	[self.image release];
	[self.adPhone release];
	
	[super dealloc];
}

-(void)requestService
{
	// we don't want to cache the network call if possible
	//
	[self turnCacheOff];
	
	[self requestServiceName:@"GetNextAd" parameters:nil];
	
}

#pragma mark -
#pragma mark iAthleticsService ABSTRACT methods


-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	// ad URL
	//
	if([elementName compare:@"AdUrl"] == NSOrderedSame)
	{
		self.adUrl = text;
	}
	
	// ad phone
	//
	else if([elementName compare:@"AdPhone"] == NSOrderedSame)
	{
		self.adPhone = text;
	}
	
	// the ad image
	//
	else if([elementName compare:@"AdImageUrl"] == NSOrderedSame)
	{
		iAthleticsImage *newImage = [[iAthleticsImage alloc]initWithUrl:text];
		self.image = newImage;
		
		[newImage release];
	}
}

@end
