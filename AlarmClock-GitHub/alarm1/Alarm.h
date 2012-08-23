//
//  Alarm.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Alarm : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSDate *fireDate;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, assign) NSInteger alarmState;
@property (nonatomic, assign) NSInteger snoozeInterval;
@property (nonatomic, assign) NSInteger snoozeNumberOfTimes;
@property (nonatomic, retain) UILocalNotification *localNotif;
@property (nonatomic, assign) NSInteger mathLevel;
@property (nonatomic, retain) NSMutableArray *repeat;
@property (nonatomic, retain) NSString *alarmText;
@property (nonatomic, retain) NSString *alarmButtonText;
@property (nonatomic, retain) MPMediaItem *sound;

-(void) registerAlarm;
-(void) resceduleAlarm;
-(void) unRegisterAlarm;
-(void) noMoreSnooze;

@end
