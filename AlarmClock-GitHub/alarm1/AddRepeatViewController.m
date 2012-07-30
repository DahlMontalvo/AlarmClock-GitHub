//
//  AddRepeatViewController.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddRepeatViewController.h"
#import "Singleton.h"
#import "Alarm.h"

@implementation AddRepeatViewController
@synthesize mondayButton;
@synthesize tuesdayButton;
@synthesize wednesdayButton;
@synthesize thursdayButton;
@synthesize fridayButton;
@synthesize saturdayButton;
@synthesize sundayButton;

-(void)viewDidLoad {
    NSMutableArray *cells = [[NSMutableArray alloc] initWithObjects:mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton, nil];
    
    for (int i = 0; i < 7; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        if ([[[[Singleton sharedSingleton] sharedPrefs] objectForKey:[NSString stringWithFormat:@"newAlarmRepeatArray%i", i]] intValue] == 1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }        
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int weekday = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;   
        [[[Singleton sharedSingleton] sharedPrefs] setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"newAlarmRepeatArray%i", weekday]];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;   
        [[[Singleton sharedSingleton] sharedPrefs] setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"newAlarmRepeatArray%i", weekday]];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
