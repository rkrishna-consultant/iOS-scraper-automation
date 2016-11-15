//
//  UtilityViewController.m
//  UtilityApp
//
//  Created by Radha on 02/11/2016.
//  Copyright © 2016 iBase. All rights reserved.
//

#import "UtilityViewController.h"
#import <NMSSH/NMSSH.h>
#import <SystemConfiguration/SystemConfiguration.h>


@interface UtilityViewController ()
{
    NMSSHSession *session;
}

@end



@implementation UtilityViewController
@synthesize btnTerminate, btnUpload,btnConnect;

@synthesize txtLogs;

- (void)viewDidLoad {
    
    appDelegate = [NSApplication sharedApplication].delegate;
    NSString *appMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"appMode"];
    if (!appMode) {
        appMode = @"";
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceIpAddress"])
    {
        self.txtRemoteIP.stringValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceIpAddress"];
    }
    
    if(self.txtUserName.stringValue.length > 0 && self.txtPort.stringValue.length && self.txtPassword.stringValue.length && self.txtRemoteIP.stringValue.length)
    {
        self.lblStatus.hidden = NO;
        [self connectRemoteIP:nil];
    }
    else
    {
        self.lblStatus.hidden = YES;
    }
    

    if([appMode isEqualToString:APP_MODE_SET_DYLIB_PATH])
    {
        NSString *pathQXDynamicLib = [NSString stringWithFormat:@"/Users/%@/Desktop/QXDynamicLib.dylib", NSUserName()];

        self.txtSelectedFile.stringValue  = pathQXDynamicLib;//@"%userprofile%\desktop";
        self.txtDestSelectedFile.stringValue  = @"/Library/MobileSubstrate/DynamicLibraries/";
        //[self connectRemoteIP:nil];
    }
    if([appMode isEqualToString:APP_MODE_UPLOAD_DYLIB_DEVICE])
    {
        NSString *pathQXDynamicLib = [NSString stringWithFormat:@"/Users/%@/Desktop/QXDynamicLib.dylib", NSUserName()];
        if (![[NSFileManager defaultManager] fileExistsAtPath:pathQXDynamicLib])
        {
            [appDelegate showNotificationWithMsg:@"Dylib is missing in desktop."];
            return;
        }

        self.txtSelectedFile.stringValue  = pathQXDynamicLib;//@"%userprofile%\desktop";
        self.txtDestSelectedFile.stringValue  = @"/Library/MobileSubstrate/DynamicLibraries/";
        //[self connectRemoteIP:nil];
        [self uploadToDeviceAction:nil];
        [self killDylibInjectedApps];
        NSString *bundleId = [self downloadLatestBundleIdFromDevice];
        [self openAppWithBubdleId:bundleId];
        [appDelegate showNotificationWithMsg:[NSString stringWithFormat:@"App Launched with %@",bundleId]];

        
        //exit(0);
    }

    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark IB Methods
- (IBAction)terminateRemoteIP:(id)sender {
    if (![appDelegate isInternetConnectionEnabled])
        return;
    
    if(session)
    [session disconnect];
    self.lblStatus.hidden = YES;
    [appDelegate showNotificationWithMsg:@"Diconnected from Device"];
}

-(IBAction)uploadToDeviceAction:(id)sender {
    [self logText:[NSString stringWithFormat:@"Upload clicked"]];

    //Check Internet Connection
    if (![appDelegate isInternetConnectionEnabled])
        return;
    
    //Validation for select File paths
    NSString *txtFile = self.txtSelectedFile.stringValue;
    NSString *targetFolderPath = self.txtDestSelectedFile.stringValue;
    if(txtFile.length == 0 || targetFolderPath.length == 0)
        return;
    
    //Validation for Connection
    if (!session)
    {
        [self connectRemoteIP:nil];
    }
    else if (!session.isConnected)
    {
        [self connectRemoteIP:nil];
    }
    
  
    [self.btnUpload setEnabled:NO];
    self.progressIndicator.hidden = NO;
    
    NSString *sourceFolderName = [txtFile lastPathComponent];

    //get Path extension - alsadi
    NSString* extension = [txtFile pathExtension];
    if ([extension isEqualToString:@"app"] || [extension isEqualToString:@"framework"])
    {
        // Do app folder copy.
        [self logText:[NSString stringWithFormat:@" Its app folder to copy into the remote"]];
        totalUploadSize = [appDelegate getFolderSize:txtFile];
        currentUploadSize = 0.0;

        [self uploadFolderToDevice:txtFile destFile:self.txtDestSelectedFile.stringValue];
        
        NSString *targetFolder = [NSString stringWithFormat:@"%@%@",targetFolderPath, sourceFolderName];
        [self giveAllPermissionsToPath:targetFolder];
    }
    else{
        // Do  file copy
        [self logText:[NSString stringWithFormat:@" Its file to copy into the remote"]];
        [self uploadFileToDevice:txtFile destFile:targetFolderPath];
    }

   
    [self.btnUpload setEnabled:NO];
    self.progressIndicator.hidden = YES;

     [appDelegate showNotificationWithMsg:[NSString stringWithFormat:@"%@ Uploaded to Device",sourceFolderName]];
}

- (IBAction)browseFileForSourcePath:(id)sender {
    
    [self logText:@"browseFileForSourcePath called"];
    NSString *selectedFile = [appDelegate browseFile];
    self.txtSelectedFile.stringValue  = selectedFile;
    NSString *extenction = [[selectedFile lastPathComponent] pathExtension];
    
    //If it is Frame work
    if([extenction isEqualToString:@"framework"])
       self.txtDestSelectedFile.stringValue  = @"/Library/Frameworks/";
    else if ([extenction isEqualToString:@"app"])
       self.txtDestSelectedFile.stringValue  = @"/Applications/";
    else if ([extenction isEqualToString:@"dylib"])
        self.txtDestSelectedFile.stringValue  = @"/Library/MobileSubstrate/DynamicLibraries/";
    else if ([extenction isEqualToString:@""])
        self.txtDestSelectedFile.stringValue  = @"/usr/bin/";
    else
        self.txtDestSelectedFile.stringValue  = @"";
}

- (IBAction)connectRemoteIP:(id)sender {
    if (![appDelegate isInternetConnectionEnabled])
        return;

    isConnected = false;
    [self logText:[NSString stringWithFormat:@"Clicked"]];
    
    NSString *txtIP = self.txtRemoteIP.stringValue;
    NSString *txtPort= self.txtPort.stringValue;
    NSString *txtName = self.txtUserName.stringValue;
    NSString *txtPwd = self.txtPassword.stringValue;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:txtIP forKey:@"deviceIpAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     
    NSString *formatedip = [NSString stringWithFormat:@"%@:%@",txtIP, txtPort];
                         
    
    session = [NMSSHSession connectToHost:formatedip withUsername:txtName];
                             
    if (session.isConnected)
    {
        [session authenticateByPassword:txtPwd];
        if (session.isAuthorized) {
            [self logText:[NSString stringWithFormat:@"Authentication succeeded"]];
            isConnected = true;
            [appDelegate showNotificationWithMsg:@"Connected to Device"];
        }
        else
        {
            [appDelegate showNotificationWithMsg:@"Failed to connect with Device."];
            
            [self showSimpleAlertMessage:@"Failed to connect with Device."];
        }
    }
    NSError *error = nil;
   // NSString *response = [session.channel execute:@"ls -l /usr/bin/" error:&error];
    //[self logText:[NSString stringWithFormat:@"List of my sites: %@", response);
    
    
    //NSError *error = nil;
    // NSString *response1 = [session.channel execute:@"mkdir  /usr/bin/mytest" error:&error];
     //[self logText:[NSString stringWithFormat:@"dir created: %@", response1);
    
    //NSString *response2 = [session.channel execute:@"sbMaster launch com.cardify.tinder" error:&error];
    //NSString *response2 = [session.channel execute:@"sbMaster launch com.gasbuddymobile.gasbuddy" error:&error];
    //NSString *response2 = [session.channel execute:@"scp -r /Users/radha/Desktop/QuixeyAgent.app  root@216.38.149.10:/Applications/" error:&error];
    //[self logText:[NSString stringWithFormat:@"Launch App: %@", response2);
    
}

- (IBAction)executeCMdTapped:(id)sender {
    NSString *cmdStr = self.txtCmd.stringValue;
    if(cmdStr.length > 0)
    {
        NSError *error;
        NSString *response = [session.channel execute:cmdStr error:&error];
        if(error)
            [self logText:[NSString stringWithFormat:@"Error while exec command %@", error.description]];
        else
        {
            NSString *lastResponse  = session.channel.lastResponse;
            NSLog(@"lastResponse is %@",lastResponse);
            [self logText:[NSString stringWithFormat:@"Device Cmd Prompt$ %@",cmdStr]];
            [self logText:lastResponse];
        }
    }
}

#pragma mark Execute Commands
-(void)killDylibInjectedApps
{
    NSString *dylibPlistPath = [NSString stringWithFormat:@"/Users/%@/Desktop/QXDynamicLib.plist", NSUserName()];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dylibPlistPath]) {
        NSArray *appsPlistArray = [[[NSDictionary dictionaryWithContentsOfFile:dylibPlistPath] valueForKey:@"Filter"] valueForKey:@"Bundles"];
        for (int i = 0; i <appsPlistArray.count; i++) {
            NSError *error;
            NSString *response = [session.channel execute:[NSString stringWithFormat:@"sbMaster kill %@",appsPlistArray[i]] error:&error];
            [self logText:[NSString stringWithFormat:@"Kill App: %@", response]];
        }
    }
    else
    {
        
    }
}
-(void)openAppWithBubdleId:(NSString *)bundleId
{
    if(bundleId)
    {
        NSString *response = [session.channel execute:[NSString stringWithFormat:@"sbMaster launch %@",bundleId] error:nil];
        [self logText:[NSString stringWithFormat:@"Kill App: %@", response]];
    }
}



