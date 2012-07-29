//
//  Alarm.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSDate *fireDate;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, assign) NSInteger alarmState;
@property (nonatomic, retain) UILocalNotification *localNotif;
@property (nonatomic, assign) NSInteger mathLevel;
@property (nonatomic, retain) NSMutableArray *repeat;

-(void) registerAlarm;
-(void) unRegisterAlarm;

@end
