//
//  AlarmCell.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UISwitch *alarmSwitch;
@property (nonatomic, retain) IBOutlet UILabel *onOffLabel;

@end