#pragma mark upload Methods
- (void)uploadFolderToDevice:(NSString*)selectedDir destFile:(NSString *)destFilePath
{
    [self logText:[NSString stringWithFormat:@"Selected folder, %@" ,selectedDir]];
   
    NSString *sourceFolderName = [selectedDir lastPathComponent];
    NSString *destinationFolderName = [destFilePath lastPathComponent];
    NSString *targetFolderPath = destFilePath;
    if(![sourceFolderName isEqualToString:destinationFolderName])
       targetFolderPath = [NSString stringWithFormat:@"%@%@",destFilePath, sourceFolderName];

    //Creating Folder
    NSString *cmd = [NSString stringWithFormat:@"%@ %@",@"mkdir", targetFolderPath];
    [self logText:[NSString stringWithFormat:@"cmd = %@", cmd]];
     NSError *error = nil;
     NSString *response = [session.channel execute:cmd error:&error];
    [self logText:[NSString stringWithFormat:@"dir created: %@", response]];
    NSArray *fileContentss= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:selectedDir error:nil];
    
    NSString *file;
    BOOL isDirectory;
    
    for(file in fileContentss)
    {
        //first check if it's a file
        NSString* srcFullPath = [NSString stringWithFormat:@"%@/%@",selectedDir,file];
        
        BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:srcFullPath isDirectory:&isDirectory];
        NSString* targetfullPath = [NSString stringWithFormat:@"%@/%@",targetFolderPath,file];

       //  [self logText:[NSString stringWithFormat:@"File =>%@",fullPath);
        if (!isDirectory) //its a file
        {
            //Do with filepath
           [self logText:[NSString stringWithFormat:@"Its File  TARGET= %@", targetfullPath]];
           [self uploadFileToDevice:srcFullPath  destFile: targetfullPath];
        }
        else{ //it's a folder, so recurse
           [self logText:[NSString stringWithFormat:@"Its Folder = %@", srcFullPath]];
           [self uploadFolderToDevice:srcFullPath destFile:targetfullPath];
        }
    }
}

