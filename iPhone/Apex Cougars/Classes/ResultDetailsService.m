//
//  ResultDetailsService.m
//  iAthletics
//
//  Created by Robert Signore on 11/20/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import "ResultDetailsService.h"

@implementation ResultDetailsService

// methods to request service
//
-(void)requestServiceWithResultId:(NSInteger)resultId
{
	// create the parameter string
	//
	NSString *paramString = [[NSString alloc]initWithFormat:@"resultId=%d", resultId];
	[self requestServiceName:@"GetResultInfo" parameters:paramString];
	
	[paramString release];
}

@end
