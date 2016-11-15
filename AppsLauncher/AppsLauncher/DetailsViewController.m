//
//  DetailsViewController.m
//  AppsLauncher
//
//  Created by Ibase on 11/14/16.
//  Copyright © 2016 Quixey. All rights reserved.
//

#import "DetailsViewController.h"
#import "QuixeyAgentHelper.h"
#import "CustomPopUp.h"
#import "Constants.h"
#import "AddBundleViewController.h"



@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtView;

@end

@implementation DetailsViewController{
    CustomPopUp *mPopUp;
    UIActivityIndicatorView *indicator;
}
@synthesize title,subtitle, type;
@synthesize pListItemsArray;
@synthesize tableView;


- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBundleIdentifier)];
    

    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.type == TYPE_OTHER)
    {
        //Other code
        //NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"dylib_input_com.pandora" ofType:@"plist"];
        NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:recorderFilePath];
        NSPropertyListFormat format;
        NSDictionary *plistContents = (NSDictionary*)[NSPropertyListSerialization
                                                      propertyListFromData:plistXML
                                                      mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                      format:&format
                                                      errorDescription:nil];
        NSLog(@"plistContents is %@",plistContents);
        self.txtView.text = [NSString stringWithFormat:@"%@",plistContents];
        
        
    }else if(self.type == TYPE_DLIB_PLIST)
    {
        [self getDynamicLibraryPList];
    }else{
        
        [self getSDKIdentifierList];
    }
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


#pragma mark UITableViewDelegate
// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pListItemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = pListItemsArray[indexPath.row];
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddBundleViewController *addBundleViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddBundleViewController"];
    addBundleViewController.type = self.type;
    addBundleViewController.existingIdentifier = pListItemsArray[indexPath.row];
    [self.navigationController pushViewController:addBundleViewController animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

-(void) getDynamicLibraryPList
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:dynamicLibraryPlistPath]) {
       pListItemsArray = [[[NSDictionary dictionaryWithContentsOfFile:dynamicLibraryPlistPath] valueForKey:@"Filter"] valueForKey:@"Bundles"];
    }
    [self.tableView reloadData];
}
-(void) getSDKIdentifierList
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:sdkLibraryPlistPath]) {
        pListItemsArray = [[[NSDictionary dictionaryWithContentsOfFile:sdkLibraryPlistPath] valueForKey:@"Filter"] valueForKey:@"Bundles"];
    }
    [self.tableView reloadData];
}
-(void)addBundleIdentifier
{
   AddBundleViewController *addBundleViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddBundleViewController"];
    addBundleViewController.type = self.type;
    [self.navigationController pushViewController:addBundleViewController animated:YES];
}

@end
