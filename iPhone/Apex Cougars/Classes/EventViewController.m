//
//  TennisEventViewController.m
//  Apex Athletics
//
//  Created by Robert Signore on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventViewController.h"
#import "iAthleticsApplication.h"
#import <MapKit/MapKit.h>
#import "EventMapAnnotation.h"
#import "EventInfoService.h"

@implementation EventViewController

@synthesize event;
@synthesize scheduleId;
@synthesize eventPlacemark;

@synthesize eventStore, eventCalendar;

@synthesize sportIcon;
@synthesize teamName;
@synthesize when;
@synthesize venuName;
@synthesize street1;
@synthesize street2;
@synthesize cityStateZip;
@synthesize notes;
@synthesize eventName;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // do not show the loading dialog
        //
        self.showLoadingDialog = false;
        
        self.event = nil;
        self.scheduleId = 0;
    }
    
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
}

-(void) loadData
{
    // if the view was given a resultId then the data needs to be loaded from the network
    //
    if(self.scheduleId != 0)
    {
        EventInfoService *svc = [[EventInfoService alloc]
                                     initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
        
        [svc requestServiceWithScheduleId:self.scheduleId];
        
        self.event =svc.nextEvent;
        
        [svc release];
        self.scheduleId = 0;
    }
}

-(void)finishedLoadData
{
    [super finishedLoadData];

    if(self.event != nil)
    {
        // Initialize an event store object with the init method. Initilize the array for events.
        self.eventStore = [[EKEventStore alloc] init];
        
        // Get the default calendar from store.
        self.eventCalendar = [self.eventStore defaultCalendarForNewEvents];
        
        self.title = @"Event Details";
        
        // display information about the event
        //
        self.sportIcon.image = [self.event.image getImage];
        self.teamName.text = [NSString stringWithFormat:@"%@ %@", self.event.teamName, self.event.sportName];
        self.when.text = [self.event longDateTime];
        self.venuName.text = self.event.venu.venuName;
        self.street1.text = self.event.venu.address1;

        self.cityStateZip.text = [NSString stringWithFormat:@"%@, %@ %@", 
                                  self.event.venu.city,
                                  self.event.venu.state,
                                  self.event.venu.zip];
        
        self.notes.text = self.event.note;
        
        self.eventName.text = self.event.eventName;
        
        //geocode the address
        //
        NSString *geoAddressString = [NSString stringWithFormat:@"%@, %@", self.street1.text, self.cityStateZip.text];
        
        CLGeocoder *geocoder = [[[CLGeocoder alloc ]init] autorelease];
        
        [geocoder geocodeAddressString:geoAddressString completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if(placemarks != nil && [placemarks count] > 0)
             {
                 // show the map
                 //
                 mapView.hidden = NO;
                 
                 //save the returned placemak as the event placement
                 //
                 self.eventPlacemark = placemarks[0];
                 
                 // set the map to be centered on the event location
                 //
                 MKCoordinateRegion newRegion;
                 newRegion.center = self.eventPlacemark.region.center;
                 newRegion.span.latitudeDelta = 0.01;
                 newRegion.span.longitudeDelta = 0.01;
                 
                 [self.mapView setRegion:newRegion animated:NO];
                 
                 // drop the pin
                 //
                 EventMapAnnotation *annotation = [[EventMapAnnotation alloc] init];
                 annotation.eventTitle = self.venuName.text;
                 annotation.eventSubtitle = self.when.text;
                 annotation.eventCoordinate = self.eventPlacemark.region.center;
                 
                 [self.mapView addAnnotation:annotation];
                 [self.mapView selectAnnotation:annotation animated:YES];
             }
             else
             {
                 // disable the map
                 //
                 mapView.hidden = YES;
             }
         }
         ];
    }
    
//    [geocoder release];
//    [geoAddressString release];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnView = nil;
    
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[EventMapAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* AnnotationIdentifier = @"EventAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            //
            pinView = [[[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
            pinView.pinColor = MKPinAnnotationColorPurple;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showActionSheet:)
                  forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;

        }
        else
        {
            pinView.annotation = annotation;
        }
        
        returnView = pinView;
    }
    
    return returnView;
}

- (IBAction)showActionSheet:(id)sender
{
    NSInteger cancelIndex;
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Event Details"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Email to Friend", @"Get Directions", nil];
    
    
    // TODO: only call event status if on iOS 6.0 or later
    //
    Boolean canAccessCalendar = true;
    Boolean is60 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
    if (is60)
    {
        EKAuthorizationStatus eventStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        
        canAccessCalendar = (eventStatus == EKAuthorizationStatusAuthorized || eventStatus == EKAuthorizationStatusNotDetermined);
    }
    
    // add an add to calendendar button if the app has access to the users calendar
    //
    if(canAccessCalendar)
    {
        cancelIndex = 3;
        [sheet addButtonWithTitle:@"Add to Calendar"];
    }
    else
    {
        cancelIndex = 2;
    }
    
    // now add the cancel button last in the list
    //
    [sheet addButtonWithTitle:@"Cancel"];
    sheet.cancelButtonIndex = cancelIndex;
    
    [sheet showInView:self.view];
    
    [sheet release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
/*    
    // Release any cached data, images, etc that aren't in use.
	self.event = nil;
	self.sportIcon = nil;
	self.teamName = nil;
	self.when = nil;
	self.venuName = nil;
	self.street1 = nil;
	self.street2 = nil;
	self.cityStateZip = nil;
	self.notes = nil;
	self.eventName = nil;
*/
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)dealloc 
{	
	[self.event release];
	
	[self.sportIcon release];
	[self.teamName release];
	[self.when release];
	[self.venuName release];
	[self.street1 release];
	[self.street2 release];
	[self.cityStateZip	release];
	[self.notes release];
	[self.eventName release];
    [self.mapView release];
    [self.eventPlacemark release];
	
    [super dealloc];
}

-(IBAction)getDirections:(id)sender
{
    Boolean is60 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
    
    if(is60)
    {
        if(self.eventPlacemark != nil)
        {
            MKPlacemark *mkPlacemark = [[MKPlacemark alloc] initWithPlacemark:self.eventPlacemark];
            MKMapItem *directionsMap = [[MKMapItem alloc]initWithPlacemark:mkPlacemark];
            
            [directionsMap openInMapsWithLaunchOptions:nil];
            
            [MKPlacemark release];
            [directionsMap release];
        }
    }
    else
    {
    
        // this is the pre iOS 5 code that uses Google Maps to display directions
        //
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self mapUrl]]];
    }    
}

