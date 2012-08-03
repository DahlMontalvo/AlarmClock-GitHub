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
#import "Singleton.h"
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
@property (nonatomic ,retain)IBOutlet UIImageView *background;


- (IBAction)settingsButton:(id)sender;
-(void)showClock;

@end

