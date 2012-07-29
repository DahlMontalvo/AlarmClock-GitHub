//
//  AddAlarmViewController.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddAlarmViewController.h"
#import "Alarm.h"
#import "Singleton.h"
#import "minTableViewController.h"

@implementation AddAlarmViewController
@synthesize titlesArray;
@synthesize delegate;
@synthesize repeatLabel;
@synthesize nameField;
@synthesize timeSideLabel;
@synthesize vanligArray;
@synthesize localNotif;
@synthesize repeatSideLabel;




- (IBAction)cancel:(id)sender
{
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"]; 
    [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:[NSString stringWithFormat:@"repeatString%i",y]];
    [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:[NSString stringWithFormat:@"dag0%i",y]];
    [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:[NSString stringWithFormat:@"dag1%i",y]];
    [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:[NSString stringWithFormat:@"dag2%i",y]];
    [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:[NSString stringWithFormat:@"dag3%i",y]];
    [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:[NSString stringWithFormat:@"dag4%i",y]];
    [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:[NSString stringWithFormat:@"dag5%i",y]];
    [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:[NSString stringWithFormat:@"dag6%i",y]];
	[self.delegate addAlarmViewControllerDidCancel:self];
}
- (IBAction)save:(id)sender
{
    int error = 0;
    
    //Loopar igenom alla alarm för att se om namnet redan finns
    for (int i = 0; i < [[[Singleton sharedSingleton] sharedAlarmsArray] count]; i++) {
        if ([[[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:i] name] isEqualToString:nameField.text]) {
            error = 1;
        }
        if ([[[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:i] identifier] isEqualToString:nameField.text]) {
            error = 1;
        }
    }
    
    //Kollar om något fel uppstått
    if (error == 1) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please use another name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([nameField.text length] == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a name for the alarm" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([[[Singleton sharedSingleton] sharedFireDates] count] == 0 || ![[Singleton sharedSingleton] sharedFireDates]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a time for the alarm" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        //****************************
        //Om inte, lägg till ett alarm
        //****************************
        
        //Y är antalet alarm - innan vi lägger till
        int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"]; 
        
        //Skapar nytt alarm
        Alarm *alarm = [[Alarm alloc] init];
        alarm.name = nameField.text;
        alarm.identifier = nameField.text;
        alarm.fireDate = [[[Singleton sharedSingleton] sharedFireDates]objectAtIndex:[[[Singleton sharedSingleton] sharedFireDates] count]-1];
        alarm.alarmState = 1;
        
        NSMutableArray *repeatArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 7; i++) {
            if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag%i%i",i,y]] isEqualToString:@"1"]) {
                [repeatArray insertObject:[NSNumber numberWithInteger:1] atIndex:i];
            }
            else { 
                [repeatArray insertObject:[NSNumber numberWithInteger:0] atIndex:i];
            }
        }
        alarm.repeat = repeatArray;
        
        //Settar sharedPrefs firedateY till firedaten
        [[[Singleton sharedSingleton] sharedPrefs] setValue:[[[Singleton sharedSingleton] sharedFireDates]objectAtIndex:[[[Singleton sharedSingleton] sharedFireDates] count]-1] forKey:[NSString stringWithFormat:@"firedate%i",y]];
        
        NSString *localString = nameField.text;
    
        [[[Singleton sharedSingleton] sharedPrefs] setValue:localString forKey:[NSString stringWithFormat:@"name%i",y]];   
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    
        [self.delegate addAlarmViewController:self didAddAlarm:alarm];
        
        //Lägger till en notification, så att alarmet faktiskt ringer...
        [alarm registerAlarm];
        
        //Det ska by default vara påslaget
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:[NSString stringWithFormat:@"CurrentSwitchState%i",y]];
        [[[Singleton sharedSingleton] sharedPrefs] setValue:repeatArray forKey:[NSString stringWithFormat:@"repeat%i",y]];
        //Vi ökar y med 1, eftersom vi lagt till ett nytt alarm
        y = y + 1;
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:y forKey:@"Counter"];
        [[[Singleton sharedSingleton] sharedFireDates] removeAllObjects];
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    }
    
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
		[self.nameField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    NSLog(@"Kommer hit");
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    [[[Singleton sharedSingleton] sharedPrefs] setValue:@"Once" forKey:[NSString stringWithFormat:@"repeatString%i",y]];
    
    timeSideLabel.text = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"time%i",y]];
    repeatSideLabel.text = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"repeatString%i",y]];
        
    titlesArray = [[NSMutableArray alloc]init];
    [titlesArray addObject:@"Time"];
    [titlesArray addObject:@"Repeat"];
    [titlesArray addObject:@"Sound"];
    [titlesArray addObject:@"Snooze"];
    [titlesArray addObject:@"Whatever"];
    
    for (int i = 0; i < 7; i++) {
        [[[Singleton sharedSingleton] sharedPrefs] setValue:[NSString stringWithFormat:@"%i",0] forKey:[NSString stringWithFormat:@"dag%i",i]];
    }
        
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
     NSLog(@"Number of objects in alarms after ViewDidLoad in AddAlarm: %i",[[[Singleton sharedSingleton] sharedAlarmsArray]count]);
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setRepeatLabel:nil];
    [self setRepeatSideLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    timeSideLabel.text = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"time%i",y]];
    repeatSideLabel.text = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"repeatString%i",y]];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    timeSideLabel.text = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"time%i",y]];
    timeSideLabel.text = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"repeatString%i",y]];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;    
}

*/





 

/*
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *CellIdentifier = @"Cell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 
 
 cell.textLabel.text = [titlesArray objectAtIndex:indexPath.row];
 
 return cell;
 }
 
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


@end
