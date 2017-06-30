//
//  AppEvent.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAthleticsImage.h"
#import "AppVenu.h"


@interface AppEvent : NSObject {
	
	NSInteger		eventId;
	NSDate			*eventDateTime;
	NSString		*teamName;
	NSString		*sportName;
	NSString		*eventName;
	iAthleticsImage	*image;
	bool			awayEvent;
	bool			conferenceEvent;
	AppVenu			*venu;
	NSString		*note;
	NSString		*results;
    
    // added 11-17-12 to handle new result view
    //
    NSInteger       resultId;
    NSString        *resultDetailsUrl;
	
//	venu information needs to be added
}

@property(nonatomic, retain) AppVenu			*venu;
@property(nonatomic, assign) NSInteger			eventId;
@property(nonatomic, retain) NSDate				*eventDateTime;
@property(nonatomic, retain) NSString			*teamName;
@property(nonatomic, retain) NSString			*sportName;
@property(nonatomic, retain) NSString			*eventName;
@property(nonatomic, retain) iAthleticsImage	*image;
@property(nonatomic, assign) bool				awayEvent;
@property(nonatomic, assign) bool				conferenceEvent;
@property(nonatomic, retain) NSString			*note;
@property(nonatomic, retain) NSString			*results;

@property(nonatomic,assign)NSInteger            resultId;
@property(nonatomic,retain)NSString             *resultDetailsUrl;

// functions to format the event's date as a string
//
-(NSString *)longDate;
-(NSString *)shortDate;
-(NSString *)time;
-(NSString *)longDateTime;

// methods that manipulate the date of the event
//
-(NSDate *)dateOnly;

// PRIVATE Methods
//
-(NSString *)stringFromEventDate:(NSString *)formatString;
@end
