//
//  AddBundleViewController.h
//  AppsLauncher
//
//  Created by Ibase on 11/15/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuixeyAgentHelper.h"
#import "DetailsViewController.h"
#import "Constants.h"


@interface AddBundleViewController : UIViewController
@property (nonatomic) int type;
@property (nonatomic,strong) NSString *existingIdentifier;


@end
