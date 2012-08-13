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
@synthesize settingsArraySwitch;
@synthesize settingsArray;


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
        NSLog(@"2. editAlarmViewController.alarmID: %i", editAlarmViewController.alarmID);
        NSLog(@"2. selectedIndex: %i", selectedIndex);
    } else if ([segue.identifier isEqualToString:@"SettingSegue"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        SettingsViewController *settingsViewController = [[navigationController viewControllers] objectAtIndex:0];
        settingsViewController.delegate = self;
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
   
    //Antalet singletonvariabler
    counter = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    NSLog(@"Counter:%i",counter);
    
    //Läser in alla sharedprefs i en sharedAlarmsArray
    if ([[[Singleton sharedSingleton] sharedAlarmsArray] count] < counter) {
    
        for (int i = 0; i < counter ; i++) {
        
            [self.tableView reloadData];
        
            Alarm *alarm = [[Alarm alloc] init];
            alarm.name = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"name%i",i]];
            alarm.fireDate = [[[Singleton sharedSingleton] sharedPrefs] valueForKey:[NSString stringWithFormat:@"time%i",i]];
            alarm.alarmState = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"CurrentSwitchState%i",i]];
            alarm.repeat = [[[Singleton sharedSingleton] sharedPrefs] objectForKey:[NSString stringWithFormat:@"repeat%i",i]];
        
            [[[Singleton sharedSingleton] sharedAlarmsArray] addObject:alarm];
            
            NSLog(@"Added alarm with name: %@", alarm.name);
            
            
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

    // Return the number of sections.
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
    
    if (section ==1) {
        return [settingsArray count] + [settingsArraySwitch count];
    } else {
        
        return 0;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    alarms = [[Singleton sharedSingleton] sharedAlarmsArray];
    
   
    
    static NSString *CellIdentifier1 = @"AlarmCell";
    static NSString *CellIdentifier2 = @"SettingCell";
    static NSString *CellIdentifier3 = @"SettingCell2";
    
    settingsArray = [NSMutableArray arrayWithCapacity:3];
    [settingsArray addObject:@"Math Settings"];
    
    settingsArraySwitch = [NSMutableArray arrayWithCapacity:1];
    [settingsArraySwitch addObject:@"24 Hour Clock"];
    [settingsArraySwitch addObject:@"Clear Background"];
    
    int num = [[[[Singleton sharedSingleton] sharedPrefs] valueForKey:@"Counter"] intValue];
    int num2 = [settingsArray count];
    
    if (indexPath.section == 0) {
        if (indexPath.row >= num) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
            cell.textLabel.text = @"Add Alarm...";
            return cell;
        }
        else {
            
            AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
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
     
   else if (indexPath.section  == 1 && indexPath.row >= num2) {
        SettingCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        cell.textLabel.text = [settingsArraySwitch objectAtIndex:indexPath.row-[settingsArray count]];
       
       if ([cell.textLabel.text isEqualToString:@"24 Hour Clock"]) {
           if ([[[Singleton sharedSingleton]sharedSettings]integerForKey:@"24HourClockSetting"] == 1) {
               [cell.settingSwitch setOn:YES];
           } else {
               [cell.settingSwitch setOn:NO];
           }
       }
       
       if ([cell.textLabel.text isEqualToString:@"Clear Background"]) {
           if ([[[Singleton sharedSingleton]sharedSettings]integerForKey:@"ClearBackgroundSetting"] == 1) {
               [cell.settingSwitch setOn:YES];
           } else {
               [cell.settingSwitch setOn:NO];
           }
       }

           
        NSLog(@"SettingCell2");
        return cell;
        
    
        
    } else {
        SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.settingLabel.text = [settingsArray objectAtIndex:indexPath.row];
        return cell;
        NSLog(@"SettingCell1");
        
    }

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
        
		        
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:y forKey:@"Counter"];        
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
        
        [oldAlarm unRegisterAlarm];
        
        [[[Singleton sharedSingleton] sharedAlarmsArray] removeObjectAtIndex:indexPath.row];
		
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        y = y - 1;
        
                
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:y forKey:@"Counter"];
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
    if (indexPath.row == [[[Singleton sharedSingleton] sharedAlarmsArray] count] && indexPath.section == 0) {
        [self performSegueWithIdentifier:@"AddAlarm" sender:self];
    }
    else if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"EditAlarm" sender:self];
    } else if (indexPath.section == 1 && indexPath.row < [settingsArray count]) {
        [self performSegueWithIdentifier:@"SettingSegue" sender:self];
    } else {
        //Unclickable
    }
    NSLog(@"1. selectedIndex: %i", selectedIndex);
}

@end
