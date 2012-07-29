//
//  EditAlarmAddTimeViewController.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAlarmAddTimeViewController : UIViewController {
    
    IBOutlet UIDatePicker *timePicker;
    
}

@property (nonatomic, retain) IBOutlet UIDatePicker *timePicker;


-(IBAction)save:(id)sender;

@end
