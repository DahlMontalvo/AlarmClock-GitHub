//
//  SettingCell2.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-08-02.
//
//

#import "SettingCell2.h"

@implementation SettingCell2
@synthesize textLabel;
@synthesize settingSwitch;

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

-(IBAction)switchFlicked:(id)sender {
    
    if ([textLabel.text isEqualToString:@"24 Hour Clock"]) {
        if (settingSwitch.on) {
            [[[Singleton sharedSingleton] sharedSettings] setInteger:1 forKey:@"24HourClockSetting"];
        } else {
            [[[Singleton sharedSingleton] sharedSettings] setInteger:0 forKey:@"24HourClockSetting"];

        }
    } else if ([textLabel.text isEqualToString:@"Clear Background"]) {
        if (settingSwitch.on) {
             [[[Singleton sharedSingleton] sharedSettings] setInteger:1 forKey:@"ClearBackgroundSetting"];
        } else {
             [[[Singleton sharedSingleton] sharedSettings] setInteger:0 forKey:@"ClearBackgroundSetting"];
        }
    }
    
}

@end
