//
//  minTableViewController.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAlarmViewController.h"
#import "EditAlarmViewController.h"
#import "AlarmCell.h"
#import "SettingCell.h"
#import "SettingCell2.h"
#import "EditAlarmViewController.h"

@class minTableViewController;

@protocol minTableViewControllerDelegate <NSObject>
- (void)minTableViewControllerDidDone:(minTableViewController *)controller;
- (void)minTableViewControllerDidDone:(minTableViewController *)controller2;

@end

@interface minTableViewController : UITableViewController <AddAlarmViewControllerDelegate, EditAlarmViewControllerDelegate> {
    
   
    int counter;
    UILocalNotification *localNotif;
 
   
}

@property (nonatomic, weak) id <minTableViewControllerDelegate> delegate;
@property (nonatomic, weak) id <minTableViewControllerDelegate> delegate2;
@property (nonatomic, retain) NSMutableArray *alarms;
@property (nonatomic) int selectedIndex;



- (IBAction)done:(id)sender;



@end
