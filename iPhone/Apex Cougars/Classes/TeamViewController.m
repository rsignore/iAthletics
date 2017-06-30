//
//  TeamViewController.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/16/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamDetailService.h"
#import	"WebLinkViewController.h"

@implementation TeamViewController

@synthesize fullTeamName;
@synthesize teamId;
@synthesize teamInfo;
@synthesize teamPhoto;
@synthesize myTableView;

#pragma mark Constructors

-(id)initWithTeamId:(NSInteger)anId teamName:(NSString *)aName
{
	self = [super initWithNibName:@"TeamViewController" bundle:nil];
	
	self.teamId = anId;
	
	self.fullTeamName = aName;
	
	return self;
	
}

- (void)dealloc 
{
	[self.fullTeamName release];
	[self.teamInfo release];
	[self.teamPhoto	release];
	[self.myTableView release];

	[super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.title = self.fullTeamName;
	
	// change the upper left back button to just the word back
	// when child pages are displayed
	//
	UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
	
	self.navigationItem.backBarButtonItem = backBar;
	
	[backBar release];	
}

// called on a background thread

-(void)loadData
{
	[super loadData];
	
	// get the team info from the service
	//
	TeamDetailService *svc = [[TeamDetailService alloc]
							 initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
	
	self.teamInfo = [svc requestServiceWithTeamId:self.teamId];
	
	[svc release];
}

// this is called on the main thread once all the data
// is loaded on the background thread
//
-(void)finishedLoadData
{
	[super finishedLoadData];
	
	[self.myTableView reloadData];
	
	// set the team image
	//
	UIImage *teamPhotoImage = [self.teamInfo.photo getImage];
	if(teamPhotoImage != nil)
	{
		self.teamPhoto.image = teamPhotoImage;
	}	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{

}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *newCell = nil;
	
	NSUInteger section = [indexPath section];
	
	switch(section)
	{
		case SECTION_TEAM_INFO:
			newCell = [self tableView:tableView cellForTeamInfoRow:[indexPath row]];
			break;
		case SECTION_TEAM_NEWS:
			newCell = [self tableView:tableView cellForTeamNewsRow:[indexPath row]];
			break;
	}
	
	return newCell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForTeamInfoRow:(NSUInteger)row
{
	UITableViewCell *cell = nil;
		
	switch(row)
	{
		case TEAM_INFO_ROSTER:
		{
			NSString *cellId = @"TeamInfoCell";
			cell = [tableView dequeueReusableCellWithIdentifier:cellId];
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
											   reuseIdentifier:cellId] autorelease];
			}
			cell.textLabel.text = @"Team Roster";
		}
			break;
		case TEAM_INFO_SCHEDULE:
		{
			NSString *cellId = @"TeamScheduleCell";
			cell = [tableView dequeueReusableCellWithIdentifier:cellId];
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
											   reuseIdentifier:cellId] autorelease];
			}			
			cell.textLabel.text = @"Schedule/Results";
			cell.detailTextLabel.text = self.teamInfo.overallResults;
		}
			break;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForTeamNewsRow:(NSUInteger)row
{
    static NSString *CellIdentifier = @"NewsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
    }	
	
	NewsLink *link = (NewsLink *)[self.teamInfo.newsLinks objectAtIndex:row];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numRows = 0;

	switch(section)
	{
		case SECTION_TEAM_INFO:
			numRows = NUM_TEAM_INFO_ROWS;
			break;
			
		case SECTION_TEAM_NEWS:
			numRows = [self.teamInfo.newsLinks count];
			break;
	}

	return numRows;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return NUM_SECTIONS;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString	*sectionTitle = nil;
	
	switch(section)
	{
		case SECTION_TEAM_NEWS:
			if([self.teamInfo.newsLinks count] > 0)
			{
				sectionTitle = @"Team news and links";
			}
			break;
			
		case SECTION_TEAM_INFO:
			sectionTitle = @"Team information";
			break;
	}
	return sectionTitle;
}

#pragma mark -
#pragma mark TableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	switch(section)
	{
		case SECTION_TEAM_INFO:
		{
			switch(row)
			{
				// show the roster view
				//
				case TEAM_INFO_ROSTER:
				{
					RosterViewController *rosterView = [[RosterViewController alloc]initWithTeamId:self.teamId teamName:self.fullTeamName];
					
					rosterView.title = [NSString stringWithFormat:@"%@ Roster", self.fullTeamName];
					[self.navigationController pushViewController:rosterView animated:YES];
					
					[rosterView release];
					break;
				}
					
				case TEAM_INFO_SCHEDULE:
				{

					TeamScheduleViewController *scheduleView = [[TeamScheduleViewController alloc]initWithNibName:@"UpcomingEventsViewController" bundle:nil];
					scheduleView.teamId = self.teamId;
					
					[self.navigationController pushViewController:scheduleView animated:YES];

					[scheduleView release];
					break;
				}
			}
			break;
		}
			
		case SECTION_TEAM_NEWS:
		{
			NewsLink *newsLink = [self.teamInfo.newsLinks objectAtIndex:row];
			
			switch(newsLink.linkType)
			{
				case LINK_TYPE_WEBSITE:
				{

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
	}

}


@end
