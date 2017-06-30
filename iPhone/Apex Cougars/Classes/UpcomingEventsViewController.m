//
//  UpcomingEventsViewController.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/19/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "UpcomingEventsViewController.h"
#import "UpcomingEventsService.h"
#import "EventViewController.h"


@implementation UpcomingEventsViewController

@synthesize events;
@synthesize dates;
@synthesize	eventViews;
@synthesize myTableView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad]; // will call load data 

	self.title = @"Upcoming Events";
	
	// change the upper left back button to just the word back
	// when child pages are displayed
	//
	UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];	
	self.navigationItem.backBarButtonItem = backBar;
	[backBar release];
	
	// allocate the dictionary that holds the refencences
	// to the event views ready
	//
	NSMutableDictionary *newDict = [[NSMutableDictionary alloc]initWithCapacity:100];
	self.eventViews = newDict;
	
	[newDict release];
}

-(void)loadData
{
	[super loadData];
	
	UpcomingEventsService *svc = [[UpcomingEventsService alloc]
								  initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
	
	[svc requestService];
	
	// sort the keys which are the day headings in the table view
	//
	if(svc.events != nil)
	{
		self.events = svc.events;
	}
	
	[svc release];
}

-(void)finishedLoadData
{
	[super finishedLoadData];
	
	[self sortData];
	
    // 5-22-11
    //
    // I'm not sure this check is necessary because the only way to see events from the home screen is when there is 
    // at least one upcoming event.
    //
    /*
	if([self.events count] == 0)
	{
		UIAlertView *alert;
		
		alert = [[[UIAlertView alloc] initWithTitle:@"No schedule information found." message:nil 
										   delegate:nil cancelButtonTitle:@"Ok" 
								  otherButtonTitles: nil] autorelease];
		
		[alert show];
	}
	else 
	*/
    {
		[self.myTableView reloadData];
	}
}


NSInteger sortDateString(NSString *s1, NSString *s2, void *context)
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	
	[dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
	
	NSDate *d1 = [dateFormatter dateFromString:s1]; 
	NSDate *d2 = [dateFormatter dateFromString:s2];
	
	[dateFormatter release];
	
	return [d1 compare:d2];
}

-(void)sortData
{
	// sort the event keys
	//
	NSArray *sortArray = [self.events allKeys];
		
	NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:50];
	self.dates =  newArray;
	[newArray release];
	
	[self.dates addObjectsFromArray:[sortArray sortedArrayUsingFunction:sortDateString context:nil]];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString	*sectionTitle = nil;
	
	if(self.dates != nil)
	{
		sectionTitle = [self.dates objectAtIndex:section];
	}
	
	return sectionTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	NSInteger retval = 0;
    // Return the number of sections.
	//
	if(self.dates != nil)
	{
		retval = [self.dates count];
	}
    return retval;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger retval = 0;
	
	if(self.dates != nil)
	{
		NSString *key = [self.dates objectAtIndex:section];
		
		NSArray *eventsForDay = [self.events objectForKey:key];
		
		if(eventsForDay != nil)
		{
			retval = [eventsForDay count];
		}
	}
	
    return retval;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSArray *dayArray = [self.events objectForKey:[self.dates objectAtIndex:[indexPath section]]];
	AppEvent *event = [dayArray objectAtIndex:[indexPath row]];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@: %@ %@", [event time], event.teamName, event.sportName];
	cell.detailTextLabel.text = event.eventName;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSArray *dateKey = [self.dates objectAtIndex:[indexPath section]];
	NSArray *eventsForDate = [self.events objectForKey:dateKey];
	
	AppEvent *theEvent = [eventsForDate objectAtIndex:[indexPath row]];
	
	// see if we have already created an eventView for this event.
	// the key is the event id
	//
	NSString *eventKey = [NSString stringWithFormat:@"%d", theEvent.eventId];
	
	EventViewController *eventView = [self.eventViews objectForKey:eventKey];
	
	// if we did not find the eventViewController then allocate one
	//
	if(eventView == nil)
	{
//		eventView = [[[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil]autorelease];
        
        //display the view controler with the map on it
        //
        eventView = [[[EventViewController alloc] initWithNibName:@"MapEventViewController" bundle:nil]autorelease];
		
		[self.eventViews setObject:eventView forKey:eventKey];
	}
	
	eventView.event = theEvent;

    // Pass the selected object to the new view controller.
	//
	[self.navigationController pushViewController:eventView animated:YES];

}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
	/*
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	self.events = nil;
	self.eventViews = nil;
	self.dates = nil;
	self.myTableView = nil;
	 */
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{	
	[self.events release];
	[self.eventViews release];
	[self.dates	 release];
	[self.myTableView release];
	
	[super dealloc];
}


@end

