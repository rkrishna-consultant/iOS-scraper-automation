//
//  AddBundleViewController.m
//  AppsLauncher
//
//  Created by Ibase on 11/15/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import "AddBundleViewController.h"

@interface AddBundleViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtBundleId;

@end

@implementation AddBundleViewController

- (void)viewDidLoad {
    self.title = @"Add BundleId";
    if(self.existingIdentifier)
    {
       self.txtBundleId.text = self.existingIdentifier;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updateBundleIdentifier)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addBundleIdentifier)];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)addBundleIdentifier
{
    if(self.txtBundleId.text.length == 0)
        return;
    NSString *bundleID = self.txtBundleId.text;
    
    //DYLIb Bundle Id Adding
    NSDictionary *dylibDict = [NSDictionary dictionaryWithContentsOfFile:dynamicLibraryPlistPath];
    NSDictionary *sdkDict = [NSDictionary dictionaryWithContentsOfFile:sdkLibraryPlistPath];
    
    NSString *dylibBundleId,*sdkBundleId;
    
    NSMutableArray *dyLibBundleIdsArray = [[NSMutableArray alloc]initWithArray:[[dylibDict valueForKey:@"Filter"] valueForKey:@"Bundles"]];
    NSMutableArray *sdkBundleIdsArray = [[NSMutableArray alloc]initWithArray:[[sdkDict valueForKey:@"Filter"] valueForKey:@"Bundles"]];
    
    if(self.type == TYPE_DLIB_PLIST)
    {
        dylibBundleId = bundleID;
        sdkBundleId = [NSString stringWithFormat:@"-%@",bundleID];
        if(self.existingIdentifier)
            [dyLibBundleIdsArray removeObject:self.existingIdentifier];
    }
    else if(self.type == TYPE_SDK_PLIST)
    {
        dylibBundleId = [NSString stringWithFormat:@"-%@",bundleID];
        sdkBundleId = bundleID;
        if(self.existingIdentifier)
            [sdkBundleIdsArray removeObject:self.existingIdentifier];
    }
    
    if(![dyLibBundleIdsArray containsObject:bundleID] || ![dyLibBundleIdsArray containsObject:[NSString stringWithFormat:@"-%@",bundleID]])
    {
        [dyLibBundleIdsArray addObject:dylibBundleId];
    }
    
    if(![sdkBundleIdsArray containsObject:bundleID] || ![sdkBundleIdsArray containsObject:[NSString stringWithFormat:@"-%@",bundleID]])
    {
        [sdkBundleIdsArray addObject:sdkBundleId];
    }
    
    
    
    NSDictionary *finalDylibDict = @{ @"Filter": @{
                                              @"Bundles": dyLibBundleIdsArray
                                              }
                                      };
    NSDictionary *finalSDKDict = @{ @"Filter": @{ @"Bundles": sdkBundleIdsArray
                                                  }
                                    };
    
    NSLog(@"finalDylibDict is %@",finalDylibDict);
    NSLog(@"finalSDKDict is %@",finalSDKDict);
    
    BOOL dylibStatus = [finalDylibDict writeToFile:dynamicLibraryPlistPath atomically:YES];
    BOOL sdkStatus = [finalSDKDict writeToFile:sdkLibraryPlistPath atomically:YES];
    if(dylibStatus && sdkStatus)
    {
        NSLog(@"File saved");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"Unable to write it in %@",dynamicLibraryPlistPath] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}


@end
