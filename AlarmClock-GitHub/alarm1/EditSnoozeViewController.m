//
//  EditSnoozeViewController.m
//  alarm1
//
//  Created by Jonas Dahl on 8/16/12.
//
//

#import "EditSnoozeViewController.h"
#import "Singleton.h"

@interface EditSnoozeViewController ()

@end

@implementation EditSnoozeViewController

@synthesize snoozeSettingsValues;
@synthesize snoozeSettings;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    snoozeSettings = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] init], [[NSMutableArray alloc] init], nil];
    snoozeSettingsValues = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] init], [[NSMutableArray alloc] init], nil];
    
    [[snoozeSettings objectAtIndex:0] addObject:@"3 minutes"];  [[snoozeSettingsValues objectAtIndex:0] addObject:@"3"];
    [[snoozeSettings objectAtIndex:0] addObject:@"5 minutes"];  [[snoozeSettingsValues objectAtIndex:0] addObject:@"5"];
    [[snoozeSettings objectAtIndex:0] addObject:@"10 minutes"]; [[snoozeSettingsValues objectAtIndex:0] addObject:@"10"];
    [[snoozeSettings objectAtIndex:0] addObject:@"15 minutes"]; [[snoozeSettingsValues objectAtIndex:0] addObject:@"15"];
    [[snoozeSettings objectAtIndex:0] addObject:@"30 minutes"]; [[snoozeSettingsValues objectAtIndex:0] addObject:@"30"];
    [[snoozeSettings objectAtIndex:1] addObject:@"Never"];       [[snoozeSettingsValues objectAtIndex:1] addObject:@"0"];
    [[snoozeSettings objectAtIndex:1] addObject:@"Once"];       [[snoozeSettingsValues objectAtIndex:1] addObject:@"1"];
    [[snoozeSettings objectAtIndex:1] addObject:@"Twice"];      [[snoozeSettingsValues objectAtIndex:1] addObject:@"2"];
    [[snoozeSettings objectAtIndex:1] addObject:@"3 times"];    [[snoozeSettingsValues objectAtIndex:1] addObject:@"3"];
    [[snoozeSettings objectAtIndex:1] addObject:@"5 times"];    [[snoozeSettingsValues objectAtIndex:1] addObject:@"5"];
    [[snoozeSettings objectAtIndex:1] addObject:@"10 times"];   [[snoozeSettingsValues objectAtIndex:1] addObject:@"10"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [snoozeSettings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[snoozeSettings objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[snoozeSettings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ((indexPath.section == 0 && [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"editAlarmSnoozeInterval"] == [[[snoozeSettingsValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] intValue]
         ) ||
        (indexPath.section == 1 && [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"editAlarmSnoozeNumberOfTimes"] == [[[snoozeSettingsValues objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] intValue])) {
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Snooze interval";
    else
        return @"Number of times to snooze";
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (int i = 0; i < [[snoozeSettings objectAtIndex:indexPath.section] count]; i++) {
        [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    for (int i = 0; i < [[snoozeSettings objectAtIndex:0] count]; i++) {
        if ([[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] accessoryType] == UITableViewCellAccessoryCheckmark) {
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:[[[snoozeSettingsValues objectAtIndex:0] objectAtIndex:i] intValue] forKey:@"editAlarmSnoozeInterval"];
        }
    }
    for (int i = 0; i < [[snoozeSettings objectAtIndex:1] count]; i++) {
        if ([[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]] accessoryType] == UITableViewCellAccessoryCheckmark) {
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:[[[snoozeSettingsValues objectAtIndex:1] objectAtIndex:i] intValue] forKey:@"editAlarmSnoozeNumberOfTimes"];
        }
    }
}

#pragma mark - Table view delegate

@end