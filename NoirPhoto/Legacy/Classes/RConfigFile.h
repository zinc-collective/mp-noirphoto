//
//  RConfigFile.h
//
//  Created by RYD on 09-09-02.
//


#import <Foundation/Foundation.h>


@interface RConfigFile : NSObject {

}

+ (RConfigFile *)sharedConfig;

-(BOOL)WriteConfigDicToFile:(NSString*)fileName withData:(NSDictionary*)configDic; 
-(NSDictionary*)ReadConfigDicFromFile:(NSString*)fileName; 
-(BOOL)WriteConfigArrayToFile:(NSString*)fileName withData:(NSArray*)configArray;
-(NSArray*)ReadConfigArrayFromFile:(NSString*)fileName; 
-(BOOL)DeleteConfigFileForName:(NSString*)fileName;
-(NSString*)GetPathForFileName:(NSString*)fileName;
-(void)CheckAndCreateFileForName:(NSString*)fileName; //在document里面查找对应的文件名字，如果没有，就从app的bundle里面copy一份 "In a document inside to find the corresponding file name, if not, copy from the app's bundle inside a" (via Google Translate)
-(void)MoveBundleFileToDocument:(NSString*)fileName;


@end
