//
//  AddSoundViewController.m
//  alarm1
//
//  Created by Jonas Dahl on 8/23/12.
//
//

#import "AddSoundViewController.h"

@interface AddSoundViewController ()

@end

@implementation AddSoundViewController

@synthesize soundArray;

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    soundArray = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:@"soundArray"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else {
        return [soundArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        //Första raden - Own...
        cell.textLabel.text = @"Own...";
        if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"newAlarmSoundType"] == 0) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    else {
        cell.textLabel.text = [[soundArray objectAtIndex:indexPath.row] objectAtIndex:0];
        if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"newAlarmSoundType"] == 1 && [[[soundArray objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:[[[[Singleton sharedSingleton] sharedPrefs] valueForKey:@"newAlarmSoundInfo"] objectAtIndex:0]]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
        
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

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        
        //mediaItemCollection ska sparas
        MPMediaItem *item = [[mediaItemCollection items] objectAtIndex:0];
        [[[Singleton sharedSingleton] sharedPrefs] setValue:item forKey:@"newAlarmSoundItem"];
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:0 forKey:@"newAlarmSoundType"];
        [[[Singleton sharedSingleton] sharedPrefs] setValue:nil forKey:@"newAlarmSoundInfo"];
        //Nu har vi sparat låten i Singletonen
        //Uppdatera labeln
        //soundLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
        
    }
    else {
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
        [[[Singleton sharedSingleton] sharedPrefs] setValue:nil forKey:@"newAlarmSoundItem"];
        [[[Singleton sharedSingleton] sharedPrefs] setValue:nil forKey:@"newAlarmSoundType"];
        [[[Singleton sharedSingleton] sharedPrefs] setValue:nil forKey:@"newAlarmSoundInfo"];
        [self.tableView reloadData];
    }
    
    [self dismissModalViewControllerAnimated: YES];
}


- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    [[[Singleton sharedSingleton] sharedPrefs] setValue:nil forKey:@"newAlarmSoundItem"];
    [[[Singleton sharedSingleton] sharedPrefs] setValue:nil forKey:@"newAlarmSoundType"];
    [[[Singleton sharedSingleton] sharedPrefs] setValue:nil forKey:@"newAlarmSoundInfo"];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    for (int i = 0; i < [soundArray count]; i++) {
        [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    if (indexPath.section == 0) {
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
        
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = NO;
        mediaPicker.prompt = @"Select sound";
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        @try {
            
            [mediaPicker loadView];
            [self presentModalViewController:mediaPicker animated:YES];
            
        }
        @catch (NSException *exception) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!",@"Error")
                                        message:NSLocalizedString(@"The music library is not available.",@"Couldn't load media list.")
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
            [self.tableView reloadData];
        }
    }
    else {
        [[[Singleton sharedSingleton] sharedPrefs] setValue:nil forKey:@"newAlarmSoundItem"];
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:@"newAlarmSoundType"];
        [[[Singleton sharedSingleton] sharedPrefs] setValue:[soundArray objectAtIndex:indexPath.row] forKey:@"newAlarmSoundInfo"];
    }
    
}

@end
