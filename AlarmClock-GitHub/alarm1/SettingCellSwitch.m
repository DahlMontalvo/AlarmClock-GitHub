//
//  SettingCell2.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-08-02.
//
//

#import "SettingCellSwitch.h"

@implementation SettingCellSwitch
@synthesize textLabel;
@synthesize settingSwitch;
@synthesize singletonName;

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
    
    if (settingSwitch.on) {
        [[[Singleton sharedSingleton] sharedSettings] setInteger:1 forKey:singletonName];
    } else {
        [[[Singleton sharedSingleton] sharedSettings] setInteger:0 forKey:singletonName];
        
    }
    
}

@end
