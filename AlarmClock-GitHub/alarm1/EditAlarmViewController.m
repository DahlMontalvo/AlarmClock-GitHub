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
        
        NSMutableArray *repeatArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 7; i++) {
            if ([[[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"editAlarmRepeatArray%i",i]] intValue] == 1) {
                [repeatArray insertObject:[NSNumber numberWithInteger:1] atIndex:i];
            }
            else { 
                [repeatArray insertObject:[NSNumber numberWithInteger:0] atIndex:i];
            }
        }
        alarm.repeat = repeatArray;
        
        //Spara gammalt alarmState innan vi börjar skriva över
        int alarmStateBefore = [[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:q] alarmState];
        
        //Replacear det alarm vi editerar med det nyligen skapade
        [[[Singleton sharedSingleton] sharedAlarmsArray] replaceObjectAtIndex:q withObject:alarm];
        
        //Pointer till vårt alarm
        alarm = [[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:q];
        
        //Uppdaterar namnet i sharedPrefs
        [[[Singleton sharedSingleton] sharedPrefs] setValue:nameField.text forKey:[NSString stringWithFormat:@"name%i",y]];
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
        
        if (alarmSwitch.on && alarmStateBefore == 1) {
            //Användaren har inte ändrat state (utan på till på), utan vi ska bara ändra en tidigare notification

            alarm.alarmState = 1;
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:[NSString stringWithFormat:@"CurrentSwitchState%i",q]];
            [[[Singleton sharedSingleton] sharedPrefs] synchronize];
            
            //Tar bort alarm
            [[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:q] unRegisterAlarm];
            
            //Lägger till alarm
            [[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:q] registerAlarm];
            
        }
        else if (!alarmSwitch.on && alarmStateBefore == 1) {
            //Användaren har ändrat state från på till av, ta endast bort gammal notif
            
            alarm.alarmState = 0;
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:0 forKey:[NSString stringWithFormat:@"CurrentSwitchState%i",q]];
            [[[Singleton sharedSingleton] sharedPrefs] synchronize];
            
            //Tar bort alarm
            [alarm unRegisterAlarm];
            
        }
        else if (alarmSwitch.on && alarmStateBefore == 0) {
            
            //Användaren har satt på alarmet, lägg endast till ett nytt, utan att ta bort
                    
            alarm.alarmState = 1;
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:[NSString stringWithFormat:@"CurrentSwitchState%i",q]];
            [[[Singleton sharedSingleton] sharedPrefs] synchronize];
            
            //Lägger till alarm
            [alarm registerAlarm];
            
        }
        
        //Om användaren inte har ändrat state (utan av till av), så vi behöver inte göra någonting
        
        /*
        
        int beforeAlarmState = alarm.alarmState;
        
        
        
        localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = [[[Singleton sharedSingleton] sharedFireDates] objectAtIndex:[[[Singleton sharedSingleton] sharedFireDates] count]-1];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = [NSString stringWithFormat:@"Wake up!"];
        localNotif.alertAction = @"Shut off";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:nameField.text forKey:@"AlarmName"];
        localNotif.userInfo = infoDict;
        
        //Id att ta bort
        NSString *uIdToDelete = [[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:q] name];
        
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        
        //Loopar igenom alla schemalagda notifications
        for (int i=0; i<[eventArray count]; i++) {
            
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
            
            //Om vi hittar det som ska tas bort, ta bort det och hoppa ur loopen
            if ([uid isEqualToString:uIdToDelete]) {
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        
        
        
        //Ställer in om det ska vara aktiverat eller inte
        if (alarmSwitch.on) {
            alarm.alarmState = 1;
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:[NSString stringWithFormat:@"CurrentSwitchState%i",q]];
            [[[Singleton sharedSingleton] sharedPrefs] synchronize];
            NSLog(@"På");
            
        } else {
            alarm.alarmState = 0;
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:0 forKey:[NSString stringWithFormat:@"CurrentSwitchState%i",q]];
            [[[Singleton sharedSingleton] sharedPrefs] synchronize];
            
            //Det är egentligen bara om alarmet är aktiverat som det ska ringa, annars, ta bort notificationen
            UIApplication *thisapp = [UIApplication sharedApplication];
            NSArray *thiseventArray = [thisapp scheduledLocalNotifications];
            UILocalNotification* thisoneEvent = [thiseventArray objectAtIndex:q];
            [app cancelLocalNotification:thisoneEvent];
            NSLog(@"Av");
             
            
        }
        */
        
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
