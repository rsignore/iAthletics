//
//  iAthletics_FrameworkAppDelegate.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/10/10.
//  Copyright Appapro 2010. All rights reserved.
//

#import "iAthletics_FrameworkAppDelegate.h"
#import "RootViewController.h"
#import "iAthleticsApplication.h"
#import "UAirship.h"
#import "UAPush.h"
#import "ResultViewController.h"
#import "AudioToolbox/AudioServices.h"
#import "EventViewController.h"


@implementation iAthletics_FrameworkAppDelegate

@synthesize window;
@synthesize navigationController;

@synthesize apnsViews;
@synthesize app;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
    // Override point for customization after app launch
    //
    self.app = (iAthleticsApplication *)application;
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	// save some global variables from the info.plist file in the shared application
	//
//	iAthleticsApplication *app = (iAthleticsApplication *)application;
	
	// Get the main bundle for the app. 
	//
	NSBundle* mainBundle = [NSBundle mainBundle];
	
	if(mainBundle != nil)
	{
		NSString *appIdStr = [mainBundle objectForInfoDictionaryKey:@"iAthleticsAppId"];
		NSString *teamName = [mainBundle objectForInfoDictionaryKey:@"iAthleticsTeamName"];
		NSString *appVer = [mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
		NSString *serviceUrl = [mainBundle objectForInfoDictionaryKey:@"iAthleticsServiceUrl"];
		NSString *supportEmail = [mainBundle objectForInfoDictionaryKey:@"iAthleticsSupportEmail"];
		NSString *applicationLink = [mainBundle objectForInfoDictionaryKey:@"iAthleticsLinkToApplication"];
		
		if(applicationLink != nil)
		{
			app.applicationLink = applicationLink;
		}
		
		if(appIdStr != nil)
			app.appId = [appIdStr integerValue];
		
		if(teamName != nil)
			app.teamName = teamName;
		
		if(appVer != nil)
			app.appVersion = [appVer floatValue];
		
		if(serviceUrl != nil)
			app.serviceUrl = serviceUrl;
		
		if(supportEmail != nil)
			app.supportEmail = supportEmail;
		
	}
	
	// save the time the app started
	//
	app.startDateTime = [NSDate date];
    
    //Init Airship launch options
    //
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Register for notifications
    [[UAPush shared]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    //
    [UAirship takeOff:takeOffOptions];
    
    // create a dictionary to hold views started by APNS alerts
    //
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc]initWithCapacity:25];
    self.apnsViews = newDict;
    [newDict release];
    
    // did the app get started because of an alert
    //
    if(launchOptions != nil)
    {
        NSDictionary *alertOptions = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        [self handleApplication:application alertWithOptions:alertOptions appWasRunning:false];
    }
    
	return YES;
}
-(void)handleApplication:(UIApplication *)application alertWithOptions:(NSDictionary *)alertOptions appWasRunning:(Boolean)wasRunning
{
    // handle the alert if the app not running in the foreground
    //
    UIApplicationState appState = application.applicationState;
    if(appState != UIApplicationStateActive)
    {
        // result alert
        //
        NSString *resultId = [alertOptions objectForKey:@"resultId"];
        if(resultId != nil)
        {
            [self application:application showResultAlert:resultId appWasRunning:wasRunning];
        }
        
        // schedule change alert
        //
        NSString *scheduleId = [alertOptions objectForKey:@"scheduleId"];
        if(scheduleId != nil)
        {
            [self application:application showScheduleAlert:scheduleId appWasRunning:wasRunning];
        }
        else // It's a generic alert, or we do not know the type, so just show a dialog box with the message
        {
            // there was no attached alertOption (that we know about) so just display
            // an alert window, but don't play a sound
            //
            if(wasRunning == true) // i was running in the backgound and got activated by the user
            {
                [self application:application handleForegroundAlertWithOptions:alertOptions playSound:false appWasRunning:wasRunning];
            }
            else
            {
                // the app was not running, and we received a generic alert
                //
                [self application:application handleInactiveAlertWithOptions:alertOptions appWasRunning:wasRunning];
            }
        }
    }
    else  // i was the top application running
    {
        [self application:application handleForegroundAlertWithOptions:alertOptions playSound:true appWasRunning:wasRunning];
    }
}

