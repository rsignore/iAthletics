//
//  SeasonViewComtroller.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/15/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "SeasonViewController.h"
#import "SportListItem.h"
#import "TeamViewController.h"


@implementation SeasonViewController

@synthesize seasonId;
@synthesize seasonName;
@synthesize	teamList;
@synthesize sportList;

@synthesize myTableView;

#pragma mark Constructors

-(id)initWithSeasonId:(NSInteger)anId seasonName:(NSString *)name
{
	self = [super initWithNibName:@"SeasonViewController" bundle:nil];
	
	self.seasonId = anId;
	self.seasonName = name;
	
	return self;
}


NSInteger stringSort(NSString *s1, NSString *s2, void *context)
{
	return [s1 compare:s2];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad]; // this will call load data
	
	self.title = [self.seasonName stringByAppendingString:@" Teams"];
		
}

// called on the background thread 
//
-(void)loadData
{	
	// get the list of teams from the service
	//
	SportListService *svc = [[SportListService alloc]
		initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
	
	self.teamList = [svc requestServiceWithSeasonId:self.seasonId];
	
	if(self.teamList != nil)
	{
		NSArray *arrayToSort = [self.teamList allKeys];
		
		self.sportList = [arrayToSort sortedArrayUsingFunction:stringSort context:NULL];
	}
	
	[svc release];
}

// this is called on the main thread once all the data
// is loaded on the background thread
//
-(void)finishedLoadData
{
	[super finishedLoadData];
	
	[self.myTableView reloadData];
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
	[self.seasonName release];
	[self.teamList release];
	[self.sportList release];
	
	[self.myTableView release];

	[super dealloc];
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
    static NSString *CellIdentifier = @"TeamCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
    }	
	
	// get the sport name
	//
	NSString *sportName = [self.sportList objectAtIndex:section];
	
	// get the list of teams for that sport
	//
	NSArray *teams = [self.teamList objectForKey:sportName];
	
	// find the team data to display
	//
	SportListItem *team = [teams objectAtIndex:row];
	
	cell.textLabel.text = team.teamName;
	
	// if there is an image then display it
	//
	UIImage *image = [team.image getImage];
	if(image != nil)
	{
		cell.imageView.image = image;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSString *key = [self.sportList objectAtIndex:section];
	
	NSArray *teams = [self.teamList objectForKey:key];
	
	return [teams count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger numSections = 0;
	
	if(self.sportList != nil)
	{
		numSections = [self.sportList count];
	}
	
	return numSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *headerTitle = nil;
	
	if(self.sportList != nil)
	{
		if(section < [self.sportList count])
		{
			headerTitle = (NSString *)[self.sportList objectAtIndex:section];
		}
	}
	
	return headerTitle;
}

#pragma mark -
#pragma mark TableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSUInteger	section = [indexPath section];
	
	// get the sport name
	//
	NSString *sportName = [self.sportList objectAtIndex:section];
	
	// get the list of teams for that sport
	//
	NSArray *teams = [self.teamList objectForKey:sportName];
	
	// find the team data to display
	//
	SportListItem *team = [teams objectAtIndex:row];
	NSString *teamName = team.teamName;
	
	// use the full name for the title of the new view
	//
	NSString *fullTeamName = [NSString stringWithFormat:@"%@ %@", teamName, sportName];
	
	TeamViewController *teamView = [[TeamViewController alloc]initWithTeamId:team.teamId teamName:fullTeamName];
	
	[self.navigationController pushViewController:teamView animated:YES];	
	
	[teamView release];
}

@end
