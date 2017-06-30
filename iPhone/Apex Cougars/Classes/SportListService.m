//
//  SportListService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/16/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "SportListService.h"


@implementation SportListService

@synthesize sportsList;
@synthesize currentListItem;


#pragma mark Constructors / Destructors

-(id) initWithApplication:(iAthleticsApplication *)theApp
{
	self = [super initWithApplication:theApp];
	
	NSMutableDictionary *newSportItem = [[NSMutableDictionary alloc]initWithCapacity:100]; 
	
	self.sportsList = newSportItem;
	
	[newSportItem release];
	
	return self;
}

-(void)dealloc
{
	[sportsList release];
	[currentListItem release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Service methods

-(NSDictionary *)requestServiceWithSeasonId:(NSInteger)seasonId
{
	// create the parameter string
	//
	NSString *paramString = [[NSString alloc]initWithFormat:@"seasonId=%d", seasonId];
	
	[self requestServiceName:@"GetSportListForSeason" parameters:paramString];
	
	[paramString release];
	
	return self.sportsList;	
}

#pragma mark -
#pragma mark iAthleticsService ABSTRACT methods


-(void) elementStart:(NSString *)elementName
{
	// prepare to receive new a new sport list item Info
	//
	if([elementName compare:@"SportListItem"] == NSOrderedSame)
	{
		SportListItem *newItem = [[SportListItem alloc]init];
		self.currentListItem = newItem;
		
		[newItem release];
	}
}

-(void)elementEnd:(NSString *)elementName withText:(NSString *)text
{
	// Sport Name
	//
	if([elementName compare:@"SportName"] == NSOrderedSame)
	{
		self.currentListItem.sportName = text;
	}
	
	// team name
	//
	else if([elementName compare:@"TeamName"] == NSOrderedSame)
	{
		self.currentListItem.teamName = text;
	}
	
	// the icon URL?
	//
	else if([elementName compare:@"SportIconUrl"] == NSOrderedSame)
	{
		iAthleticsImage *newImage = [[iAthleticsImage alloc]initWithUrl:text];
		self.currentListItem.image = newImage;
		[newImage release];
	}
	
	// the team id
	//
	else if([elementName compare:@"TeamId"] == NSOrderedSame)
	{
		self.currentListItem.teamId = [text intValue];
	}
	
	// if this is the end of the SportListItem then add the currentLink to the 
	// dictionary
	//
	else if([elementName compare:@"SportListItem"] == NSOrderedSame)
	{
		// add the currentListItem to the dictionary
		//
		[self addCurrentItemToDictionary];
	}
}

#pragma mark Private methods

-(void)addCurrentItemToDictionary
{
	// get all the current keys in the dictionary
	// the keys used is the Sport Name
	//
	NSArray *keys = [self.sportsList allKeys];
	
	if(keys == nil || [keys count] == 0)
	{
		[self addNewKeyAndValueToDictionary];
	}
	else 
	{
		// see if the key is in the dictionary
		// already. If so then add the current item to the array
		//
		for(int i=0; i < [keys count]; i++)
		{
			NSString *curKey = (NSString *)[keys objectAtIndex:i];
			
			if([curKey compare:self.currentListItem.sportName] == NSOrderedSame)
			{
				// add the current list item to the array for the key
				//
				NSMutableArray *arrayForKey = (NSMutableArray *)[sportsList objectForKey:curKey];
				[arrayForKey addObject:self.currentListItem];
				
				// we're done so return
				//
				return;
			}
		}
		
		// if we got this far then the key does not exist in the array
		// so add it anew
		//
		[self addNewKeyAndValueToDictionary];
	}
}

-(void)addNewKeyAndValueToDictionary
{
	NSString *key = self.currentListItem.sportName;
	
	// create a new array and put the current list item
	// in it
	//
	NSMutableArray *valueArray = [[NSMutableArray alloc]init];
	[valueArray addObject:self.currentListItem];
	
	[self.sportsList setObject:valueArray forKey:key];
	
	[valueArray release];
}

@end
