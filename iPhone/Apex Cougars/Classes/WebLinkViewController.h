//
//  WebLinkViewController.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/18/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdImageView.h"

////////////
//
// NOTE: This class is only for HTTP:// type links
//
////////////

@interface WebLinkViewController : UIViewController <UIWebViewDelegate>
{
	// outlets for the view
	//
	UIActivityIndicatorView *activityIndicator;
	UIBarButtonItem			*stopButton;
	UIBarButtonItem			*reloadButton;
	UIBarButtonItem			*backButton;
	UIBarButtonItem			*forwardButton;
	UIWebView				*webView;
	AdImageView				*adView;
	
	NSString	*urlToView;
}

@property(nonatomic,retain)IBOutlet UIWebView				*webView;
@property(nonatomic,retain)IBOutlet AdImageView				*adView;
@property(nonatomic,retain)NSString							*urlToView;

@property(nonatomic,retain)IBOutlet UIBarButtonItem			*stopButton;
@property(nonatomic,retain)IBOutlet UIBarButtonItem			*reloadButton;
@property(nonatomic,retain)IBOutlet UIBarButtonItem			*backButton;
@property(nonatomic,retain)IBOutlet UIBarButtonItem			*forwardButton;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView	*activityIndicator;

@end