/*
-(NSString*)getIterate:(NSString*)path appFolderName:(NSString*) appFolderName {
    
    NSMutableString *allHash;
    allHash = [NSMutableString stringWithString:@""];
    
    NSString *folder = [self getRelativePath:path appFolderName:appFolderName];
    
    NSString *targetFolderPath = [NSString stringWithFormat:@"%@%@",self.txtDestSelectedFile.stringValue, folder];
    NSString *cmd = [NSString stringWithFormat:@"%@ %@",@"mkdir", targetFolderPath];
    NSError *error = nil;
    NSString *response = [session.channel execute:cmd error:&error];
    [self logText:[NSString stringWithFormat:@"dir To create created: %@", targetFolderPath]];

    
    NSDirectoryEnumerator *de= [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString *file;
    BOOL isDirectory;
    
    for(file in de)
    {
        //first check if it's a file
        NSString* fullPath = [NSString stringWithFormat:@"%@/%@",path,file];
        
        BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
       // [self logText:[NSString stringWithFormat:@"Check=>%d",fileExistsAtPath);
        
        if (!isDirectory) //its a file
        {
            //Do with filepath
             NSString* targetfullPath = [NSString stringWithFormat:@"%@/%@",targetFolderPath,file];
            
            //Do with filepath
            [self logText:[NSString stringWithFormat:@"Its File  SOURCE= %@", fullPath]];
            [self logText:[NSString stringWithFormat:@"Its File  TARGET= %@", targetfullPath]];
            
            [self uploadFileToDevice:fullPath  destFile: targetfullPath];

        }
        else{ //it's a folder, so recurse
            [self getIterate:fullPath appFolderName:appFolderName];
        }
    }
    return allHash;
}
 
 */
