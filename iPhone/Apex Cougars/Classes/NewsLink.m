//
//  NewsLink.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "NewsLink.h"


@implementation NewsLink

@synthesize linkName;
@synthesize linkDescription;
@synthesize linkUrl;
@synthesize image;
@synthesize linkType;


-(void)dealloc
{	
	[self.linkName release];
	[self.linkDescription release];
	[self.linkUrl release];
	[self.image release];

	[super dealloc];
}


@end
