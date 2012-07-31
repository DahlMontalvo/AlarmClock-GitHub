//
//  Alarm.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Alarm.h"
#import "Singleton.h"

@implementation Alarm

@synthesize name;
@synthesize identifier;
@synthesize fireDate;
@synthesize alarmState;
@synthesize localNotif;
@synthesize mathLevel;
@synthesize repeat;

-(void)registerAlarm {
    NSLog(@"Registrera alarm");
    if (alarmState == 1) {        
        NSLog(@"Jaha, alarmet är påslaget, bara att köra!");
    }
    else {
        NSLog(@"Tyvärr, alarmet är avstängt.");
    }
}


-(void)unRegisterAlarm {
    NSLog(@"UnRegisterAlarm kallad");
    //Id att ta bort
    NSString *uIdToDelete = name;
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    //Loopar igenom alla schemalagda notifications
    for (int i=0; i<[eventArray count]; i++) {
        
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"AlarmName"]];
        NSLog(@"UiToDelete är %@ och uid är %@", uIdToDelete, uid);
        //Om vi hittar det som ska tas bort, ta bort det och hoppa ur loopen
        if ([uid isEqualToString:uIdToDelete]) {
            [app cancelLocalNotification:oneEvent];
            NSLog(@"Borta med vinden");
            break;
        }
    }

}


@end

/*
 
 localNotif = [[UILocalNotification alloc] init];
 if (localNotif == nil) {
 
 localNotif.fireDate = [[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:];
 localNotif.timeZone = [NSTimeZone defaultTimeZone];
 localNotif.alertBody = [NSString stringWithFormat:@"Yo Niggah"];
 localNotif.alertAction = @"View";
 localNotif.soundName = UILocalNotificationDefaultSoundName;
 localNotif.applicationIconBadgeNumber = 1;
 [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
 
 */
 
 
 
