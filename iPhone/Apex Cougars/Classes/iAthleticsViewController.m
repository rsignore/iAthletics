    //
//  iAthleticsViewComtroller.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/22/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "iAthleticsViewController.h"
#import "iAthleticsApplication.h"
#import "SplashAdViewController.h"


@implementation iAthleticsViewController

@synthesize loadMessage;
@synthesize adView;
@synthesize showLoadingDialog;

-(id)init
{
    if((self = [super init]))
    {
        self.showLoadingDialog = true;
    }
    
    return self;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.showLoadingDialog = true;
    }
    
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [self startLoadData];
}

-(void)startLoadData
{
    if(self.showLoadingDialog == true)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading Data\nPlease Wait..." message:nil
                                                       delegate:nil cancelButtonTitle:nil 
                                              otherButtonTitles: nil];
        
        self.loadMessage = alert;
        [alert show];
        [alert release];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] 
                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        // Adjust the indicator so it is up a few pixels from the bottom of the alert
        //
        indicator.center = CGPointMake(self.loadMessage.bounds.size.width / 2, self.loadMessage.bounds.size.height - 50);
        
        [self.loadMessage addSubview:indicator];
        [indicator startAnimating];
        
        [indicator release];
    }
	
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
	// this method is blank. Implement in subclasses.
}

-(void)finishedLoadData
{
	// turn the network indicator off
	//
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    if(self.showLoadingDialog == true)
    {
        // turn the loading dialog box off
        //
        [loadMessage dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    // do we need to show a splash ad?
    //
    // get the iAthleticsApplication object
	//
	iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication]; 
    if(app.hasSplash && app.showSplash)
    {
        // reset the show splash flag. it will get reset when the app re-launches
        //
        app.showSplash = false; 
        
        // check to make sure we're not returning from a clicked on splash ad
        //
        if(!app.clickedSplash)
        {
        
            // show the splash ad
            //
            SplashAdViewController *splashView = [[SplashAdViewController alloc]initWithNibName:@"SplashAdViewController" bundle:nil];			
        
            
            [self presentViewController:splashView animated:YES completion: nil];
            
            [splashView release];
        }
        
        app.clickedSplash = false;
    }
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	
	[self.adView loadAd];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)adClicked:(id)sender
{
	
}

- (void)didReceiveMemoryWarning 
{
	/*
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	self.loadMessage = nil;
	 */
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{	
	[self.loadMessage release];
	[self.adView release];
	
	[super dealloc];
}


@end
