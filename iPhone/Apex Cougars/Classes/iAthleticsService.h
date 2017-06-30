//
//  iAthleticsService.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/13/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsApplication.h"

@interface iAthleticsService : NSObject <NSXMLParserDelegate>
						
{
@private
	iAthleticsApplication	*app;
	NSData					*urlData;
	NSError					*anError;
	BOOL					cacheIsOff;
	
@protected
	NSMutableString	*currentString;

}

@property(nonatomic, retain) iAthleticsApplication	*app;
@property(nonatomic, retain) NSMutableString		*currentString;
@property(nonatomic,retain)NSData					*urlData;
@property(nonatomic,retain)NSError					*anError;
@property(nonatomic,assign)BOOL						cacheIsOff;

// constructor methods
//
-(id)initWithApplication:(iAthleticsApplication *)theApp;

//cache control methods
//
-(void)turnCacheOff;
-(void)turnCacheOn;


// methods kicks off the web service. should be called by direct subclasses
//
-(void)requestServiceName:(NSString *)serviceName parameters:(NSString *)parameters;

// ABSTRACT methods
// 
// these methods can be overridden by subclasses
//
-(void) preParse;
-(void) postParse;
-(void) elementStart:(NSString *)elementName;
-(void)elementEnd:(NSString *)elementName withText:(NSString *)text;

// private methods
//
-(void)parseData:(NSData *)data;

// cache methods
//
-(BOOL)cacheResultOfServiceName:(NSString *)serviceName withParameters:(NSString *)parameters;
-(BOOL)loadFromCacheService:(NSString *)serviceName withParameters:(NSString *)parameters;
-(NSString *)getCacheFileName:(NSString *)serviceName withParameters:(NSString *)parameters;
-(BOOL)loadFromRecientCache:(NSString *)serviceName parameters:(NSString *)parameters;

@end
