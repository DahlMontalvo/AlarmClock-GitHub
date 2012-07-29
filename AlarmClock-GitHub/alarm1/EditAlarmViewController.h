//
//  EditAlarmViewController.h
//  alarm1
//
//  Created by Lion User on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditAlarmViewController;
@class Alarm;

@protocol EditAlarmViewControllerDelegate <NSObject>
- (void)editAlarmViewControllerDidCancel:(EditAlarmViewController *)controller2;
- (void)editAlarmViewController:(EditAlarmViewController *)controller2 didEditAlarm:(Alarm *)alarm;
@end

@interface EditAlarmViewController : UITableViewController {
    
    NSTimer *sekundIntervall1;
    UILocalNotification *localNotif;
    
}

@property (nonatomic, weak) id <EditAlarmViewControllerDelegate> delegate2;

@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UILabel *timeSideLabel;
@property (nonatomic, retain) IBOutlet UISwitch *alarmSwitch;
@property (nonatomic, retain) UILocalNotification *localNotif;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)switchFlicked:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;


@end
