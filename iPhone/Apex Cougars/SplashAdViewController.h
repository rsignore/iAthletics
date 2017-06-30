//
//  SplashAdViewControllerViewController.h
//  iAthletics
//
//  Created by Robert Signore on 7/8/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAthleticsImage.h"


@interface SplashAdViewController : UIViewController <UIActionSheetDelegate>
{
    UIImageView     *splashImageView;
    
    NSString        *splashUrl;
	iAthleticsImage *splashImage;
}

@property(nonatomic,retain)IBOutlet UIImageView *splashImageView;

@property(nonatomic,retain)NSString             *splashUrl;
@property(nonatomic,retain)iAthleticsImage      *splashImage;

- (IBAction)closeButtonPressed:(id)sender;

@end
