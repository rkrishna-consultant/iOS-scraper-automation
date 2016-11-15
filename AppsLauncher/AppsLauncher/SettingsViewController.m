//
//  SettingsViewController.m
//  AppsLauncher
//
//  Created by Radha on 03/11/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import "SettingsViewController.h"
#import "QuixeyAgentHelper.h"
#import "Constants.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchRecording;
- (IBAction)recorderChanged:(id)sender;

@end

@implementation SettingsViewController
@synthesize itemsArray;
@synthesize tableView;

- (void)viewDidLoad {
    self.title = @"Settings";
    if([QuixeyAgentHelper  getRecorderMode])
        self.switchRecording.on = YES;
    else
        self.switchRecording.on = NO;
    
    [self fillTheTablesData];
    
    tableView.delegate = self;
    tableView.dataSource = self;
  //  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    
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

#pragma mark UITableViewDelegate

// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // static NSString *CellIdentifer = @"CellIdentifier";
   //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
//    }
    
    // Deciding which data to put into this particular cell.
    // If it the first row, the data input will be "Data1" from the array.
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [itemsArray[indexPath.row] valueForKey:@"title"];
    cell.detailTextLabel.text =  [itemsArray[indexPath.row] valueForKey:@"subtitle"];
    
   
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
//    NSString* selectedTitle = [itemsArray[indexPath.row] valueForKey:@"title"];
//    NSString* selectedSubTitle = [itemsArray[indexPath.row] valueForKey:@"subtitle"];
//    NSLog(@"Selcted values=%@,%@", selectedTitle,selectedSubTitle);

    

    
    
    
    
    DetailsViewController *detailsController;
    if (indexPath.row == 0) {
        detailsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailsViewController-text"];
    }
    else
    {
        detailsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    }
    
    if(indexPath.row == 0)
        detailsController.type = TYPE_OTHER;
    else if(indexPath.row == 1)
        detailsController.type = TYPE_DLIB_PLIST;
    else
        detailsController.type = TYPE_SDK_PLIST;    
    
    detailsController.title = [itemsArray[indexPath.row] valueForKey:@"title"];
    detailsController.subtitle = [itemsArray[indexPath.row] valueForKey:@"subtitle"];
    
    [self.navigationController pushViewController:detailsController animated:YES];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}
-(void)fillTheTablesData
{
    itemsArray = @[
                      @{@"title":@"Agent App", @"subtitle":@"dylib_input.plist"},
                      @{@"title":@"Dynamic Libraries",@"subtitle":@"dylib.plist"},
                      @{@"title":@"SDK",@"subtitle":@"sdkloader.plist"},
                        ];

}
-(void)showMyAlert
{
    // typically you need know which item the user has selected.
    // this method allows you to keep track of the selection
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];
}


@end
