//
//  ResultViewController.h
//  iAthletics
//
//  Created by Robert Signore on 11/16/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAthleticsViewController.h"
#import "AppEvent.h"

@interface ResultViewController : iAthleticsViewController
{
    // outlets for the view
	//
	UIImageView	*sportIcon;
	UILabel		*teamName;
	UILabel		*eventName;
    UILabel     *resultTitle;
    UIWebView   *resultDetails;
    
    // data to display
    //
    AppEvent    *event;
    NSInteger   resultId;
}

@property(nonatomic,retain)IBOutlet UIImageView *sportIcon;
@property(nonatomic,retain)IBOutlet UILabel     *teamName;
@property(nonatomic,retain)IBOutlet UILabel     *eventName;
@property(nonatomic,retain)IBOutlet UILabel     *resultTitle;
@property(nonatomic,retain)IBOutlet UIWebView   *resultDetails;

@property(nonatomic,retain)AppEvent             *event;
@property(nonatomic,assign)NSInteger            resultId;

@end
