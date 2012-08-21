//
//  SettingCell2.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-08-02.
//
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface SettingCellSwitch : UITableViewCell {
    
    NSString *singletonName;
    
}

@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UISwitch *settingSwitch;
@property (nonatomic, retain) NSString *singletonName;

-(IBAction)switchFlicked:(id)sender;



@end
