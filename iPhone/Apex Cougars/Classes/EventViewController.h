//
//  TennisEventViewController.h
//  Apex Athletics
//
//  Created by Robert Signore on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppEvent.h"
#import <CoreLocation/CLPlacemark.h>
#import <CoreLocation/CLGeocoder.h>
#import <MapKit/MKMapView.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EKEvent.h>
#import "iAthleticsViewController.h"

@interface EventViewController : iAthleticsViewController
                            <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, EKEventEditViewDelegate>
{
    // mapping variables
    //
    CLPlacemark *eventPlacemark;
    
    // data to display
    //
	AppEvent *event;
	NSInteger schedultId;
    
    // calendar variables
    //
    EKEventStore *eventStore;
    EKCalendar  *eventCalendar;
    
	// outlets for the view
	//
	UIImageView	*sportIcon;
	UILabel		*teamName;
	UILabel		*when;
	UILabel		*venuName;
	UILabel		*street1;
	UILabel		*street2;
	UILabel		*cityStateZip;
	UILabel		*notes;
	UILabel		*eventName;
    MKMapView   *mapView;
}

@property(nonatomic,retain)AppEvent     *event;
@property(nonatomic,assign)NSInteger    scheduleId;

@property(nonatomic,retain)CLPlacemark  *eventPlacemark;

@property(nonatomic,retain)EKEventStore *eventStore;
@property(nonatomic,retain)EKCalendar   *eventCalendar;

@property(nonatomic,retain)IBOutlet UIImageView	*sportIcon;
@property(nonatomic,retain)IBOutlet UILabel		*teamName;
@property(nonatomic,retain)IBOutlet UILabel		*when;
@property(nonatomic,retain)IBOutlet UILabel		*venuName;
@property(nonatomic,retain)IBOutlet UILabel		*street1;
@property(nonatomic,retain)IBOutlet UILabel		*street2;
@property(nonatomic,retain)IBOutlet UILabel		*cityStateZip;
@property(nonatomic,retain)IBOutlet UILabel		*notes;
@property(nonatomic,retain)IBOutlet UILabel		*eventName;
@property(nonatomic,retain)IBOutlet MKMapView   *mapView;

-(IBAction)getDirections:(id)sender;
-(IBAction)shareWithFriends:(id)sender;


// private functions
//
-(NSString *)mapUrl;



@end