-(NSString *)mapUrl
{
	NSString *unencodedString = [self.event.venu mapAddress];
	
	NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				   NULL,
																				   (CFStringRef)unencodedString,
																				   NULL,
																				   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				   kCFStringEncodingUTF8 );
	
	// bring up the map application so that the
	// venue location is displayed. User can then get
	// driving directions from there.
	
    NSString *mapUrl = [@"http://maps.google.com/maps?q=" stringByAppendingString:encodedString];
	
	[encodedString release]; // Build and analyise told me that it was leaking
	
	return mapUrl;
}


-(IBAction)shareWithFriends:(id)sender
{
	if([MFMailComposeViewController canSendMail])
	{
		iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication];
		
		
		// compose the subject line
		//
		NSString *subject = [NSString stringWithFormat:@"%@ %@ %@ event on %@",
							 app.teamName, self.event.teamName, self.event.sportName,
							 [self.event longDateTime]];
		
		// compose the body of the message
		//
		NSString *message = [NSString stringWithFormat:@"I wanted to let you know about the %@ %@ %@ event at %@ on %@. The event is located at %@. <a href=\"%@\">Click here</a> for a map and directions.",
							 app.teamName, self.event.teamName, self.event.sportName,
							 self.event.venu.venuName, [self.event longDateTime],
							 [self.event.venu mapAddress], [self mapUrl]];
		
		MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
		
		controller.mailComposeDelegate = self;
		
		[controller setSubject:subject];
		[controller setMessageBody:message isHTML:YES];
		
		//[self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
		
		[controller release];
	}
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error
{
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UIActionSheet Methods


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:         // directions
            [self getDirections:nil];
            break;
            
        case 2:         // calendar or cancel depending on the list length
            if(actionSheet.cancelButtonIndex != 2)
            {
                [self addEventToCalendar:nil];
            }
            break;
            
        case 0:         // email to friend
            [self shareWithFriends:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Calendar Methods

- (void)addEventToCalendar:(id)sender
{
    Boolean is60 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
    
    if(is60)
    {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
        {
            if(granted)
            {
                // make sure that the event dialog is run on the UI thread
                //
                [self performSelectorOnMainThread:@selector(doAddEventToClendar) withObject:self waitUntilDone:NO ];
            }
        }];
    }
    else
    {
        // make sure that the event dialog is run on the UI thread
        //
        [self performSelectorOnMainThread:@selector(doAddEventToClendar) withObject:self waitUntilDone:NO ];
    }
    
}

-(void)doAddEventToClendar
{

	// When add button is pushed, create an EKEventEditViewController to display the event.
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    
	
	// set the addController's event store to the current event store.
	addController.eventStore = self.eventStore;
    
    // set the values for the event we are creating
    //
    addController.event.title = [NSString stringWithFormat:@"%@ %@ %@", self.event.teamName, self.event.sportName, self.event.eventName];
    addController.event.location = [NSString stringWithFormat:@"%@, %@", self.event.venu.address1, self.cityStateZip.text];
    addController.event.startDate = self.event.eventDateTime;
    addController.event.endDate = [self.event.eventDateTime dateByAddingTimeInterval:5400];
    
	// present EventsAddViewController as a modal view controller
	//
    //[self presentModalViewController:addController animated:YES];
	[self presentViewController:addController animated:YES completion:nil];
    
	addController.editViewDelegate = self;
	[addController release];
}

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
//
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
    NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing.
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store,
            //
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];

			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store,
			//
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];

			break;
			
		default:
			break;
	}
    
	// Dismiss the modal view controller
    //
	//[controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
