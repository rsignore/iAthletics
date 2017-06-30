//
//  ResultViewController.m
//  iAthletics
//
//  Created by Robert Signore on 11/16/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultDetailsService.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

@synthesize sportIcon;
@synthesize teamName;
@synthesize eventName;
@synthesize resultTitle;
@synthesize resultDetails;
@synthesize resultId;

@synthesize event;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // do not show the loading dialog
        //
        self.showLoadingDialog = false;
        
        self.event = nil;
        self.resultId = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Event Results";
}

-(void)loadData
{
    [super loadData];
    
    // if the view was given a resultId then the data needs to be loaded from the network
    //
    if(self.resultId != 0)
    {
        ResultDetailsService *svc = [[ResultDetailsService alloc]
                                      initWithApplication:(iAthleticsApplication *)[UIApplication sharedApplication]];
        
        [svc requestServiceWithResultId:self.resultId];
        
        self.event =svc.nextEvent;
        
        [svc release];
        self.resultId = 0;
    }
}

-(void)finishedLoadData
{
    [super finishedLoadData];
    
    //set the views outlets with the proper information in the event is known at this point
    //
    if(self.event != nil)
    {
        self.sportIcon.image = [self.event.image getImage];
        self.teamName.text = [NSString stringWithFormat:@"%@ %@", self.event.teamName, self.event.sportName];
        self.eventName.text = self.event.eventName;
        self.resultTitle.text = self.event.results;
        
        // set up the web view portion of the screen too
        //
        //set the url to load for the web view
        //
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.event.resultDetailsUrl]];
        
        
        [self.resultDetails loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
