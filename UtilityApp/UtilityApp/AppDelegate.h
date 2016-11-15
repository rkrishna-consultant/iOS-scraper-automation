//
//  AppDelegate.h
//  UtilityApp
//
//  Created by Radha on 02/11/2016.
//  Copyright © 2016 iBase. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RapidClassDump.h"

#define APP_MODE_SET_DYLIB_PATH @"Set_Path_DYLib"
#define APP_MODE_UPLOAD_DYLIB_DEVICE @"upload_DYLib"


@interface AppDelegate : NSObject <NSApplicationDelegate,NSUserNotificationCenterDelegate>
@property (weak) IBOutlet NSWindow *window;


//Sample commit
//Sample commit2
//Sample commit in develop branch

- (void)showNotificationWithMsg:(NSString *)msg;
-(void)showSimpleAlertMessage:(NSString*)msg;
- (NSString *)browseFile;
-(NSArray *)listTheContentFromAFolder:(NSString*) selectedDir;
- (BOOL)isInternetConnectionEnabled;
- (unsigned long long)getFolderSize:(NSString *)theFilePath;


@end

