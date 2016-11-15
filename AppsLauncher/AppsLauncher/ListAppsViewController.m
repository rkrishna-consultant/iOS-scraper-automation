//
//  ListAppsViewController.m
//  AppsLauncher
//
//  Created by Radha on 03/11/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import "ListAppsViewController.h"
#import "SettingsViewController.h"

@interface ListAppsViewController ()

@end

@implementation ListAppsViewController

- (void)viewDidLoad {
    self.title = @"Quixey App Launcher";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsChanged)];
    
    appsListArray = @[
                                    @{@"concept":@"search product name on amazon", @"appName":@"amazon", @"bundleId":@"com.amazon.Amazon"},
                                    @{@"concept":@"show friends nearby on facebook",@"appName":@"facebook",@"bundleId":@"com.facebook.Facebook"},
                                    @{@"concept":@"tweet text on twitter",@"appName":@"twitter",@"bundleId":@"com.atebits.Tweetie2"},
                                    @{@"concept":@"check account summary on mint",@"appName":@"mint",@"bundleId":@"com.mint.internal"},
                                    @{@"concept":@"turn flashlight on",@"appName":@"flash",@"bundleId":@"com.ihandysoft.flashlight.led.pro"},
                                    @{@"concept":@"search product name on wish",@"appName":@"wish",@"bundleId":@"com.contextlogic.Wish"},
                                    @{@"concept":@"Search product name on overstock",@"appName":@"overstock",@"bundleId":@"com.overstock.app"},
                                    @{@"concept":@"Check gas prices in gas buddy",@"appName":@"overstock",@"bundleId":@"com.gasbuddymobile.gasbuddy"},
                                    @{@"concept":@"play playlist on spotify",@"appName":@"spotify",@"bundleId":@"com.spotify.client"},
                                    @{@"concept":@"start song name on pandora",@"appName":@"pandora",@"bundleId":@"com.pandora"}
                     ];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)settingsChanged
{
    SettingsViewController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsController animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appsListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [appsListArray[indexPath.row] valueForKey:@"concept"];
    cell.detailTextLabel.text =  [appsListArray[indexPath.row] valueForKey:@"bundleId"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath caleld");
    NSString *appName = [appsListArray[indexPath.row] valueForKey:@"appName"];
    NSString *bundleIdentifier = [appsListArray[indexPath.row] valueForKey:@"bundleId"];
    
    BOOL isRecorderCopied = [QuixeyAgentHelper loadDylibInputFileInAgentApplicationWithAppName:appName BundleId:bundleIdentifier];
     BOOL isRecordMode = [QuixeyAgentHelper setAgentToQuickReplayMode];
    NSLog(@"isRecordMode changed :%d",isRecordMode);
    
    //Executing the Script
    if(isRecorderCopied)
    {
        ExecuteCmd *exec = [[ExecuteCmd alloc] init];
        NSError *error;
        [exec run:@"/usr/bin/sbMaster" arguments:[NSArray arrayWithObjects:@"kill",bundleIdentifier,nil] error:&error];
        [exec run:@"/usr/bin/sbMaster" arguments:[NSArray arrayWithObjects:@"launch",bundleIdentifier,nil] error:&error];
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"Okey" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        //NO Action
    }

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
