//
//  SettingsViewController.h
//  AppsLauncher
//
//  Created by Radha on 03/11/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"


@interface SettingsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *itemsArray;


-(void)fillTheTablesData;
-(void)showMyAlert;

@end
