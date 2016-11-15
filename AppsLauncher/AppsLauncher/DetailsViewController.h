//
//  DetailsViewController.h
//  AppsLauncher
//
//  Created by Ibase on 11/14/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPopUp.h"

static NSString *dynamicLibraryPlistPath=@"/Library/MobileSubstrate/DynamicLibraries/QXDynamicLib.plist";
static NSString *sdkLibraryPlistPath =@"/Library/MobileSubstrate/DynamicLibraries/SDKLoader.plist";

@interface DetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,ClickDelegates>

@property (nonatomic) int type;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *pListItemsArray;

-(id)initWithFrame:(CGRect) theFrame;
-(void) getDynamicLibraryPList;
-(void) getBundleIdentifierList;
-(void) getSDKIdentifierList;
-(void) addBundleIdentifier;
-(void)loadSpinner;
-(void)checkAndUpdateBundleIdentifier:(NSString*) bundleID;
-(BOOL)addBundleIdentifierToPlist:(NSString*) bundleID;
-(void)updatedIdentifiersIntoTableView:(NSString*)idStr;


@end