-(NSString *)downloadLatestBundleIdFromDevice
{
    NSString *remoteFilePath= @"/Applications/QuixeyAgent.app/dylib_input.plist";
    //NSString *localFolder = [NSURL fileURLWithPath:[NSHomeDirectory()stringByAppendingPathComponent:@"Desktop"]];
    
    NSString *localFilePath = [NSString stringWithFormat:@"/Users/%@/Desktop/dylib_input.plist", NSUserName()];

    
    //NSString *localFilePath = [NSString stringWithFormat:@"%@/dylib_input.plist",localFolder];
    
    NSLog(@"Local path=%@",localFilePath);
    BOOL success = [session.channel downloadFile:remoteFilePath to:localFilePath];
    
    NSDictionary *fileDict = [NSDictionary dictionaryWithContentsOfFile:localFilePath];
    if(!fileDict)
        return nil;
    NSString *bredCrumStr = [[fileDict valueForKey:@"payload"] valueForKey:@"input"];
    NSError *error;
    NSDictionary *finalData = [NSJSONSerialization JSONObjectWithData:[bredCrumStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if(error)
    {
        NSLog(@"Error while parsing the BredCrum %@",error.description);
        return nil;
    }
    
   NSArray *editionsArray = [finalData valueForKey:@"editions"];
    if(editionsArray)
    {
        if(editionsArray.count > 0)
        {
          return [[editionsArray firstObject] valueForKey:@"bundleId"];
        }
    }
    
    return nil;
}

- (void)uploadFileToDevice:(NSString*)srcFile destFile:(NSString*) destFile
{
    NSLog(@"uploadFileToDevice called %@ \n Source File : %@",destFile,srcFile);

    [self logText:[NSString stringWithFormat:@"Target File after Uplaod = %@", destFile]];
    if(isConnected){
        
        __block NSUInteger fileUploadBytes = 0.0;
        BOOL success = [session.channel uploadFile:srcFile to:destFile progress:^BOOL(NSUInteger value) {
            //[self logText:[NSString stringWithFormat:@"File Progress: %d", (int)value]];
            NSLog(@"File Progress: %d", (int)value);
            fileUploadBytes = value;
            return YES;
        }];

        currentUploadSize += fileUploadBytes;
        //NSUInteger percentage = (currentUploadSize/totalUploadSize)*100;
        double percentage = ((double)currentUploadSize / (double)totalUploadSize)*100;
        
//        [self.progressIndicator setUsesThreadedAnimation:YES];
//        [self.progressIndicator displayIfNeeded];
//        [self.progressIndicator setNeedsDisplay:YES];
        [self.progressIndicator setIndeterminate:NO];


        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressIndicator.doubleValue = percentage;
        });

        //BOOL success = [session.channel uploadFile:srcFile to:destFile]; //@"/usr/bin/"];
        if(success)
        {
            [self logText:[NSString stringWithFormat:@"Percentage (%ld/%ld) : %f",currentUploadSize,totalUploadSize,  percentage]];
        }
        else
        {
            [self logText:[NSString stringWithFormat:@"Failed to upload a selected file %@",srcFile]];
            
        }
    }
}

