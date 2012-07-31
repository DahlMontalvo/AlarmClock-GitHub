//
//  EditRepeatViewController.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditRepeatViewController.h"
#import "Singleton.h"
#import "Alarm.h"

@implementation EditRepeatViewController
@synthesize mondayButton;
@synthesize tuesdayButton;
@synthesize wednesdayButton;
@synthesize thursdayButton;
@synthesize fridayButton;
@synthesize saturdayButton;
@synthesize sundayButton;


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)viewDidLoad {
    NSMutableArray *cells = [[NSMutableArray alloc] initWithObjects:mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton, nil];
    
    for (int i = 0; i < 7; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        if ([[[[Singleton sharedSingleton] sharedPrefs] objectForKey:[NSString stringWithFormat:@"editAlarmRepeatArray%i", i]] intValue] == 1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }        
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int weekday = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;   
        [[[Singleton sharedSingleton] sharedPrefs] setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"editAlarmRepeatArray%i", weekday]];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;   
        [[[Singleton sharedSingleton] sharedPrefs] setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"editAlarmRepeatArray%i", weekday]];
    }
}

- (void)viewDidUnload
{
    [self setMondayButton:nil];
    [self setTuesdayButton:nil];
    [self setWednesdayButton:nil];
    [self setThursdayButton:nil];
    [self setFridayButton:nil];
    [self setSaturdayButton:nil];
    [self setSundayButton:nil];
    [self setWednesdayButton:nil];
    [self setThursdayButton:nil];
    [self setFridayButton:nil];
    [self setSaturdayButton:nil];
    [self setSundayButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
