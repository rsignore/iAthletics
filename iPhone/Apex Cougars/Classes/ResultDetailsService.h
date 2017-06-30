//
//  ResultDetailsService.h
//  iAthletics
//
//  Created by Robert Signore on 11/20/12.
//  Copyright (c) 2012 Appapro. All rights reserved.
//

#import "NextEventService.h"

@interface ResultDetailsService : NextEventService

// methods to request service
//
-(void)requestServiceWithResultId:(NSInteger)resultId;

@end
