//
//  IOPMenuViewController.m
//  Miraath
//
//  Created by Jonathan Flintham on 18/04/2013.
//  Copyright (c) 2013 Jonathan Flintham. All rights reserved.
//

#import "IOPMenuTableViewController.h"
#import "IOPRadioViewController.h"
#import "UIViewController+SlideMenu.h"

@interface IOPMenuTableViewController ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation IOPMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		NSString *dictionaryPath = [[NSBundle mainBundle] pathForResource:@"MenuContent" ofType:@"plist"];
		NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:dictionaryPath];
		self.data = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.data objectForKey:@"Sections"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.data objectForKey:@"Sections"] objectAtIndex:section] objectForKey:@"title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSDictionary *sectionDictionary = [[self.data objectForKey:@"Sections"] objectAtIndex:section];
	return [[sectionDictionary objectForKey:@"cells"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
	
	
    // Configure the cell...
	NSDictionary *sectionDictionary = [[self.data objectForKey:@"Sections"] objectAtIndex:indexPath.section];
	cell.textLabel.text =  [[[sectionDictionary objectForKey:@"cells"] objectAtIndex:indexPath.row] objectForKey:@"title"];
	
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionDictionary = [[self.data objectForKey:@"Sections"] objectAtIndex:indexPath.section];
	NSDictionary *channelInfo = [[sectionDictionary objectForKey:@"cells"] objectAtIndex:indexPath.row];
    
    IOPRadioViewController *rvc = [[IOPRadioViewController alloc] init];
    rvc.channelInfo = channelInfo;
    
    [self.containerViewController dismissMenuViewController:YES andPresentViewController:rvc];
}

@end
