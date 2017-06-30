//
//  AdService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/26/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsImage.h"
#import "iAthleticsService.h"


@interface AdService : iAthleticsService 
{
	NSString		*adUrl;
	iAthleticsImage *image;
	NSString		*adPhone;
}

@property(nonatomic,retain)NSString			*adUrl;
@property(nonatomic,retain)iAthleticsImage	*image;
@property(nonatomic,retain)NSString			*adPhone;

-(void)requestService;

@end
