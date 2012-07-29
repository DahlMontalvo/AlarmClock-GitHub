//
//  AddAlarmViewController.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddAlarmViewController;
@class Alarm;

@protocol AddAlarmViewControllerDelegate <NSObject>
- (void)addAlarmViewControllerDidCancel:(AddAlarmViewController *)controller;
- (void)addAlarmViewController:(AddAlarmViewController *)controller didAddAlarm:(Alarm *)alarm;
@end

@interface AddAlarmViewController : UITableViewController {
    
    UILocalNotification *localNotif;
    
}

@property (nonatomic, weak) id <AddAlarmViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *repeatLabel;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSArray *vanligArray;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UILabel *timeSideLabel;
@property (nonatomic, retain) UILocalNotification *localNotif;
@property (strong, nonatomic) IBOutlet UILabel *repeatSideLabel;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;


@end
