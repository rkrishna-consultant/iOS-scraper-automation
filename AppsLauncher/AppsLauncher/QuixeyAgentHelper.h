//
//   Do any additional setup after loading the view, typically from a nib. } QuixeyAgentHelper.h
//  AppsLauncher
//
//  Created by Radha on 03/11/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppsLauncher-Swift.h"

static NSString *recorderFilePath = @"/Applications/QuixeyAgent.app/dylib_input.plist";
static NSString *recorderPlistFilePath = @"/Applications/QuixeyAgent.app/Recorder.plist";



static NSString *destAppIdentifier = @"com.cardify.tinder";


@interface QuixeyAgentHelper : NSObject
+(BOOL)loadDylibInputFileInAgentApplicationWithAppName:(NSString *)appName BundleId:(NSString *)bundleId;
+(BOOL)setAgentToQuickReplayMode;
+(BOOL)setAgentToRecorderMode;
+(BOOL)getRecorderMode;


@end
