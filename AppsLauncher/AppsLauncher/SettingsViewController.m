//
//  SettingsViewController.m
//  AppsLauncher
//
//  Created by Radha on 03/11/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import "SettingsViewController.h"
#import "QuixeyAgentHelper.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchRecording;
- (IBAction)recorderChanged:(id)sender;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    self.title = @"Settings";
    if([QuixeyAgentHelper  getRecorderMode])
        self.switchRecording.on = YES;
    else
        self.switchRecording.on = NO;

        
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)recorderChanged:(id)sender {
    if(self.switchRecording.isOn)
        [QuixeyAgentHelper setAgentToRecorderMode];
    else
        [QuixeyAgentHelper setAgentToQuickReplayMode];
}
@end
