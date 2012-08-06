//
//  SettingsViewController.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-08-06.
//
//

#import <UIKit/UIKit.h>
@class SettingsViewController;
@protocol SettingsViewControllerDelegate <NSObject>
- (void)settingsViewControllerDidCancel:(SettingsViewController *)controller;
- (void)settingsViewControllerDidSave:(SettingsViewController *)controller;

@end

@interface SettingsViewController : UIViewController {
    
}


@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;





@end
