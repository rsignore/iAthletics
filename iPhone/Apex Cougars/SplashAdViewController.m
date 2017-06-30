//
//  SplashAdViewControllerViewController.m
//  iAthletics
//
//  Created by Robert Signore on 7/8/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import "SplashAdViewController.h"
#import "SplashService.h"

@interface SplashAdViewController ()

@end

@implementation SplashAdViewController

@synthesize splashImageView;
@synthesize splashImage;
@synthesize splashUrl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [self startLoadData];
}

-(void)startLoadData
{
	
	// turn the network indicator on
	//
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//load the data from the server on a background thread
	//
	[self performSelectorInBackground:@selector(preLoadData) withObject:nil];    
}

-(void)preLoadData
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self loadData];
	
	[pool release];	
	
	[self performSelectorOnMainThread:@selector(finishedLoadData) withObject:nil waitUntilDone:NO];
}

-(void)loadData
{
    SplashService   *splashService = [[SplashService alloc]init];
    
    [splashService requestService];
    
    self.splashImage = splashService.image;
    self.splashUrl = splashService.splashUrl;
    
    [splashService release];
	
}

-(void)finishedLoadData
{
	// turn the network indicator off
	//
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.splashImageView.image = [self.splashImage getImage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.splashUrl != nil)
    {
        UIApplication *sharedApp = [UIApplication sharedApplication];
        
        NSURL *webUrl = [NSURL URLWithString:self.splashUrl];
        
        if([sharedApp canOpenURL:webUrl] == YES)
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Support our sponsor"
                                                              delegate:self 
                                                     cancelButtonTitle:@"Cancel" 
                                                destructiveButtonTitle:nil 
                                                     otherButtonTitles:@"Web link",nil];
            [sheet showInView:self.view];
            
            [sheet release];
        }
    }
    
}

- (void)dealloc 
{
	[self.splashUrl release];
	[self.splashImage release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark UIActionSheet Methods


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        // send the web link to safari
        //
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.splashUrl]];

        //dismiss the view
        //
        [self dismissViewControllerAnimated:YES completion: nil];
        
        // set the flag that the user clicked the ad so that we don't render
        // another splash ad when we return to the app.
        //
        iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication];
        
        app.clickedSplash = true;
    }
}


@end
