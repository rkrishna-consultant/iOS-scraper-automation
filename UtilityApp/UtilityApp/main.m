//
//  main.m
//  UtilityApp
//
//  Created by Radha on 02/11/2016.
//  Copyright © 2016 iBase. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"appMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];


    for (int i = 0; i < argc; i++) {
         NSString *argument = [NSString stringWithUTF8String:argv[i]];
        NSLog(@"Argument%d %@",i+1,argument);
        if ([argument containsString:@"DYLib"]) {
            [[NSUserDefaults standardUserDefaults] setObject:argument forKey:@"appMode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
        
    return NSApplicationMain(argc, argv);
}
