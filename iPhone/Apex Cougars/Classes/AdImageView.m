    //
//  iAthleticsAdView.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/26/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "AdImageView.h"
#import "AdService.h"

@implementation AdImageView

@synthesize adUrl;
@synthesize adImage;
@synthesize adPhone;
@synthesize	whenLastAd;


-(void)loadAd
{		
	// load a new ad if we never loaded an ad or the ad is over 20 seconds old
	//
	if(self.whenLastAd == nil || ([self.whenLastAd timeIntervalSinceNow] < -20.0))
	{
		[self performSelectorInBackground:@selector(loadAdInBackground) withObject:nil];

		self.whenLastAd = [NSDate date];
	}
}

-(void)loadAdInBackground
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	AdService *ad = [[AdService alloc]init];
	
	[ad requestService];
	
	self.adUrl = ad.adUrl;
	self.adImage = ad.image;
	self.adPhone = ad.adPhone;
	
	[ad release];
	
	[pool release];
	
	[self performSelectorOnMainThread:@selector(finishLoadAd) withObject:nil waitUntilDone:NO];
}

-(void)finishLoadAd
{
	if(self.adImage != nil)
	{
		self.image = [self.adImage getImage];
		
		self.userInteractionEnabled = YES;
	}
	else 
	{
		self.userInteractionEnabled = NO;
	}

	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
/* NEED TO TEST CODE ON A iPhone before releasing
 
	// should we show the action sheet that will dial the phone
	//
	if(self.adPhone != nil)
	{
		UIApplication *sharedApp = [UIApplication sharedApplication];
		
		NSString *telUrlStr = [NSString stringWithFormat:@"tel:%@", self.adPhone];
		NSURL *telUrl = [NSURL URLWithString:telUrlStr];
		
		if([sharedApp canOpenURL:telUrl] == YES)
		{

		}
	}
	else // show the sheet with just the web link
 */
	{
		if(self.adUrl != nil)
			[self showWebActionScheet];
	}
}

-(void)showTelActionSheet
{
	UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Support out sponsor"
													  delegate:self 
											 cancelButtonTitle:@"Cancel" 
										destructiveButtonTitle:nil 
											 otherButtonTitles:@"Web link", @"Call",nil];
	[sheet showInView:self.window];
	
	[sheet release];	
}

-(void)showWebActionScheet
{
	UIApplication *sharedApp = [UIApplication sharedApplication];
	
	NSURL *webUrl = [NSURL URLWithString:self.adUrl];
	
	if([sharedApp canOpenURL:webUrl] == YES)
	{
		UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Support our sponsor"
													  delegate:self 
											 cancelButtonTitle:@"Cancel" 
										destructiveButtonTitle:nil 
											 otherButtonTitles:@"Web link",nil];
		[sheet showInView:self.window];
	
		[sheet release];
	}
}

- (void)dealloc 
{
	[self.adUrl release];
	[self.adImage release];
	[self.adPhone release];
	[self.whenLastAd release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark UIActionSheet Methods


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch(buttonIndex)
	{
		case WEB_BUTTON:
			// send the web link to safari
			//
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.adUrl]];
			break;
			
		case TEL_BUTTON:
			break;
	}
}




@end
