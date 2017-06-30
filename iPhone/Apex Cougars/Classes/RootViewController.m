//
//  RootViewController.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/10/10.
//  Copyright Appapro 2010. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import "RootViewController.h"
#import "iAthleticsApplication.h"
#import "iAthleticsImage.h"
#import "SeasonViewController.h"
#import	"WebLinkViewController.h"
#import	"GetAppInfoService.h"

@implementation RootViewController

@synthesize mainMenuTable;

@synthesize seasons;
@synthesize newsLinks;
@synthesize	nextEvent;

@synthesize status;
@synthesize appMessage;
@synthesize currentVersionUrl;
@synthesize loadDateTime;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    self.showLoadingDialog = true;
    
    [super viewDidLoad]; // this will call my load data method

	iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication];
	
	self.title = app.teamName;
    
    // save a timestamp for when we last loaded data for this view.
    //
    self.loadDateTime = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated 
{
    // call the super class implementation
    //
    [super viewWillAppear:animated];
	
 	// get the iAthleticsApplication object
	//
	iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication];  
    
    // check to see if I've been made visible after the app has reappeared from a background/foreground
    // transition. 
	//
    if([app.startDateTime compare:self.loadDateTime] == NSOrderedDescending)	
    {
        [self startLoadData];
        
        // save a timestamp for when we last loaded data for this view.
        //
        self.loadDateTime = [NSDate date];
    }
}

#pragma mark -
#pragma mark Services Functions

// this method is performed on a background thread
//
-(void)loadData
{
	[super loadData];
	
	// get the app status info to see if we should continue
	// to load any data.
	//
	GetAppInfoService *appStat = [[GetAppInfoService alloc] init];
	
	[appStat requestService];
    
    // set the has splash ads flag on the app
	//
	iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication]; 
    app.hasSplash = appStat.hasSplashAds;
	
	//  If the message is unavailable then we should stop
	//
	if(appStat.status != nil && ([appStat.status compare:@"Available"] == NSOrderedSame))
	{
		//load the data
		//
		[self loadSeasonsData];
		[self loadNewsData];
		[self loadCalendarData];
	}
	
	// save the status information for display to the user later.
	//
	self.status = appStat.status;
	self.appMessage = appStat.message;
	self.currentVersionUrl = appStat.currentVersionUrl;
	
	[appStat release];
}

// this is called on the main thread once all the data
// is loaded on the background thread
//
-(void)finishedLoadData
{	
	[super finishedLoadData];
	
	//check the status flag and do the right thing
	//
	if(self.status == nil)
	{
		// this is a major problem
	}
	else if([self.status compare:@"Unavailable"] == NSOrderedSame)
	{
		// app is no longer available
		//
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Application unavailable" message:self.appMessage 
								   delegate:nil cancelButtonTitle:@"OK" 
						  otherButtonTitles: nil] autorelease];
		
		[alert show];
	}
	else // status == "Available"
	{
		// check to see if the message is Upgrade
		//
		if(self.appMessage != nil && [self.appMessage compare:@"Upgrade"] == NSOrderedSame)
		{
			// display the upgrade message
			//
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Upgrade available" 
											message:@"There is an upgrade available for the app. Would you like to upgrade now?"
															delegate:self cancelButtonTitle:@"No Thanks" 
												   otherButtonTitles:@"Upgrade.",nil] autorelease];
			
			[alert show];
			
		}
		else if(self.appMessage != nil && ([self.appMessage compare:@"Network"] == NSOrderedSame))
		{
			// not on the network
			//
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Not Connected" 
											message:@"This application requires Internet access. Attempting to load cached content..."
											delegate:nil cancelButtonTitle:@"OK" 
											otherButtonTitles: nil] autorelease];
			
			[alert show];			
		}
        
		// just run the program
		//
		[self.mainMenuTable reloadData];
        
        // see if the app was started by an alert and if so, show that view
        //
        iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication];
        
        if(app.showViewFirst)
        {
            [self.navigationController pushViewController:app.showViewFirst animated:YES];
            
            // just in case this view is loaded again, dont show the alert view again
            //
            app.showViewFirst = nil;
        }
        
        // was there a generic message sent to us that we should show
        //
        if(app.showAlertFirst != nil)
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:app.teamName message:app.showAlertFirst delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
            
            [alertView show];
            
            app.showAlertFirst = nil;
        }
	}
}

