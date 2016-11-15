//
//  UtilityViewController.h
//  UtilityApp
//
//  Created by Radha on 02/11/2016.
//  Copyright © 2016 iBase. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
//#import <NVImageLoader/NVImageLoader.h>


@interface UtilityViewController : NSViewController
{
    bool isConnected;
    AppDelegate *appDelegate;
    
    unsigned long long totalUploadSize,currentUploadSize;
   

}
@property (weak) IBOutlet NSTextField *txtRemoteIP;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;

@property (weak) IBOutlet NSTextField *lblStatus;

@property (weak) IBOutlet NSTextField *txtPort;
@property (weak) IBOutlet NSSecureTextField *txtPassword;
@property (weak) IBOutlet NSTextField *txtUserName;
@property (unsafe_unretained) IBOutlet NSTextView *txtLogs;
@property (weak) IBOutlet NSTextField *txtCmd;
@property (weak) IBOutlet NSButton  *btnExecuteCmd;






@property (weak) IBOutlet NSButton *btnConnect;
@property (weak) IBOutlet NSButton *btnUpload;
@property (weak) IBOutlet NSTextField *txtSelectedFile;
@property (weak) IBOutlet NSTextField *txtDestSelectedFile;
@property (weak) IBOutlet NSButton *btnTerminate;




- (NSString *) getUserSelectedFile;
- (BOOL)  listTheContentFromAFolder:(NSString*) selectedDir;
- (void) enumerateFolder:(NSString*)path appFolderName:(NSString*) appFolderName;
- (void)uploadFileToDevice:(NSString*) srcFile destFile:(NSString*) destFile;

-(NSString*)getIterate:(NSString*)path  appFolderName:(NSString*)appFolderName;
-(NSString*)getRelativePath:(NSString*)fullPath appFolderName:(NSString*)appFolderName;

- (void)appendToMyTextView:(NSString*)text;
-(void)giveAllPermissionsToPath:(NSString *)path;

- (BOOL)connected;
-(void)showSimpleAlertMessage:(NSString*)msg;
-(void)downloadFileFromDevice;




@end
