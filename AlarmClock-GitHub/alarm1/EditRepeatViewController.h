//
//  EditRepeatViewController.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditRepeatViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *mondayButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *tuesdayButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *wednesdayButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *thursdayButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *fridayButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *saturdayButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *sundayButton;

@end