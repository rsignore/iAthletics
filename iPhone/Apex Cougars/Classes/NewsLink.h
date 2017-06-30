//
//  NewsLink.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsImage.h"

#define LINK_TYPE_RSS		1
#define LINK_TYPE_WEBSITE	2


@interface NewsLink : NSObject {
	
	NSString		*linkName;
	NSString		*linkDescription;
	NSString		*linkUrl;
	iAthleticsImage	*image;
	NSInteger		linkType;
}

@property(nonatomic,retain)NSString			*linkName;
@property(nonatomic,retain)NSString			*linkDescription;
@property(nonatomic,retain)NSString			*linkUrl;
@property(nonatomic,retain)iAthleticsImage	*image;
@property(nonatomic,assign)NSInteger		linkType;

@end
