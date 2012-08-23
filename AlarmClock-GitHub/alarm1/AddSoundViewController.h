//
//  AddSoundViewController.h
//  alarm1
//
//  Created by Jonas Dahl on 8/23/12.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Singleton.h"

@interface AddSoundViewController : UITableViewController <MPMediaPickerControllerDelegate> 

@property (nonatomic, retain) NSMutableArray *soundArray;

@end
