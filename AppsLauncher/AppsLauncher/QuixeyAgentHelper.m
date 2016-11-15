//
//  QuixeyAgentHelper.m
//  AppsLauncher
//
//  Created by Radha on 03/11/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import "QuixeyAgentHelper.h"

@implementation QuixeyAgentHelper

+(BOOL)loadDylibInputFileInAgentApplicationWithAppName:(NSString *)appName BundleId:(NSString *)bundleId
{
    //Move the File to Quixey Agent Folder
    NSString *recorderAppPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"dylib_input_%@",bundleId] ofType:@"plist"];
    //BOOL isRecorderCopied = [[NSFileManager defaultManager] copyItemAtPath:recorderAppPath toPath:recorderFilePath error:nil];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:recorderAppPath];
    BOOL isRecorderCopied = [plistDict writeToFile:recorderFilePath atomically:YES];

    
    if(isRecorderCopied)
        NSLog(@"Recorder Copied");
    else
        NSLog(@"Recorder file not copied");
    
    return  isRecorderCopied;
    
//    //SHell script
//    NSString *shellPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat: @"%@_Launch",appName] ofType:@"sh"];
//    BOOL isShellCopied = [[NSFileManager defaultManager] copyItemAtPath:shellPath toPath:shellFilePath error:nil];
//    if(isShellCopied)
//        NSLog(@"Shell Copied");
//    else
//        NSLog(@"Shell file not copied");
}

//Only for Tinder App to test the Left and right events
+(BOOL)prepareBredCrumTrayWithLeftEvent:(NSInteger)leftEventCount RightEvent:(NSInteger)rightEventCount forAppName:(NSString *)appName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:appName ofType:@"json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableDictionary *mutJsonDict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
    NSMutableDictionary *mutTrailDict = [NSMutableDictionary dictionaryWithDictionary:[mutJsonDict valueForKey:@"bcTrail"]];
    NSMutableArray *bredCrumArray = [NSMutableArray new];
    
    for (int i = 0; i < leftEventCount; i++) {
        NSMutableDictionary *leftDict = [NSMutableDictionary new];
        [leftDict setObject:@"UIPanGestureRecognizer" forKey:@"action"];
        [leftDict setObject:@"UIView+_UIPageViewControllerContentView[0]+_UIQueuingScrollView[0]" forKey:@"elementId"];
        [leftDict setObject:@"{-1, 0}" forKey:@"panDirection"];
        [leftDict setObject:@"" forKey:@"state"];
        [leftDict setObject:@"" forKey:@"textValue"];
        [bredCrumArray addObject:leftDict];
    }
    
    for (int i = 0; i < rightEventCount; i++) {
        NSMutableDictionary *rightDict = [NSMutableDictionary new];
        [rightDict setObject:@"UIPanGestureRecognizer" forKey:@"action"];
        [rightDict setObject:@"UIView+_UIPageViewControllerContentView[0]+_UIQueuingScrollView[0]" forKey:@"elementId"];
        [rightDict setObject:@"{1, 0}" forKey:@"panDirection"];
        [rightDict setObject:@"" forKey:@"state"];
        [rightDict setObject:@"" forKey:@"textValue"];
        [bredCrumArray addObject:rightDict];
    }
    
    [mutTrailDict setObject:bredCrumArray forKey:@"breadcrumb"];
    [mutJsonDict setObject:mutTrailDict forKey:@"bcTrail"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutJsonDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *inoutJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    //Preparing the dylib_input2.plist
    NSDictionary* inputDict = @{
                                @"method" : @"search",
                                @"payload" : @{
                                        @"input" : inoutJsonStr,
                                        @"mode" :@3
                                        }
                                };
    
    NSLog(@"Prepared input is : %@",inputDict);
    BOOL status = [inputDict writeToFile:recorderFilePath atomically:YES];
    if(status)
    {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Tinder Recorder file Copied" delegate:nil cancelButtonTitle:@"Okey" otherButtonTitles:nil];
        //        [alert show];
        
        NSLog(@"Tinder Recorder file Copied");
        return YES;
        
    }
    else
    {
        NSLog(@"Tinder Recorder file not Copied");
        return NO;
    }
}

+(BOOL)setAgentToQuickReplayMode
{
    //In Recorder.plist file set recorder = NO
    NSDictionary *recorderDict = [NSDictionary dictionaryWithContentsOfFile:recorderPlistFilePath];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:recorderDict];
    [mutDict setObject:[NSNumber numberWithBool:NO] forKey:@"recorder"];
   return  [mutDict writeToFile:recorderPlistFilePath atomically:YES];
}
+(BOOL)setAgentToRecorderMode
{
    //In Recorder.plist file set recorder = YES
    //In Recorder.plist file set recorder = NO
    NSDictionary *recorderDict = [NSDictionary dictionaryWithContentsOfFile:recorderPlistFilePath];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:recorderDict];
    [mutDict setObject:[NSNumber numberWithBool:YES] forKey:@"recorder"];
    return  [mutDict writeToFile:recorderPlistFilePath atomically:YES];
}
+(BOOL)getRecorderMode
{
    NSDictionary *recorderDict = [NSDictionary dictionaryWithContentsOfFile:recorderPlistFilePath];
    return [[recorderDict valueForKey:@"recorder"] boolValue];
}

@end
