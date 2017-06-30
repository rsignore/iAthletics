//
//  iAthleticsImage.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/14/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface iAthleticsImage : NSObject 
{
@private
	NSString		*imageUrl; 
	UIImage			*theImage;	
}

@property(nonatomic, retain)NSString		*imageUrl;
@property(nonatomic, retain)UIImage			*theImage;

-(id)initWithUrl:(NSString *)imageUrl;

-(UIImage *)getImage;

// cache methods
//
-(BOOL)cacheImageData:(NSData *)imageData;
-(NSString *)getCacheFileName;
-(NSData *)loadCachedImage;
-(NSData *)loadFromRecientCache;

@end
