//
//  iAthleticsAdView.h
//  iAthletics Framework
//
//  Created by Robert Signore on 6/26/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAthleticsImage.h"

#define WEB_BUTTON	0
#define	TEL_BUTTON	1

@interface AdImageView : UIImageView <UIActionSheetDelegate>
{
	NSString *adUrl;
	NSString *adPhone;
	iAthleticsImage *adImage;
	
	NSDate	*whenLastAd;
}

@property(nonatomic,retain)NSString			*adUrl;
@property(nonatomic,retain)NSString			*adPhone;
@property(nonatomic,retain)iAthleticsImage	*adImage;
@property(nonatomic,retain)NSDate			*whenLastAd;

-(void)loadAd;
-(void)loadAdInBackground;
-(void)finishLoadAd;

// action sheet methods
//
-(void)showTelActionSheet;
-(void)showWebActionScheet;

@end
