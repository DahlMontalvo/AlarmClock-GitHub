//
//  AppDelegate.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioplayer.h>
#import "DoMathViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    AVAudioPlayer *mySound;
    
    

    
}

@property (nonatomic, retain) AVAudioPlayer *mySound;
@property (nonatomic, retain) UINavigationController *nvcontrol;
@property (strong, nonatomic) UIWindow *window;

@end
