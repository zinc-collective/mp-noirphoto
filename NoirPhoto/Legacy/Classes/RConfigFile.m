//
//  RConfigFile.m
//
//  Created by RYD on 09-09-02.
//

#import "RConfigFile.h"


static RConfigFile *_sharedConfig;

@implementation RConfigFile


+ (RConfigFile *)sharedConfig
{
	if (!_sharedConfig) {
		_sharedConfig = [[RConfigFile alloc] init];
	}
	return _sharedConfig;
}



-(BOOL)WriteConfigDicToFile:(NSString*)fileName withData:(NSDictionary*)configDic
{
	NSString *path = [self GetPathForFileName:fileName];
	BOOL bSuccess = [configDic writeToFile:path atomically:YES];

	return bSuccess;
}
-(NSDictionary*)ReadConfigDicFromFile:(NSString*)fileName
{
	NSString *path = [self GetPathForFileName:fileName];
	NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:path];
	return configDic;
}
-(BOOL)WriteConfigArrayToFile:(NSString*)fileName withData:(NSArray*)configArray
{
	NSString *path = [self GetPathForFileName:fileName];
	BOOL bSuccess = [configArray writeToFile:path atomically:YES];
	
	return bSuccess;
}
-(NSArray*)ReadConfigArrayFromFile:(NSString*)fileName
{
	NSString *path = [self GetPathForFileName:fileName];
	NSArray *configArray = [NSArray arrayWithContentsOfFile:path];
	return configArray;	
}
-(BOOL)DeleteConfigFileForName:(NSString*)fileName
{
	NSString *path = [self GetPathForFileName:fileName];
	BOOL bExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
	if(!bExist) return YES;
	
	NSError *error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
	if(error != nil) return NO;
	
	return YES;
}
-(NSString*)GetPathForFileName:(NSString*)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	//NSLog(@"%@", path);
	
	return path;
}
-(void)CheckAndCreateFileForName:(NSString*)fileName
{
	NSString *path = [self GetPathForFileName:fileName];
	
	BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:path];
	if(success) return;
	
//	NSString *pathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
//	[fileManager copyItemAtPath:pathFromApp toPath:path error:nil];
//	[fileManager release];
	
	[self MoveBundleFileToDocument:fileName];
}
-(void)MoveBundleFileToDocument:(NSString*)fileName
{
	NSString *path = [self GetPathForFileName:fileName];
	NSString *pathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
	[[NSFileManager defaultManager] copyItemAtPath:pathFromApp toPath:path error:nil];

	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	[[NSUserDefaults standardUserDefaults] setObject:version forKey:@"version"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}



@end
