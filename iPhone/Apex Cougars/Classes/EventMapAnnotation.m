//
//  EventMapAnnotation.m
//  iAthletics
//
//  Created by Robert Signore on 9/29/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import "EventMapAnnotation.h"

@implementation EventMapAnnotation

@synthesize eventCoordinate,eventTitle, eventSubtitle;

- (CLLocationCoordinate2D)coordinate;
{
    return eventCoordinate;
}


// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return self.eventTitle;
}


// optional
- (NSString *)subtitle
{
    return self.eventSubtitle;
}


- (void)dealloc
{
    [super dealloc];
}


@end
