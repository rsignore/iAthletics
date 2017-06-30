//
//  iAthleticsImage.m
//  iAthletics Framework
//
//  Created by Robert Signore on 6/14/10.
//  Copyright 2010 Appapro. All rights reserved.
//

#import "iAthleticsImage.h"
#import "iAthleticsApplication.h"


@implementation iAthleticsImage

@synthesize imageUrl;
@synthesize theImage;

#pragma mark constructors/destructors

-(id)initWithUrl:(NSString *)theUrl
{
	self.imageUrl = theUrl;
	
	//load the image here as well since we are most
	//likely on a background thread.
	//calling getImage from the main thread will cause the
	// main thread to block
	//
	[self getImage];
	
	return self;
}

-(void)dealloc
{
	[self.imageUrl release];
	[self.theImage release];
	
	[super dealloc];
}


//if called from the main thread it will block the thread
//
-(UIImage *)getImage
{	
	if(self.theImage == nil)
	{
		NSData *urlData = [self loadFromRecientCache];
		
		if(urlData != nil)
		{
			self.theImage = [UIImage imageWithData:urlData];
		}
		else 
		{
			NSURLRequest *urlRequest =[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageUrl]];
		
			//synchronous request on the thread called
			//
			NSURLResponse *response;
			NSError *error;
			urlData = [NSURLConnection sendSynchronousRequest:urlRequest 
												returningResponse:&response error:&error];
		
			if(urlData != nil)
			{	
				self.theImage = [UIImage imageWithData:urlData];
				
				[self cacheImageData:urlData];
			}
			else
			{
				urlData = [self loadCachedImage];
				if(urlData != nil)
				{
					self.theImage = [UIImage imageWithData:urlData];
				}
			}
		}
	}
	
	return self.theImage;
}

-(NSData *)loadFromRecientCache
{
	NSData *retval = nil;
	
	NSString *filePath = [self getCacheFileName];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == YES) 
	{
		NSError *anError;
		
		/* retrieve file attributes */
		//
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&anError];
		if (attributes != nil) 
		{
			iAthleticsApplication *app = (iAthleticsApplication *)[UIApplication sharedApplication];
			
			// if the file was created after the application started use it
			//
			if([app.startDateTime compare:[attributes fileModificationDate]] == NSOrderedAscending)
			{
				retval = [self loadCachedImage];
			}
		}
	}
	
	return retval;	
}

-(NSData *)loadCachedImage
{
	NSData *retval = nil;
	
	NSString *dataPath = [self getCacheFileName];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath] == YES) 
	{
		retval = [NSData dataWithContentsOfFile:dataPath];
	}
	
	return retval;	
}

-(BOOL)cacheImageData:(NSData *)imageData
{
	NSString *dataPath = [self getCacheFileName];
	
	BOOL retVal = [[NSFileManager defaultManager] createFileAtPath:dataPath 
														  contents:imageData
														attributes:nil];
	
	return retVal;	
}

-(NSString *)getCacheFileName
{
	NSArray *urlComponents = [self.imageUrl componentsSeparatedByString:@"/"];
	
	NSString *actualFileName = [NSString stringWithFormat:@"%@.img", [urlComponents objectAtIndex:[urlComponents count]-1]];

	
	// place the file in the application's Documents directory
	//
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:actualFileName];
	
	return dataPath;
}

@end
