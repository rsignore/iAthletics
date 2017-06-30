//
//  iAthleticsViewComtroller.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/22/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdImageView.h"


@interface iAthleticsViewController : UIViewController 
{
	UIAlertView *loadMessage;
	
	AdImageView *adView;
    
    Boolean showLoadingDialog;
}

@property(nonatomic,retain)UIAlertView			*loadMessage;
@property(nonatomic,retain)IBOutlet AdImageView *adView;
@property(nonatomic,assign)Boolean showLoadingDialog;

-(IBAction)adClicked:(id)sender;

// ABSTRACT methods that must be implemented by
// deriving classes
//

// this method is called by viewDidLoad to load any needed
// data. It is called on a background thread. at the end of
// the implemented method call finishLoadData on the main thread.
//
- (void)loadData;

// call this method to dismiss the network activity indicator
// and to dismiss the dialog box.
//
-(void)finishedLoadData;

// private function that kick off the background thread
//
-(void)preLoadData;

-(void)startLoadData;

@end
