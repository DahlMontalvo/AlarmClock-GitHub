//
//  SettingCell.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-07-31.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell
@synthesize settingLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
