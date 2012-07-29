//
//  AddTimeViewController.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTimeViewController : UIViewController {
    
   IBOutlet UIDatePicker *timePicker;
    
}

@property (nonatomic, retain) IBOutlet UIDatePicker *timePicker;


-(IBAction)save:(id)sender;

@end
