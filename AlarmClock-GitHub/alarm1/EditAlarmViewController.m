//
//  EditAlarmViewController.m
//  alarm1
//
//  Created by Lion User on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditAlarmViewController.h"
#import "Alarm.h"
#import "Singleton.h"
#import "minTableViewController.h"
#import "AddTimeViewController.h"
#import "Singleton.h"
#import "AppDelegate.h"

#include <unistd.h>

@implementation EditAlarmViewController
@synthesize titlesArray;
@synthesize delegate2;
@synthesize nameField;
@synthesize timeSideLabel;
@synthesize alarmSwitch;
@synthesize localNotif;
@synthesize repeatSideLabel;
@synthesize alarmID;

- (IBAction)switchFlicked:(id)sender {
    
}

- (void)dismissKeyboard:(id)sender
{
    [nameField resignFirstResponder];
}



- (IBAction)cancel:(id)sender
{
    [[[Singleton sharedSingleton] sharedFireDates] removeAllObjects];
    [self.delegate2 editAlarmViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender
{ 
    //y är antal alarm
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    //q är index för det alarm vi försöker ändra
    int q = alarmID;
    
    int error = 0;
    
    //Loopar igenom alla alarm för att se om namnet redan finns
    for (int i = 0; i < y; i++) {
        if (i != q) {
            if ([[[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:i] name] isEqualToString:nameField.text]) {
                error = 1;
            }
            if ([[[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:i] identifier] isEqualToString:nameField.text]) {
                error = 1;
            }
        }
    }
    
    //Kollar om något annat fel uppstått och utformar felmeddelande
    if (error == 1) {
        //Om namnet redan finns
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please use another name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([nameField.text length] == 0) {
        //Om inget namn matats in
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a name for the alarm" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        //Skapa nytt alarm
        Alarm *alarm = [[Alarm alloc] init];
        alarm.name = nameField.text;
        alarm.identifier = alarm.name;
        alarm.fireDate = [[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"editAlarmTime"];
        if (alarmSwitch.on) {
            alarm.alarmState = 1;
        }
        else {
            alarm.alarmState = 0;
        }
        
        NSMutableArray *repeatArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 7; i++) {
            if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"editAlarmRepeatArray%i",i]] intValue] == 1) {
                [repeatArray insertObject:[NSNumber numberWithInteger:1] atIndex:i];
                
                //Uppdaterar staten i sharedPrefs
                [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:[NSString stringWithFormat:@"CurrentSwitchState%i",q]];
            }
            else { 
                [repeatArray insertObject:[NSNumber numberWithInteger:0] atIndex:i];
                
                //Uppdaterar staten i sharedPrefs
                [[[Singleton sharedSingleton] sharedPrefs] setInteger:0 forKey:[NSString stringWithFormat:@"CurrentSwitchState%i",q]];
            }
        }
        alarm.repeat = repeatArray;

        //Replacear det alarm vi editerar med det nyligen skapade
        [[[Singleton sharedSingleton] sharedAlarmsArray] replaceObjectAtIndex:q withObject:alarm];
        
        //Uppdaterar namnet i sharedPrefs
        [[[Singleton sharedSingleton] sharedPrefs] setValue:nameField.text forKey:[NSString stringWithFormat:@"name%i",y]];
        
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
        
        [[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:q] resceduleAlarm];
        
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"editAlarmTime"];
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"editAlarmName"];
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"editAlarmRepeat0"];
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"editAlarmRepeat1"];
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"editAlarmRepeat2"];
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"editAlarmRepeat3"];
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"editAlarmRepeat4"];
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"editAlarmRepeat5"];
        [[[Singleton sharedSingleton] sharedPrefs] removeObjectForKey:@"editAlarmRepeat6"];
    
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
        [[[Singleton sharedSingleton] sharedFireDates] removeAllObjects];
        [self.delegate2 editAlarmViewController:self didEditAlarm:alarm];
    }
}


-(void) setTimeLabel {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    NSDate *date = [[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:alarmID] fireDate];
    
    if ([[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"editAlarmTime"] != nil) {
        date = [[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"editAlarmTime"];
    }
    
    timeSideLabel.text = [outputFormatter stringFromDate:date];
}

-(void) setNameTextField {
    nameField.text = [[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"editAlarmName"];
}

-(void) setRepeatLabel {
    NSString *text = @"";
    NSMutableArray *days = [[NSMutableArray alloc] initWithObjects:@"M",@"T",@"W",@"T",@"F",@"S",@"S", nil];
    for (int i = 0; i < 7; i++) {
        if ([[[[Singleton sharedSingleton] sharedPrefs] objectForKey:[NSString stringWithFormat:@"editAlarmRepeatArray%i", i]] intValue] == 1) {
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


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
        
    //[self performSelector:@selector(afterDidLoad) withObject:self afterDelay:0.0005];
    NSLog(@"Redigerar alarm från indexPath: %i", alarmID);
    
    //Defaultvärden för fälten
    nameField.text = [[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:alarmID] name];
    
    for (int i = 0; i < 7; i++) {
        [[[Singleton sharedSingleton] sharedPrefs] setValue:[[[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:alarmID] repeat] objectAtIndex:i] forKey:[NSString stringWithFormat:@"editAlarmRepeatArray%i", i]];
    }
    
    [[[Singleton sharedSingleton] sharedPrefs] setValue:[[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:alarmID] fireDate]  forKey:@"editAlarmTime"];
    
    if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"CurrentSwitchState%i",alarmID]] == 1) {
        [alarmSwitch setOn:YES];
    }
    [self setTimeLabel];
    [self setRepeatLabel];
    [nameField resignFirstResponder];
    
    
}

-(void)afterDidLoad {
    
    
    
}


- (void)viewDidUnload
{
    [self setRepeatSideLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear {
}

-(void)viewWillAppear:(BOOL)animated {
    
    int y = alarmID;
    NSLog(@"Selected row: %i",y);
    
    [self setTimeLabel];
    [self setRepeatLabel];
    
    NSLog(@"ViewWillAppear");
    
}
@end
