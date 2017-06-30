//
//  EventMapAnnotation.h
//  iAthletics
//
//  Created by Robert Signore on 9/29/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface EventMapAnnotation : NSObject <MKAnnotation>
{
    // variables go here
    //
    CLLocationCoordinate2D  eventCoordinate;
    NSString *eventTitle;
    NSString *eventSubtitle;
}

@property(nonatomic) CLLocationCoordinate2D  eventCoordinate;
@property(nonatomic,retain)NSString         *eventTitle;
@property(nonatomic,retain)NSString         *eventSubtitle;


@end
