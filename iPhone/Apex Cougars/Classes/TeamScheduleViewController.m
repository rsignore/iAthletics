//
//  TeamScheduleViewController.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/21/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "TeamScheduleViewController.h"
#import "TeamScheduleService.h"
#import "ResultViewController.h"



@implementation TeamScheduleViewController

@synthesize teamId;
@synthesize completedEvents;
@synthesize resultViews;

- (void)viewDidLoad 
{
	// super viewDidLoad will call our load data
	//
    [super viewDidLoad];
	
	self.title = @"Schedule/Results";
    
    // allocate the dictionary that holds the refencences
	// to the COMPLETED (Results) event views
	//
	NSMutableDictionary *newDict = [[NSMutableDictionary alloc]initWithCapacity:25];
	self.resultViews = newDict;
	
	[newDict release];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

-(void)finishedLoadData
{
	[super finishedLoadData];
	
	// at this point the view is aware of the 
	// upcoming events, but not the past events
	// Add those events to the begging of the 
	// self.dates array and to the mutable dictionary
	//
	if(self.completedEvents != nil)
	{
		// add the word results to the dates array at the beginning
		//
		[self.dates insertObject:@"Results" atIndex:0];
		
		// now add the events in the results array to the events
		// dictionary
		//
		[self.events setObject:self.completedEvents forKey:@"Results"];
	}
    
    // check to see if we loaed any data. If there were no results or upcoming events display 
    // a message
    //
    if([self.events count] == 0)
	{
		UIAlertView *alert;
		
		alert = [[[UIAlertView alloc] initWithTitle:@"No schedule information available." message:nil 
										   delegate:nil cancelButtonTitle:@"Ok" 
								  otherButtonTitles: nil] autorelease];
		
		[alert show];
	}
	
	[self.myTableView reloadData];
}

-(void)dealloc
{
	[self.completedEvents release];
    [self.resultViews release];
	
	[super dealloc];
}

- (void)didReceiveMemoryWarning 
{
	/*
	[super didReceiveMemoryWarning];
	
	self.completedEvents = nil;
	 */
}

// overloaded load data. Calls the team schedule service
//
-(void)loadData
{
	TeamScheduleService *svc = [[TeamScheduleService alloc]
								initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
	
	[svc requestServiceWithTeamId:self.teamId];
	
	
	self.events = svc.events;
	self.completedEvents = svc.resultsArray;
	
	[svc release];
}

// Customize the appearance of results cels
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell;
	
	if([indexPath section] == 0 && self.completedEvents != nil)
	{
		static NSString *CellIdentifier = @"ResultsCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		
		AppEvent *event = [self.completedEvents objectAtIndex:[indexPath row]];
		
		cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [event shortDate], event.eventName];
		cell.detailTextLabel.text = event.results;
        
        // check the result ID. If the ID is > 0, then show a (>) on the right of the cell
        //
        if(event.resultId > 0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            // set the selection stype to blue
            //
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            // since there are no results, set the selection style to noting
            //
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
	}
	else
	{
		static NSString *CellIdentifier = @"UpcomingCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		
		NSArray *dayArray = [self.events objectForKey:[self.dates objectAtIndex:[indexPath section]]];
		AppEvent *event = [dayArray objectAtIndex:[indexPath row]];
		
		cell.textLabel.text = event.eventName;
		cell.detailTextLabel.text = [event time];
		
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // check to see if the user selected an upcoming event. If so let the
    // super class (UpcomingEventsViewController) handle it
    //
	if([indexPath section] > 0 || ([indexPath section] == 0 && self.completedEvents == nil))
	{
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
    else
    {
        // a completed event was chosen, show the result view
        //
        [self showCompletedEvent:(NSIndexPath *)indexPath];
    }
}


// this method is used to display the view for a completed event
//
-(void)showCompletedEvent:(NSIndexPath *)indexPath
{
    AppEvent *theEvent = [self.completedEvents objectAtIndex:[indexPath row]];
    
    // only show the completed event view if there is an associated result
    //
    if(theEvent.resultId > 0)
    {
        
        // see if we have already created an eventView for this event.
        // the key is the event id
        //
        NSString *eventKey = [NSString stringWithFormat:@"%d", theEvent.resultId];
        
        ResultViewController *resultView = [self.resultViews objectForKey:eventKey];
        
        // if we did not find the eventViewController then allocate one
        //
        if(resultView == nil)
        {
            //display the result view
            //
            resultView = [[[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil]autorelease];

            
            [self.resultViews setObject:resultView forKey:eventKey];
        }
        
    	resultView.event = theEvent;
        
        // Pass the selected object to the navigation controller.
        //
        [self.navigationController pushViewController:resultView animated:YES];
    }
}
@end
