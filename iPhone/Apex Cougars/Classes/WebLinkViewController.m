//
//  WebLinkViewController.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/18/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "WebLinkViewController.h"
#import "NewsLink.h"


@implementation WebLinkViewController

@synthesize webView;
@synthesize urlToView;

@synthesize activityIndicator;
@synthesize stopButton;
@synthesize reloadButton;
@synthesize backButton;
@synthesize forwardButton;
@synthesize adView;

- (void)dealloc 
{
	[self.webView release];
	[self.urlToView release];
	[self.adView release];
	[self.activityIndicator release];
	[self.stopButton release];
	[self.reloadButton release];
	[self.backButton release];
	[self.forwardButton release];
	
    [super dealloc];
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	
	//set the url to load for the web view
	//
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlToView]];
	
	[self.adView loadAd];
	
	[self.webView loadRequest:request];
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
	/*
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	self.webView = nil;
	self.urlToView = nil;
	
	self.activityIndicator = nil;
	self.stopButton = nil;
	self.reloadButton = nil;
	self.backButton = nil;
	self.forwardButton = nil;
	 */
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self.activityIndicator startAnimating];
	
	self.reloadButton.enabled = NO;
	self.stopButton.enabled = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.activityIndicator stopAnimating];
	
	self.reloadButton.enabled = YES;
	self.stopButton.enabled = NO;
	
	self.backButton.enabled = self.webView.canGoBack;
	self.forwardButton.enabled = self.webView.canGoForward;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{	
	[self webViewDidFinishLoad:self.webView];	
}

@end
