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
    
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    
    UITableViewCell *cell = mondayButton;    
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag2%i",y]] isEqualToString:@"1"])  cell.accessoryType = UITableViewCellAccessoryCheckmark;  
    else  cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell = tuesdayButton;    
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag3%i",y]] isEqualToString:@"1"])  cell.accessoryType = UITableViewCellAccessoryCheckmark;  
    else  cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell = wednesdayButton;    
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag4%i",y]] isEqualToString:@"1"])  cell.accessoryType = UITableViewCellAccessoryCheckmark;  
    else  cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell = thursdayButton;    
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag5%i",y]] isEqualToString:@"1"])  cell.accessoryType = UITableViewCellAccessoryCheckmark;  
    else  cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell = fridayButton;    
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag6%i",y]] isEqualToString:@"1"])  cell.accessoryType = UITableViewCellAccessoryCheckmark;  
    else  cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell = saturdayButton;    
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag7%i",y]] isEqualToString:@"1"])  cell.accessoryType = UITableViewCellAccessoryCheckmark;  
    else  cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell = sundayButton;    
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag1%i",y]] isEqualToString:@"1"])  cell.accessoryType = UITableViewCellAccessoryCheckmark;  
    else  cell.accessoryType = UITableViewCellAccessoryNone;
    
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
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    int weekday = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;   
        [[[Singleton sharedSingleton] sharedPrefs] setValue:[NSString stringWithFormat:@"%i",1] forKey:[NSString stringWithFormat:@"dag%i%i",weekday,y]];
        NSLog(@"Checkade %i", weekday); 
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;   
        [[[Singleton sharedSingleton] sharedPrefs] setValue:[NSString stringWithFormat:@"%i",0] forKey:[NSString stringWithFormat:@"dag%i%i",weekday,y]];
        NSLog(@"Uncheckade %i", weekday);
    }
    
    NSString *repeatText = @"";
    
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag2%i",y]] isEqualToString:@"1"])  repeatText = [NSString stringWithFormat:@"%@M",repeatText];    else  repeatText = [NSString stringWithFormat:@"%@ ",repeatText];
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag3%i",y]] isEqualToString:@"1"])  repeatText = [NSString stringWithFormat:@"%@T",repeatText];    else  repeatText = [NSString stringWithFormat:@"%@ ",repeatText];
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag4%i",y]] isEqualToString:@"1"])  repeatText = [NSString stringWithFormat:@"%@W",repeatText];    else  repeatText = [NSString stringWithFormat:@"%@ ",repeatText];
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag5%i",y]] isEqualToString:@"1"])  repeatText = [NSString stringWithFormat:@"%@T",repeatText];    else  repeatText = [NSString stringWithFormat:@"%@ ",repeatText];
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag6%i",y]] isEqualToString:@"1"])  repeatText = [NSString stringWithFormat:@"%@F",repeatText];    else  repeatText = [NSString stringWithFormat:@"%@ ",repeatText];
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag7%i",y]] isEqualToString:@"1"])  repeatText = [NSString stringWithFormat:@"%@S",repeatText];    else  repeatText = [NSString stringWithFormat:@"%@ ",repeatText];
    if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"dag1%i",y]] isEqualToString:@"1"])  repeatText = [NSString stringWithFormat:@"%@S",repeatText];    else  repeatText = [NSString stringWithFormat:@"%@ ",repeatText];
    
    if ([repeatText isEqualToString:@"       "]) {
        repeatText = @"Once";
    }
    else if ([repeatText isEqualToString:@"MTWTFSS"]) {
        repeatText = @"Daily";
    }

    [[[Singleton sharedSingleton] sharedPrefs] setValue:repeatText forKey:[NSString stringWithFormat:@"repeatString%i",y]];
    
    
    
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