- (void) loadSeasonsData
{
	SeasonsService *seasonsSvc = [[SeasonsService alloc]
					  initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
	
	self.seasons = [seasonsSvc requestService];

	[seasonsSvc release];
}

- (void) loadNewsData
{
	NewsService *newsSvc = [[NewsService alloc]
						initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
	
	self.newsLinks = [newsSvc requestService];

	[newsSvc release];	
}

-(void)loadCalendarData
{
	NextEventService *eventSvc = [[NextEventService alloc]
					initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
	
	[eventSvc requestService];
	self.nextEvent = eventSvc.nextEvent;
	
	[eventSvc release];
}


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
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUM_SECTIONS;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger retVal = 0;
	
	switch(section)
	{
		case SECTION_TEAMS:
			if(seasons != nil)
			{
				return [seasons count];
			}
			break;
			
		case SECTION_CALENDAR:
			if(nextEvent != nil)
				retVal = 1;
			break;
			
		case SECTION_NEWS:
			if(newsLinks != nil)
			{
				return [newsLinks count];
			}
			break;
			
		case SECTION_SUPPORT:
			retVal = NUM_SUPPORT_ROWS;
			break;
			
	}
    return retVal;
}


// Customize the appearance of table view cells.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *returnCell = nil;
	NSUInteger section = [indexPath section];
	
	switch(section)
	{
		case SECTION_TEAMS:
			returnCell = [self cellForTeamsRow:tableView cellForRowAtIndexPath:indexPath];
			break;
		
		case SECTION_CALENDAR:
			returnCell = [self cellForCalendarRow:tableView cellForRowAtIndexPath:indexPath];
			break;
			
		case SECTION_NEWS:
			returnCell = [self cellForNewsRow:tableView cellForRowAtIndexPath:indexPath];
			break;
			
		case SECTION_SUPPORT:
			returnCell = [self cellForSupportRow:tableView cellForRowAtIndexPath:indexPath];
			break;
			
	}
	
	return returnCell;
}

// returns the cell for the news row of the table
//
- (UITableViewCell *)cellForNewsRow:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"NewsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier]autorelease] ;
    }	
	
	NewsLink *link = (NewsLink *)[self.newsLinks objectAtIndex:row];
	cell.textLabel.text = link.linkName;
	
	// if there is an image then display it
	//
	UIImage *image = [link.image getImage];
	if(image != nil)
	{
		cell.imageView.image = image;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;	
}

// returns the cell for the calendar row of the table
//
- (UITableViewCell *)cellForCalendarRow:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// assuming only one row in the calendar
	//
//	NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"CalendarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
									   reuseIdentifier:CellIdentifier] autorelease];
    }	
	
	cell.textLabel.text = @"Upcoming Events";
	
	//get the month and day of the next event from the eventDateTime field
	//
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components =
		[gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit) fromDate:self.nextEvent.eventDateTime];
	NSInteger day = [components day];
	NSInteger month = [components month];
	
	// format the detail text label with the next event's information
	//
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d/%d: %@ %@ %@", 
							month, day, self.nextEvent.teamName, 
							self.nextEvent.sportName, self.nextEvent.eventName];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	[gregorian release];
	
	return cell;	
}

// returns the cell for the teams row of the table
//
- (UITableViewCell *)cellForTeamsRow:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"SeasonCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
    }	
	
	AppSeason *season = (AppSeason *)[seasons objectAtIndex:row];
	cell.textLabel.text = season.seasonName;
	
	// if there is an image then display it
	//
	UIImage *image = [season.image getImage];
	if(image != nil)
	{
		cell.imageView.image = image;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

// Returns the cell for the Support section of the table
//
- (UITableViewCell *)cellForSupportRow:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"SupportCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	switch(row)
	{
		case SUPPORT_CONTACT_SUPPORT:
			cell.textLabel.text = @"Email technical support";
			break;
		case SUPPORT_SHARE_APP:
			cell.textLabel.text = @"Share app with friends";
			break;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	// Configure the cell.

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *retVal = nil;
	
	switch(section)
	{
		case SECTION_TEAMS:
			retVal = @"Teams";
			break;
			
		case SECTION_CALENDAR:
			retVal = @"Calendar";
			break;
			
		case SECTION_NEWS:
			retVal = @"News and Information";
			break;
			
		case SECTION_SUPPORT:
			retVal = @"Sharing & Support";
			break;
	}
	
	return retVal;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	switch(section)
	{
		case SECTION_TEAMS:
			[self handleTeamsSelectedRow:tableView indexPath:indexPath];
			break;

		case SECTION_CALENDAR:
		{
			UpcomingEventsViewController *eventsView = [[UpcomingEventsViewController alloc]initWithNibName:@"UpcomingEventsViewController" bundle:nil];			

			[self.navigationController pushViewController:eventsView animated:YES];

			[eventsView release];
			break;
		}
		case SECTION_NEWS:
		{
			NewsLink *newsLink = [self.newsLinks objectAtIndex:row];
			
			switch(newsLink.linkType)
			{
				case LINK_TYPE_WEBSITE:
				{
					// check to see if we have already created a view for this link
					//
					WebLinkViewController *webView = [[WebLinkViewController alloc]initWithNibName:@"WebLinkViewController" bundle:nil];
					
					// configure the web view
					//
					webView.urlToView = newsLink.linkUrl;
					webView.title = newsLink.linkName;
					
					[self.navigationController pushViewController:webView animated:YES];
					
					[webView release];
					break;
				}
					
				case LINK_TYPE_RSS:
					// send RSS feeds to Safari
					//
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:newsLink.linkUrl]];
					break;
			}
			break;
		}
			
		case SECTION_SUPPORT:
			[self handleSupportSelectedRow:tableView indexPath:indexPath];
			break;
			
	}
}

