//
//  SettingsViewController.m
//  alarm1
//
//  Created by Jonas Dahl on 8/21/12.
//
//

#import "SettingsViewController.h"
#import "Singleton.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize setting;

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
    NSLog(@"Nu ändrar vi i %@", setting);
    
    self.title = [setting objectAtIndex:0];
    
    [super viewDidLoad];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[setting objectAtIndex:3] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([[NSString stringWithFormat:@"%@", [[setting objectAtIndex:3] objectAtIndex:indexPath.row] ] isEqualToString:[NSString stringWithFormat:@"%@", [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[setting objectAtIndex:2]]]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[setting objectAtIndex:3] objectAtIndex:indexPath.row]];
    
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (int i = 0; i < [[setting objectAtIndex:3] count]; i++) {
        UITableViewCell *cellToRemoveCheckmarkFrom = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cellToRemoveCheckmarkFrom setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[[Singleton sharedSingleton] sharedPrefs] setValue:[[setting objectAtIndex:3] objectAtIndex:indexPath.row] forKey:[setting objectAtIndex:2]];
    
    NSLog(@"[[[Singleton sharedSingleton] sharedPrefs] setValue:%@ forKey:%@];", [[setting objectAtIndex:3] objectAtIndex:indexPath.row], [setting objectAtIndex:2]);
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
}

@end
