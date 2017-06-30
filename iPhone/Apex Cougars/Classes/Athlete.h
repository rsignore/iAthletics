//
//  Athlete.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/17/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Athlete : NSObject 
{
	NSString *name;
	NSString *number;
	NSString *grade;
	NSString *height;
	NSString *weight;
	NSString *positions;
}

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *number;
@property(nonatomic,retain)NSString *grade;
@property(nonatomic,retain)NSString *height;
@property(nonatomic,retain)NSString *weight;
@property(nonatomic,retain)NSString *positions;

-(NSInteger)compare:(Athlete *)otherAthlete;

@end
