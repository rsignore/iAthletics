//
//  AppVenu.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppVenu : NSObject {
	
	NSString *venuName;
	NSString *address1;
	NSString *address2;
	NSString *city;
	NSString *state;
	NSString *zip;
	NSString *webUrl;
}

@property(nonatomic,retain)NSString *venuName;
@property(nonatomic,retain)NSString *address1;
@property(nonatomic,retain)NSString *address2;
@property(nonatomic,retain)NSString *city;
@property(nonatomic,retain)NSString *state;
@property(nonatomic,retain)NSString *zip;
@property(nonatomic,retain)NSString *webUrl;

-(NSString *)mapAddress;

@end
