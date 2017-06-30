//
//  iAthletics_FrameworkAppDelegate.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/10/10.
//  Copyright Appapro 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAthleticsApplication.h"


@interface iAthletics_FrameworkAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    iAthleticsApplication   *app;
    
    // members to handle APNS
    //
    NSMutableDictionary *apnsViews;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic,retain)UINavigationController *navigationController;

@property(nonatomic,retain)NSMutableDictionary *apnsViews;
@property(nonatomic,retain)iAthleticsApplication *app;


-(void)handleApplication:(UIApplication *)appliction alertWithOptions:(NSDictionary *)options appWasRunning:(Boolean)wasRunning;

@end

