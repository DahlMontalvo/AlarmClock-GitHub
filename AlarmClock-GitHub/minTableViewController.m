//
//  minTableViewController.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "AlarmCell.h"
#import "Alarm.h"
#import "minTableViewController.h"
#import "AddAlarmViewController.h"
#import "EditAlarmViewController.h"
#import "Singleton.h"
#import "SettingsViewController.h"




@implementation minTableViewController
@synthesize alarms;
@synthesize delegate;
@synthesize delegate2;
@synthesize selectedIndex;
@synthesize settings;
@synthesize activeSetting;


- (IBAction)done:(id)sender
{
    
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
	[self.delegate minTableViewControllerDidDone:self];
        
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddAlarm"] || [segue.identifier isEqualToString:@"AddAlarmRow"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		AddAlarmViewController *addAlarmViewController = [[navigationController viewControllers] objectAtIndex:0];
		addAlarmViewController.delegate = self;
        
	} 
    else if ([segue.identifier isEqualToString:@"EditAlarm"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
		EditAlarmViewController *editAlarmViewController = [[navigationController viewControllers] objectAtIndex:0];
		editAlarmViewController.delegate2 = self;
        editAlarmViewController.alarmID = selectedIndex;
    }
    else if ([segue.identifier isEqualToString:@"SettingSegue"]) {
        SettingsViewController *navigationController = segue.destinationViewController;
        navigationController.setting = activeSetting;
    }
}


- (void)addAlarmViewControllerDidCancel:(AddAlarmViewController *)controller
{
    
	[self dismissViewControllerAnimated:YES completion:nil];

}



- (void)editAlarmViewControllerDidCancel:(EditAlarmViewController *)controller2
{
    //Canslar
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)settingsViewControllerDidCancel:(SettingsViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)settingsViewControllerDidSave:(SettingsViewController *)controller{
    //Do stuff here (maybe)
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    //Loopar igenom alla schemalagda notifications
    for (int i=0; i<[eventArray count]; i++) {
        
        UILocalNotification *oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"AlarmName"]];
        //Om vi hittar det som ska tas bort, ta bort det och hoppa ur loopen
        NSLog(@"Uid: %@, %@", uid, oneEvent.fireDate);
    }
   
    //Antalet singletonvariabler
    counter = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    
    //Läser in alla sharedprefs i en sharedAlarmsArray
    if ([[[Singleton sharedSingleton] sharedAlarmsArray] count] < counter) {
    
        for (int i = 0; i < counter ; i++) {
        
            [self.tableView reloadData];
        
            Alarm *alarm = [[Alarm alloc] init];
            alarm.name = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"name%i",i]];
            alarm.fireDate = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"time%i",i]];
            alarm.snoozeInterval = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"snoozeInterval%i",i]];
            alarm.snoozeNumberOfTimes = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"snoozeNumberOfTimes%i",i]];
            alarm.sound = [[[Singleton sharedSingleton] sharedPrefs] objectForKey:[NSString stringWithFormat:@"soundItem%i",i]];
            alarm.alarmState = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"CurrentSwitchState%i",i]];
            alarm.repeat = [[[Singleton sharedSingleton] sharedPrefs] objectForKey:[NSString stringWithFormat:@"repeat%i",i]];
        
            [[[Singleton sharedSingleton] sharedAlarmsArray] addObject:alarm];
            
            
            
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [self.tableView reloadData];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{   
    
    int y = [[Singleton sharedSingleton] sharedCounter];
    
    [[[Singleton sharedSingleton] sharedPrefs] setInteger:y forKey:@"Counter"];
    [[[Singleton sharedSingleton] sharedPrefs] setValue:[[Singleton sharedSingleton]sharedAlarmsArray] forKey:@"AlarmArraySave"];
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    
    
    
    [super viewDidUnload];

}

