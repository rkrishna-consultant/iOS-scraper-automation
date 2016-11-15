//
//  AppDelegate.m
//  UtilityApp
//
//  Created by Radha on 02/11/2016.
//  Copyright © 2016 iBase. All rights reserved.
//

#import "AppDelegate.h"
#import "UtilityViewController.h"
#import "Reachability.h"


@interface AppDelegate ()

@property (nonatomic,strong) IBOutlet UtilityViewController *utilityViewController;

@end

@implementation AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Insert code here to initialize your application
    NSLog(@"applicationDidFinishLaunching called %@ and %@",[aNotification userInfo],aNotification);
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

    // Insert code here to initialize your application
    self.utilityViewController = [[UtilityViewController alloc] initWithNibName:@"UtilityViewController" bundle:nil];
    // 2. Add the view controller to the Window's content view
    [self.window.contentView addSubview:self.utilityViewController.view];
    self.utilityViewController.view.frame = ((NSView*)self.window.contentView).bounds;
    
    
    //RapidClassDump *dump = [[RapidClassDump alloc] init];
    //[dump dumpAllClassesAndMethods];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark Other methods

- (void)showNotificationWithMsg:(NSString *)msg{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = msg;
    notification.informativeText = @"Quixey App";
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(void)showSimpleAlertMessage:(NSString*)msg
{
    //CGRect frame = btnConnect.frame;
    // frame.origin.x = (320 - btnConnect.contentSize.width)/2;
    //replace 320 with the screen width
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Utility"];
    [alert setInformativeText:msg];
    [alert addButtonWithTitle:@"Ok"];
    [alert setAlertStyle:NSAlertStyleInformational];
    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
    }];
}

- (NSString *)browseFile
{
    NSString *userFile;
    
    NSOpenPanel *op = [NSOpenPanel openPanel];
    op.canChooseFiles = YES;
    op.canChooseDirectories = YES;
    [op runModal];
    userFile = [op.URLs firstObject].absoluteString;
    
    if( userFile != nil )
    {
        if ([userFile length] > 7)
            userFile = [userFile substringFromIndex:7];
    }
    
    return userFile;
}


-(NSArray *)listTheContentFromAFolder:(NSString*) selectedDir
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *filelist = [filemgr contentsOfDirectoryAtPath: selectedDir error: nil];
    NSInteger count = [filelist count];
    
    NSLog(@"Files count =%d , %@",count ,selectedDir);
    
    for (int i = 0; i < count; i++)
        NSLog (@"%@", [filelist objectAtIndex: i]);
    
    return filelist;
}

- (BOOL)isInternetConnectionEnabled
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    BOOL status = (networkStatus != NotReachable);
    
    if (!status)
    {
        [self showSimpleAlertMessage:@"No Internet connection"];
    }
    return status;
}

- (unsigned long long)getFolderSize:(NSString *)theFilePath
{
    unsigned long long totalSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL  isdirectory;
    NSError *error;
    
    if ([fileManager fileExistsAtPath:theFilePath])
    {
        NSMutableArray * directoryContents = [[fileManager contentsOfDirectoryAtPath:theFilePath error:&error] mutableCopy];
        
        
        for (NSString *fileName in directoryContents)
        {
            if (([fileName rangeOfString:@".DS_Store"].location != NSNotFound) )
                continue;
            
            
            
            NSString *path = [theFilePath stringByAppendingPathComponent:fileName];
            if([fileManager fileExistsAtPath:path isDirectory:&isdirectory] && isdirectory  )
            {
                
                totalSize =  totalSize + [self getFolderSize:path];
            }
            else
            {
                unsigned long long fileSize = [[fileManager attributesOfItemAtPath:path error:&error] fileSize];
                totalSize = totalSize + fileSize;
            }
        }
    }
    return totalSize;
}

@end
