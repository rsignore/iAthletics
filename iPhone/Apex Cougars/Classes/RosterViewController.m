//
//  RosterViewController.m
//  Apex Athletics
//
//  Created by Robert Signore on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RosterViewController.h"
#import "RosterCell.h"
#import "TeamRosterService.h"
#import	"Athlete.h"

@implementation RosterViewController

@synthesize teamId;
@synthesize fullTeamName;
@synthesize athletes;
@synthesize myTableView;


#pragma mark Constructors / Destructors

-(id)initWithTeamId:(NSInteger)anId teamName:(NSString *)aName
{
	self = [super initWithNibName:@"RosterViewController" bundle:nil];
	
	self.teamId = anId;
	
	self.fullTeamName = aName;
    
    self.showLoadingDialog = true;
	
	return self;
}

- (void)dealloc 
{
	[self.fullTeamName release];
	[self.athletes release];
	[self.myTableView release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

-(void)loadData
{	
	[super loadData];
	// get the roster from the service
	//
	TeamRosterService *svc = [[TeamRosterService alloc]
							  initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
	
	NSArray *unsortedArray = [svc requestServiceWithTeamId:self.teamId];
	
	self.athletes = [unsortedArray sortedArrayUsingSelector:@selector(compare:)];
			
	[svc release];
}

-(void)finishedLoadData
{
	[super finishedLoadData];
	
	if([self.athletes count] == 0)
	{
		UIAlertView *alert;
		
		alert = [[[UIAlertView alloc] initWithTitle:@"No roster information found." message:nil 
										   delegate:nil cancelButtonTitle:@"Ok" 
								  otherButtonTitles: nil] autorelease];
		
		[alert show];
	}
	else 
	{
		[self.myTableView reloadData];
	}
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return [self.athletes count];

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger row = [indexPath	row];
    
    static NSString *CellIdentifier = ROSTER_CELL_ID;
    
    RosterCell *cell = (RosterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RosterCell" 
							owner:self options:nil];
        for(id oneObject in nib)
		{
			if([oneObject isKindOfClass:[RosterCell class]])
			{
				cell = (RosterCell *)oneObject;
			}
		}		
	}
	
	Athlete *athlete = [self.athletes objectAtIndex:row];

	cell.playerName.text = athlete.name;
	cell.playerNumber.text = athlete.number;
	cell.playerClass.text = athlete.grade;
	cell.playerPosition.text = athlete.positions;
	cell.playerHeight.text = athlete.height;
	cell.playerWeight.text = athlete.weight;			

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ROSTER_ROW_HEIGHT;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
/*    
    // Relinquish ownership any cached data, images, etc that aren't in use.
	self.fullTeamName = nil;
	self.athletes = nil;
	self.myTableView = nil;
*/
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end