- (void)viewWillAppear:(BOOL)animated
{
       // [self.tableView reloadData];
    
    //Matris med första objektet som dess namn, andra dess typ, tredje dess namn i sharedPrefs [och fjärde dess möjliga värden]
    //Typer: 0 = switch, 1 = detail
    //För att lägg till setting, lägg bara till en ny rad ([settings addObject...]) nedan med information i format som anges ovan. Anteckna gärna nedan vad settingen gör, så att man enkelt kan hålla reda på alla...
    
    /*
     
     Dessa inställningar finns lagrade i [[Singleton sharedSingleton] sharedPrefs]
     Fyll på listan vid nya inställningar
     
     Nyckel                     Möjliga värden      Typ
     
     24HourClockSetting         On/Off              Switch
     MathLevelSetting           int 1-5             Detail
     ActiveDesignSetting        String              Detail
     MathTypeSetting            String              Detail
     ShowSecondsSetting         On/Off              Switch
     ShowAMPMSetting            On/Off              Switch
     
     */
    
    settings = [[NSMutableArray alloc] init];
    
    [settings addObject:[[NSMutableArray alloc] initWithObjects:@"24 Hour Clock", [NSNumber numberWithInt:0], @"24HourClockSetting", nil]];
    [settings addObject:[[NSMutableArray alloc] initWithObjects:@"Theme", [NSNumber numberWithInt:1], @"ActiveDesignSetting", [[NSMutableArray alloc] initWithObjects:@"Back To School", @"Back To School Clean", @"White Math", nil], nil]];
    [settings addObject:[[NSMutableArray alloc] initWithObjects:@"Math Level", [NSNumber numberWithInt:1], @"MathLevelSetting", [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil], nil]];
     [settings addObject:[[NSMutableArray alloc] initWithObjects:@"Math Type", [NSNumber numberWithInt:1], @"MathTypeSetting", [[NSMutableArray alloc] initWithObjects:@"Addition", @"Subtraction", @"Multiplication", @"Division", @"Equation", @"Fraction",  nil], nil]];
    [settings addObject:[[NSMutableArray alloc] initWithObjects:@"Show Seconds", [NSNumber numberWithInt:0], @"ShowSecondsSetting", nil]];
    [settings addObject:[[NSMutableArray alloc] initWithObjects:@"Show AM/PM", [NSNumber numberWithInt:0], @"ShowAMPMSetting", nil]];
    
    counter = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    
    //Läser in alla sharedprefs i en sharedAlarmsArray
       [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{   

    [self.tableView reloadData];
    
        
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"Alarms";
    } else {
        return @"Settings";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if ([[[Singleton sharedSingleton] sharedAlarmsArray]count] < 1) {
            return 1;
        } else {
            return ([[[Singleton sharedSingleton] sharedAlarmsArray]count]+1);
        }
        
    }
    else {
        return [settings count];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     int num = [[[[Singleton sharedSingleton] sharedPrefs] valueForKey:@"Counter"] intValue];
    
    if (indexPath.section == 0 && indexPath.row < num) {
        return 53;
    } else {
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    alarms = [[Singleton sharedSingleton] sharedAlarmsArray];
    
    int num = [[[[Singleton sharedSingleton] sharedPrefs] valueForKey:@"Counter"] intValue];
    
    if (indexPath.section == 0) {
        if (indexPath.row >= num) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
            cell.textLabel.text = @"Add Alarm...";
            return cell;
        }
        else {
            
            AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];
        
            
            Alarm *alarm = [[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:indexPath.row];
            cell.nameLabel.text = alarm.name;
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"24HourClockSetting"] == 0) {
                [outputFormatter setDateFormat:@"h:mm a"];
            }
            else {
                [outputFormatter setDateFormat:@"HH:mm"];
            }
            NSString *dateString = [outputFormatter stringFromDate:alarm.fireDate];
            
            cell.timeLabel.text = dateString;
            
            //kollar om staten är on eller off, och skriver ut det
            if ([[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:indexPath.row] alarmState] == 1) {
                cell.onOffLabel.text = @"On";
            } else {
                cell.onOffLabel.text = @"Off";
            }
            
            return cell;        

        }
        
    }
    else {
        NSMutableArray *setting = [settings objectAtIndex:indexPath.row];
        
        if ([[setting objectAtIndex:1] intValue] == 0) {
            SettingCellSwitch *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellSwitch"];
            cell.singletonName = [setting objectAtIndex:2];
            cell.textLabel.text = [setting objectAtIndex:0];
            if ([[[[Singleton sharedSingleton] sharedPrefs] objectForKey:cell.singletonName] intValue] == 1) {
                [cell.settingSwitch setOn:YES];
            }
            else {
                [cell.settingSwitch setOn:NO];
            }
            return cell;
        }
        else if ([[setting objectAtIndex:1] intValue] == 1) {
            SettingCellDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellDetail"];
            cell.settingLabel.text = [setting objectAtIndex:0];
            cell.settingDetailLabel.text = [NSString stringWithFormat:@"%@", [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[setting objectAtIndex:2]]];
            return cell;
        }
        
    }
    
    return nil;
}
        
        

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row < [[[Singleton sharedSingleton] sharedAlarmsArray] count]) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Man ska även bara kunna deleta alarm, ej settings. Därav indexPath.section = 0
	if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.row <= [[[Singleton sharedSingleton] sharedAlarmsArray] count] && indexPath.section == 0)
	{
        int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
        Alarm *oldAlarm = [[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:indexPath.row];
        
        [oldAlarm unRegisterAlarm];
        
        [[[Singleton sharedSingleton] sharedAlarmsArray] removeObjectAtIndex:indexPath.row];
		
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        y = y - 1;
        
                
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:y forKey:@"Counter"];
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
        [tableView reloadData];

	}   
}



- (void)addAlarmViewController:(AddAlarmViewController *)controller didAddAlarm:(Alarm *)alarm
{
	[[[Singleton sharedSingleton] sharedAlarmsArray]addObject:alarm];
    
    
    
    
    //int y = [[Singleton sharedSingleton] sharedPrefs];
    //y = y + 1;
    //[[[Singleton sharedSingleton] sharedPrefs] setInteger:y forKey:@"Counter"];
    //[[[Singleton sharedSingleton] sharedPrefs] synchronize];
    
    
    
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[[[Singleton sharedSingleton] sharedAlarmsArray] count] - 1 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editAlarmViewController:(EditAlarmViewController *)controller didEditAlarm:(Alarm *)alarm
{
    AlarmCell *cell;
    int q = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TheRowISelected"];
    
    if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"CurrentSwitchState%i",q]] == 1) {
      cell.onOffLabel.text = @"On";
    } else {
        
        cell.onOffLabel.text = @"Off";
        
    }
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshDisplay:(UITableView *)tableView {
    [tableView reloadData]; 
}

-(void)switchFlicked{
    
    
}

#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    if (indexPath.section == 1) {
        NSMutableArray *setting = [settings objectAtIndex:indexPath.row];
        if ([[setting objectAtIndex:1] intValue] == 1) {
            activeSetting = setting;
            [self performSegueWithIdentifier:@"SettingSegue" sender:self];
        }
    }
    
    if (indexPath.row == [[[Singleton sharedSingleton] sharedAlarmsArray] count] && indexPath.section == 0) {
        [self performSegueWithIdentifier:@"AddAlarm" sender:self];
    }
    else if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"EditAlarm" sender:self];
    }
}

@end
