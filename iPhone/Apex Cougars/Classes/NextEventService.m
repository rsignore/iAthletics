//
//  NextEventService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "NextEventService.h"


@implementation NextEventService

@synthesize nextEvent;

-(void)dealloc
{
	[nextEvent release];
	
	[super dealloc];
}

-(void)requestService
{
	[self requestServiceName:@"GetNextEvent" parameters:nil];
}

#pragma mark -
#pragma mark iAthleticsService ABSTRACT methods


-(void) elementStart:(NSString *)elementName
{
	// prepare to receive new event Info
	//
	if([elementName compare:@"Event"] == NSOrderedSame)
	{
		AppEvent *newEvent = [[AppEvent alloc]init];
		self.nextEvent = newEvent;
		
		[newEvent release];
	}
}

-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	// is this the event id
	//
	if([elementName compare:@"eventId"] == NSOrderedSame)
	{
		self.nextEvent.eventId = [text intValue];
	}
	
	// event date and time
	//
	else if([elementName compare:@"EventDateTime"] == NSOrderedSame)
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
		
		self.nextEvent.eventDateTime = [dateFormatter dateFromString:text];
		
		[dateFormatter release];
	}
	else if([elementName compare:@"TeamName"] == NSOrderedSame)
	{
		self.nextEvent.teamName = text;
	}
	
	else if([elementName compare:@"SportName"] == NSOrderedSame)
	{
		self.nextEvent.sportName = text;
	}
	
	else if([elementName compare:@"EventName"] == NSOrderedSame)
	{
		self.nextEvent.eventName = text;
	}
	
	else if([elementName compare:@"IconUrl"] == NSOrderedSame)
	{
		iAthleticsImage *newImage = [[iAthleticsImage alloc]initWithUrl:text];
		self.nextEvent.image = newImage;
		
		[newImage release];
	}
	
	else if([elementName compare:@"AwayEvent"] == NSOrderedSame)
	{
		self.nextEvent.awayEvent = [text boolValue];
	}
	
	else if([elementName compare:@"ConferenceEvent"] == NSOrderedSame)
	{
		self.nextEvent.conferenceEvent = [text boolValue];
	}

	else if([elementName compare:@"Notes"] == NSOrderedSame)
	{
		self.nextEvent.note = text;
	}

	else if([elementName compare:@"Results"] == NSOrderedSame)
	{
		self.nextEvent.results = text;
	}
	
	// parse the venu information
	//
	else if([elementName compare:@"Address1"] == NSOrderedSame)
	{
		self.nextEvent.venu.address1 = text;
	}
	else if([elementName compare:@"Address2"] == NSOrderedSame)
	{
		self.nextEvent.venu.address2 = text;
	}	
	else if([elementName compare:@"City"] == NSOrderedSame)
	{
		self.nextEvent.venu.city = text;
	}
	else if([elementName compare:@"State"] == NSOrderedSame)
	{
		self.nextEvent.venu.state = text;
	}
	else if([elementName compare:@"Zip"] == NSOrderedSame)
	{
		self.nextEvent.venu.zip = text;
	}
	else if([elementName compare:@"WebUrl"] == NSOrderedSame)
	{
		self.nextEvent.venu.webUrl = text;
	}
	else if([elementName compare:@"VenuName"] == NSOrderedSame)
	{
		self.nextEvent.venu.venuName = text;
	}
    
    // added for new result view
    //
    else if([elementName compare:@"ResultId"] == NSOrderedSame)
    {
        // this tag will come in in the form of </ ResultId xlns:nil> if null
        // text will be an empty string
        //
        if(text != nil)
        {
            self.nextEvent.resultId = [text intValue];
        }
    }
    else if([elementName compare:@"ResultDetailsUrl"] == NSOrderedSame)
    {
        self.nextEvent.resultDetailsUrl = text;
    }
}


@end