/*
-(void)enumerateFolder:(NSString*)path appFolderName:(NSString*) appFolderName
{
    NSString *appspath = self.txtDestSelectedFile.stringValue;
    
    NSString *folder = [self getRelativePath:path appFolderName:appFolderName];
    
    NSString *targetFolderPath = [NSString stringWithFormat:@"%@%@",appspath, folder];
    NSString *cmd = [NSString stringWithFormat:@"%@ %@",@"mkdir", targetFolderPath];
    NSError *error = nil;
    NSString *response = [session.channel execute:cmd error:&error];
    [self logText:[NSString stringWithFormat:@"dir To create created: %@", targetFolderPath]];
    
    
    NSDirectoryEnumerator *de= [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString* file;
    BOOL isDirectory;
    
    for(file in de)
    {
        //first check if it's a file
        NSString* fullPath = [NSString stringWithFormat:@"%@/%@",path,file];
        
        //first check if it's a file
        BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
        
        if (fileExistsAtPath) {
            if (!isDirectory) //its a file
            {
                //Do with file
                 NSString* targetfullPath = [NSString stringWithFormat:@"%@/%@",targetFolderPath,file];
                
                
                //Do with filepath
                [self logText:[NSString stringWithFormat:@"Its File  SOURCE= %@", fullPath]];
                [self logText:[NSString stringWithFormat:@"Its File  TARGET= %@", targetfullPath]];
                
                [self uploadFileToDevice:fullPath  destFile: targetfullPath];

            }
            else{ //it's a folder, so recurse
                
                [self enumerateFolder:fullPath appFolderName:appFolderName];
            }
        }
        else
            printf("\nenumeratefolder No file at path %s",[file UTF8String]);
    
    }
} */

-(NSString*)getRelativePath:(NSString*) fullPath appFolderName:(NSString*) appFolderName
{
    
    NSRange range = [fullPath rangeOfString:appFolderName];
    NSInteger idx = range.location; //+ range.length;
    NSString *substr = [fullPath substringFromIndex:idx];
    
    return substr;
}

#pragma mark Execute Commands
-(void)giveAllPermissionsToPath:(NSString *)path
{
    if (![appDelegate isInternetConnectionEnabled])
        return;
    
    NSString *cmd = [NSString stringWithFormat:@"chmod 777 %@/*",path];
    [self logText:[NSString stringWithFormat:@"giveAllPermissionsToPath cmd = %@", cmd]];
    NSError *error = nil;
    NSString *response = [session.channel execute:cmd error:&error];
    [self logText:[NSString stringWithFormat:@"chmod resposne: %@", response]];
}

#pragma mark Log Methods

- (void)logText:(NSString*)text
{
    NSString *textWithNewLine = [NSString stringWithFormat:@"%@\n", text];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString* attr = [[NSAttributedString alloc] initWithString:textWithNewLine];
        
        [[txtLogs textStorage] appendAttributedString:attr];
        [txtLogs scrollRangeToVisible:NSMakeRange([[txtLogs string] length], 0)];
    });
}

#pragma mark SSH Delegate Methods
// Session delegates
- (void)session:(NMSSHSession *)session didDisconnectWithError:(NSError *)error
{
    [self logText:[NSString stringWithFormat:@"didDisconnectWithError: %@", [error description]]];
}

// Channel delegates
- (void)channel:(NMSSHChannel *)channel didReadError:(NSString *)error
{
    [self logText:[NSString stringWithFormat:@"didReadError: %@", [error description]]];
}



@end
