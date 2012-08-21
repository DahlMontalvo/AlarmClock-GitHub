//
//  SettingCell2.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-08-02.
//
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface SettingCell2 : UITableViewCell {
    
    
}

@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UISwitch *settingSwitch;

-(IBAction)switchFlicked:(id)sender;



@end