// handles the selection of a row in the teams section
//
- (void)handleTeamsSelectedRow:(UITableView *)tableVilew indexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	
	AppSeason *season = (AppSeason *)[self.seasons objectAtIndex:row];
	NSInteger seasonId = season.seasonId;
	NSString *seasonName = season.seasonName;
	
	SeasonViewController *seasonView = [[SeasonViewController alloc]initWithSeasonId:seasonId seasonName:seasonName];
	
	[self.navigationController pushViewController:seasonView animated:YES];
	
	[seasonView release];
}

// handles the selection of a row in the support section
//
- (void)handleSupportSelectedRow:(UITableView *)tableVilew indexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	
	switch(row)
	{
		case SUPPORT_CONTACT_SUPPORT:
			
			if([MFMailComposeViewController canSendMail])
			{
				iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication];
				NSString *toEmail = app.supportEmail;
				NSMutableString *subjectMut = [[NSMutableString alloc] initWithCapacity:256];

				
				[subjectMut setString:@"Technical support for "];
				[subjectMut appendString:app.teamName];
				
				NSString *subject = subjectMut;
				
				NSArray *recipients = [NSArray arrayWithObject:toEmail];
				
				MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
				
				controller.mailComposeDelegate = self;
				
				[controller setToRecipients:recipients];
				[controller setSubject:subject];
				
				//[self presentModalViewController:controller animated:YES];
                [self presentViewController:controller animated:YES completion:nil];
				
				[subjectMut release];				
				[controller release];
			}
			break;
		case SUPPORT_SHARE_APP:
			
			if([MFMailComposeViewController canSendMail])
			{
				iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication];
				NSMutableString *subjectMut = [[NSMutableString alloc] initWithCapacity:256];
				
				
				// compose the subject line
				//
				[subjectMut setString:@"Check out the iPhone app for the "];
				[subjectMut appendString:app.teamName];
				
				NSString *subject = subjectMut;
				
				// compose the body of the message
				//
				NSMutableString *messageMut = [[NSMutableString alloc] initWithCapacity:256];
				[messageMut setString:@"Check out this app for the "];
				[messageMut appendString:app.teamName];
				[messageMut appendString:@". You can download it <a href=\""];
				[messageMut appendString:app.applicationLink];
				[messageMut	appendString:@"\">from here</a>."];
				
				NSString *message = messageMut;
				
				MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
				
				controller.mailComposeDelegate = self;
				
				[controller setSubject:subject];
				[controller setMessageBody:message isHTML:YES];
				
				//[self presentModalViewController:controller animated:YES];
                [self presentViewController:controller animated:YES completion:nil];

				
				[subjectMut release];
				[messageMut release];
				[controller release];
			}
			break;
	}
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning 
{

}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
*/

- (void)dealloc 
{
	// controls
	//
	[self.mainMenuTable release];	
	
	// UI data
	//
	[self.seasons release];
	[self.newsLinks release];
	[self.nextEvent release];
    [self.loadDateTime release];

    [super dealloc];
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
#pragma mark UIAlertViewDeligate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
	if(buttonIndex == 1)
	{
		// send the upgrader URL to Safari
		//
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.currentVersionUrl]];
	}	
}

@end