-(void)application:(UIApplication *)application handleForegroundAlertWithOptions:(NSDictionary *)alertOptions playSound:(Boolean)playSound appWasRunning:(Boolean)wasRunning
{
    // get the message text from the aps dictionary
    //
    NSDictionary *aps = [alertOptions objectForKey:@"aps"];
    NSString *alertText = [aps objectForKey:@"alert"];
    
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:app.teamName message:alertText delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    
    // play a sound
    //
    if(playSound)
    {
        SystemSoundID soundID;
        NSString *soundFile = [[NSBundle
                                mainBundle]pathForResource:@"chime_up" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL
                                                    fileURLWithPath:soundFile],&soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    
    // see if this alert is because of a result alert
    //
    NSString *resultId = [alertOptions objectForKey:@"resultId"];
    if(resultId != nil)
    {
        [alertView addButtonWithTitle:@"View"];
        
        [self application:application showResultAlert:resultId appWasRunning:wasRunning];
    }
    
    // was this the result of a schedule alert?
    //
    NSString *scheduleId = [alertOptions objectForKey:@"scheduleId"];
    if(scheduleId != nil)
    {
        [alertView addButtonWithTitle:@"View"];
        
        [self application:application showScheduleAlert:scheduleId appWasRunning:wasRunning];
    }
    
    [alertView show];
}

-(void)application:(UIApplication *)application handleInactiveAlertWithOptions:(NSDictionary *)alertOptions appWasRunning:(Boolean)wasRunning
{
    // get the message text from the aps dictionary
    //
    NSDictionary *aps = [alertOptions objectForKey:@"aps"];
    NSString *alertText = [aps objectForKey:@"alert"];
    
    
    // the root view controller is going to have to handle this
    //
    iAthleticsApplication *theApp = (iAthleticsApplication *)application;
    
    theApp.showAlertFirst = alertText;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self.navigationController pushViewController:app.showViewFirst animated:YES];
        app.showViewFirst = nil;
    }
    
}

-(void)application:(UIApplication *)application showResultAlert:(NSString *)resultId appWasRunning:(Boolean)wasRunning
{
    NSString *resultKey = [NSString stringWithFormat:@"resultId:%@", resultId];
    
    // see if there is a view controller already handling this alert
    //
    ResultViewController *resultView = [self.apnsViews objectForKey:resultKey];
    
    if(resultView == nil)
    {
        // create a new events view
        //
        resultView = [[ResultViewController alloc]initWithNibName:@"ResultViewController" bundle:nil];
        
        resultView.resultId = [resultId integerValue];
        
        // add the view to the dictionary
        //
//        [self.apnsViews setObject:resultView forKey:resultKey];
    }
    
    // if the application was inactive then we can't put this view onto the
    // nav controller right now we have to wait until the root view is shown
    //
    if(!wasRunning)
    {
        //iAthleticsApplication *app = (iAthleticsApplication *)application;
        app.showViewFirst = resultView;
    }
    else
    {
        [self.navigationController pushViewController:resultView animated:YES];
    }
    
    [resultView release];
}

-(void)application:(UIApplication *)application showScheduleAlert:(NSString *)scheduleId appWasRunning:(Boolean)wasRunning
{
    NSString *scheduleKey = [NSString stringWithFormat:@"scheduleId:%@", scheduleId];
    
    // see if there is a view controller already handling this alert
    //
    EventViewController *eventView = [self.apnsViews objectForKey:scheduleKey];
    
    if(eventView == nil)
    {
        // create a new events view
        //
        eventView = [[EventViewController alloc]initWithNibName:@"MapEventViewController" bundle:nil];
        
        eventView.scheduleId = [scheduleId integerValue];
        
        // add the view to the dictionary
        //
//        [self.apnsViews setObject:eventView forKey:scheduleKey];
    }
    
    // if the application was inactive then we can't put this view onto the
    // nav controller right now we have to wait until the root view is shown
    //
    if(!wasRunning)
    {
        //iAthleticsApplication *app = (iAthleticsApplication *)application;
        app.showViewFirst = eventView;
    }
    else
    {
        [self.navigationController pushViewController:eventView animated:YES];
    }
    
    [eventView release];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Updates the device token and registers the token with UA
    //
    [[UAPush shared] registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleApplication:application alertWithOptions:userInfo appWasRunning:true];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    // unload urban airship
    //
	[UAirship land];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
 	// get the iAthleticsApplication object
	//
	//iAthleticsApplication *app = (iAthleticsApplication *)application;
    
    // somehow the app has become active again, either by startup or because of a backgroundforeground activation.
    // reset the cache date and time
	//
	app.startDateTime = [NSDate date];
    
    // set the show splash flag to true so that the app will show a splash ad 
    //
    app.showSplash = true;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	
	[super dealloc];
}


@end

