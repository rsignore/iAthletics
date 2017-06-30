//
//  AppVenu.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "AppVenu.h"


@implementation AppVenu

@synthesize venuName;
@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize webUrl;

-(void)dealloc
{
	[self.venuName release];
	[self.address1 release];
	[self.address2 release];
	[self.city release];
	[self.state release];
	[self.zip release];
	[self.webUrl release];

	[super dealloc];
}

-(NSString *)mapAddress
{
	return [NSString stringWithFormat:@"%@, %@, %@, %@",
	 self.address1,
	 self.city,
	 self.state,
	 self.zip];	
}
@end
