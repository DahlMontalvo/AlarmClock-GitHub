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
    [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"newAlarmTime"];
    for (int i = 0; i < 7; i++) {
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:[NSString stringWithFormat:@"newAlarmRepeatArray%i", i]];
    }
	[self.delegate addAlarmViewControllerDidCancel:self];
    NSLog(@"Cancelled");
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
    
    //Kollar om något annat fel uppstått och utformar meddelande
    if (error == 1) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please use another name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([nameField.text length] == 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a name for the alarm" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        //****************************
        //Om inte, lägg till ett alarm
        //****************************
        
        //Y är antalet alarm - innan vi lägger till
        int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"newAlarmID"]; 
        
        //Skapar nytt alarm
        Alarm *alarm = [[Alarm alloc] init];
        alarm.name = nameField.text;
        alarm.identifier = nameField.text;
        alarm.fireDate = [[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"newAlarmTime"];
        alarm.alarmState = 1;
        
        NSMutableArray *repeatArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 7; i++) {
            if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"newAlarmRepeatArray%i",i]] intValue] == 1) {
                [repeatArray insertObject:[NSNumber numberWithInteger:1] atIndex:i];
            }
            else { 
                [repeatArray insertObject:[NSNumber numberWithInteger:0] atIndex:i];
            }
        }
        alarm.repeat = repeatArray;
        
        //Settar sharedPrefs firedateY till firedaten
        /*[[[Singleton sharedSingleton] sharedPrefs] setValue:[[[Singleton sharedSingleton] sharedPrefs] valueForKey:@"newAlarmTime"]];*/
        
        NSString *localString = nameField.text;
    
        [[[Singleton sharedSingleton] sharedPrefs] setValue:localString forKey:[NSString stringWithFormat:@"name%i",y]]; 
        [[[Singleton sharedSingleton] sharedPrefs] setValue:alarm.fireDate forKey:[NSString stringWithFormat:@"time%i",y]]; 
        [[[Singleton sharedSingleton] sharedPrefs] setValue:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"CurrentSwitchState%i",y]]; 
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
	if (indexPath.section == 0) {
		[self.nameField becomeFirstResponder];
    }
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dismissKeyboard:(id)sender
{
     [nameField resignFirstResponder];
}

-(void) setTimeLabel {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"24HourClockSetting"] == 0) {
        [outputFormatter setDateFormat:@"h:mm a"];
    }
    else {
        [outputFormatter setDateFormat:@"HH:mm"];
    }
    NSDate *date = [NSDate date];
    if ([[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"newAlarmTime"] != nil) {
        date = [[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"newAlarmTime"];
    }
    timeSideLabel.text = [outputFormatter stringFromDate:date];
}

-(void) setRepeatLabel {
    NSString *text = @"";
    NSMutableArray *days = [[NSMutableArray alloc] initWithObjects:@"M",@"T",@"W",@"T",@"F",@"S",@"S", nil];
    for (int i = 0; i < 7; i++) {
        if ([[[[Singleton sharedSingleton] sharedPrefs] objectForKey:[NSString stringWithFormat:@"newAlarmRepeatArray%i", i]] intValue] == 1) {
            text = [NSString stringWithFormat:@"%@ %@", text, [days objectAtIndex:i]];
        }
        else {
            text = [NSString stringWithFormat:@"%@ _", text];
        }
    }
    if ([text isEqualToString:@" _ _ _ _ _ _ _"]) {
        text = @"Once";
    }
    else if ([text isEqualToString:@" M T W T F S S"]) {
        text = @"Every day";
    }
    else if ([text isEqualToString:@" M T W T F _ _"]) {
        text = @"Every weekday";
    }
    repeatSideLabel.text = text;
}

// ...

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //viewDidLoad kallas bara en gång per skapat alarm - precis när man ska börja skapa det ("viewDidLoad")
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    [[[Singleton sharedSingleton] sharedPrefs] setInteger:y forKey:@"newAlarmID"];
    
    //Då nollställer vi repeaten om det mot förmodan skulle hänga kvar något
    //GÅR FRÅN 0-6
    for (int i = 0; i < 7; i++) {
        [[[Singleton sharedSingleton] sharedPrefs] setValue:nil forKey:[NSString stringWithFormat:@"newAlarmRepeatArray%i", i]];
    }
    
    //Sätt det nya alarmets tid till nu, ifall något gammalt hänger kvar
    [[[Singleton sharedSingleton] sharedPrefs] setValue:[NSDate date] forKey:@"newAlarmTime"];
    
    [self setTimeLabel];
    [self setRepeatLabel];
        
    [super viewDidLoad];
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
    //int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    [self setTimeLabel];
    [self setRepeatLabel];    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{    
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
    return 1;
}

@end
