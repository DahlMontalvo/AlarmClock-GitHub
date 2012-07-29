//
//  MasterViewController.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "minTableViewController.h"
#import "AddAlarmViewController.h"
@class MasterViewController;

@interface MasterViewController : UIViewController <minTableViewControllerDelegate> {
    
    NSDateFormatter *dateFormat;
    IBOutlet UILabel *timeDisplay;
    IBOutlet UILabel *ampmDisplay;
    IBOutlet UILabel *secondsDisplay;
    IBOutlet UILabel *dayDisplay;
    IBOutlet UILabel *dateDisplay;
    
    NSTimer *timer;
}




@property(retain,nonatomic)UILabel *timeDisplay;
@property(retain,nonatomic)UILabel *ampmDisplay;
@property(retain,nonatomic)UILabel *secondsDisplay;
@property(retain,nonatomic)UILabel *dayDisplay;
@property(retain,nonatomic)UILabel *dateDisplay;


- (IBAction)settingsButton:(id)sender;
-(void)showClock;

@end

