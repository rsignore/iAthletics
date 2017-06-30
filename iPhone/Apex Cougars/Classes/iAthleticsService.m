//
//  iAthleticsService.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/13/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "iAthleticsService.h"
#import <UIKit/UIDevice.h>
#import	"iAthleticsApplication.h"


@implementation iAthleticsService

@synthesize app;
@synthesize currentString;
@synthesize anError;
@synthesize cacheIsOff;
@synthesize urlData;

-(void)dealloc
{	
	[self.app release];
	[self.currentString release];
	[self.urlData release];
	[self.anError release];
	
	[super dealloc];
}

-(id) initWithApplication:(iAthleticsApplication *)theApp
{
	self = [super init];
	
	self.app = theApp;
	
	return self;
}

-(void)turnCacheOff
{
	self.cacheIsOff = YES;
}
-(void)turnCacheOn
{
	self.cacheIsOff = NO;
}


-(BOOL)loadFromRecientCache:(NSString *)serviceName parameters:(NSString *)parameters
{
	BOOL retval = NO;
	
	NSString *filePath = [self getCacheFileName:serviceName withParameters:parameters];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == YES) 
	{
		NSError *error;
		
		/* retrieve file attributes */
		//
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
		
		if (attributes != nil) 
		{
			// if the file was created after the application started use it
			//
			if([app.startDateTime compare:[attributes fileModificationDate]] == NSOrderedAscending)
			{
				retval = [self loadFromCacheService:serviceName withParameters:parameters];
			}
		}
	}
	
	return retval;	
}

-(void)requestServiceName:(NSString *)serviceName parameters:(NSString *)parameters
{
	// get the shared app here
	//
	self.app = (iAthleticsApplication *)[UIApplication sharedApplication];
	
	// check to see if we have alredy gotten network data since the app started
	// if so, use that, it's good enough and the app will perform best
	//
	if(!self.cacheIsOff && [self loadFromRecientCache:serviceName parameters:parameters] == YES)
	{
		[self parseData:self.urlData];
	}
	else // go out to the network to load the latest and gratest info
	{
		NSMutableString *serviceMut = [[NSMutableString alloc] initWithCapacity:256];
		
		[serviceMut setString:app.serviceUrl];
		
		//append the service name to call
		//
		[serviceMut appendString:serviceName];
		
		NSString *deviceIdStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(
									NULL,
									(CFStringRef)[NSString stringWithFormat:@"%@:%@:%@",
                                                  [[UIDevice currentDevice] model],
                                                  [[UIDevice currentDevice] systemVersion],
                                                  [[UIDevice currentDevice] identifierForVendor]],
                                                  NULL,
                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                kCFStringEncodingUTF8 );
		
		// all services have the appId and deviceId parameters, so add those to the string
		//
		[serviceMut appendString:[NSString stringWithFormat:@"?appId=%d&deviceId=%@",
								  app.appId, 
								  deviceIdStr]];
		
		[deviceIdStr release];
		
		
		//append the parameter string if any
		//
		if(parameters != nil)
		{
			[serviceMut appendString:@"&"];
			
			[serviceMut appendString:parameters];
		}
		
		NSString *urlStr = serviceMut;
			
		NSURLRequest *urlRequest =[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
		
		//synchronous request on the calling thread
		//
		NSURLResponse			*theResponse = nil;
		NSError					*theError = nil;
		NSData					*theData = nil;
		
		theData = [NSURLConnection sendSynchronousRequest:urlRequest 
											  returningResponse:&theResponse error:&theError];

		self.urlData = theData;
//		[theData release];
		
		self.anError = theError;
		
		if(self.urlData != nil) // did the network return data? If so use it an cache it
		{
			[self parseData:self.urlData];
			
			// save this returning data in the cache
			//
			[self cacheResultOfServiceName:(NSString *)serviceName withParameters:(NSString *)parameters];
		}
		else if([self loadFromCacheService:serviceName withParameters:parameters] == YES)
		{
			// try to use cached data regardless of it's age
			// The user could be off-line or there is a network problem
			//
			[self parseData:self.urlData];
		}
		
		[serviceMut release];	
	}
}

-(BOOL)loadFromCacheService:(NSString *)serviceName withParameters:(NSString *)parameters
{
	BOOL retval = NO;
	
	NSString *dataPath = [self getCacheFileName:serviceName withParameters:parameters];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath] == YES) 
	{
		self.urlData = [NSData dataWithContentsOfFile:dataPath];
		
		retval = (self.urlData != nil);
	}
	
	return retval;
}

-(NSString *)getCacheFileName:(NSString *)serviceName withParameters:(NSString *)parameters
{
	NSString *suggestedFileName = [NSString stringWithFormat:@"%@.xml", serviceName];
	NSString *actualFileName = nil;
	
	// if there are parameters then add them to the file name
	// need to split the suggested file name to remove the extension, 
	// add the parameters to the file name, and add the extension back on
	//
	if(parameters != nil)
	{
		NSArray *fileNameExt = [suggestedFileName componentsSeparatedByString:@"."];
		
		actualFileName = [NSString stringWithFormat:@"%@&%@.%@", 
						  [fileNameExt objectAtIndex:0],
						  parameters,
						  [fileNameExt objectAtIndex:1]];
	}
	else 
	{
		actualFileName = suggestedFileName;
	}
	
	// place the file in the application's Documents directory
	//
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:actualFileName];
	
	return dataPath;
}

-(BOOL)cacheResultOfServiceName:(NSString *)serviceName withParameters:(NSString *)parameters
{	
    NSString *dataPath = [self getCacheFileName:serviceName withParameters:parameters];
	
	BOOL retVal = [[NSFileManager defaultManager] createFileAtPath:dataPath 
											contents:self.urlData
										  attributes:nil];
	
	return retVal;
}


- (void)parseData:(NSData *)data 
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
	
	NSMutableString *mutString = [[NSMutableString alloc]initWithCapacity:1024];
	self.currentString = mutString;
	[mutString release];
	
	//let subclasses do something before parsing begins
	//
	[self preParse];
	
    [parser parse];
	
	//let subclasses do something post parse
	//
	[self postParse];
	
    [parser release];        
}

#pragma mark -
#pragma mark ABSTRACT methods

-(void) preParse {}

// postParse will be called on the main thread
//
-(void) postParse{}
-(void) elementStart:(NSString *)elementName{}
-(void)elementEnd:(NSString *)elementName withText:(NSString *)text{}

#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict 
{
	[self.currentString setString:@""];
	
	[self elementStart:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName 
{     
	// need to copy the current string buffer and create it's own object
	//
	NSString *value = [NSString stringWithString:self.currentString];
	
	[self elementEnd:elementName withText:value];
}

// This method is called by the parser when it find parsed character data ("PCDATA") in an element.
// The parser is not guaranteed to deliver all of the parsed character data for an element in a single
// invocation, so it is necessary to accumulate character data until the end of the element is reached.
//
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
	// store what was parsed in the string buffer.
	//
	[self.currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
/*
	// If the number of earthquake records received is greater than kMaximumNumberOfEarthquakesToParse,
    // we abort parsing.  The parser will report this as an error, but we don't want to treat it as
    // an error. The flag didAbortParsing is how we distinguish real errors encountered by the parser.
    //
    if (didAbortParsing == NO) {
        // Pass the error to the main thread for handling.
        [self performSelectorOnMainThread:@selector(handleError:) withObject:parseError waitUntilDone:NO];
    }
*/
}

@end