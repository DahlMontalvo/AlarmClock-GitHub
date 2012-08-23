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
@synthesize snoozeInterval;
@synthesize snoozeNumberOfTimes;
@synthesize localNotif;
@synthesize mathLevel;
@synthesize repeat;
@synthesize alarmText;
@synthesize alarmButtonText;
@synthesize soundType;
@synthesize soundInfo;
@synthesize soundItem;

//Bra tut : http://www.icodeblog.com/2010/07/29/iphone-programming-tutorial-local-notifications/

-(void)registerAlarm {
    
    alarmText = @"Ring";
    alarmButtonText = @"Do math!";
    
    if (alarmState == 1) {
        
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        
        // Get the current date
        NSDate *pickerDate = fireDate;
        
        // Break the date up into components
        NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
                                                       fromDate:pickerDate];
        NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
                                                       fromDate:pickerDate];

        // Set up the fire time
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        [dateComps setDay:[dateComponents day]];
        [dateComps setMonth:[dateComponents month]];
        [dateComps setYear:[dateComponents year]];
        [dateComps setHour:[timeComponents hour]];
        // Notification will fire in one minute
        [dateComps setMinute:[timeComponents minute]];
        [dateComps setSecond:0];
        
        //Är det tisdag idag, ska daysSinceLastMonday vara 1
        int daysSinceLastMonday = 0;
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        
        int weekday = [weekdayComponents weekday]-1;
        if (weekday == 0) {
            //För att komma undan att söndag är 1 i greg kal
            weekday = 7;
        }
        
        daysSinceLastMonday = weekday-1;
        
        //Loopa igenom repeatarrayen och kolla om vi ska schemalägga eller bara engångsnotif
        int times = 0;
        for (int i = 0; i < 7; i++) {
            if ([[repeat objectAtIndex:i] intValue] == 1) {
                times++;
                //Schemalägg också alla snoozar
                for (int a = 0; a < snoozeNumberOfTimes+1; a++) {
                    NSDate *itemDate = [calendar dateFromComponents:dateComps];
                    
                    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                    dayComponent.day = i-daysSinceLastMonday;
                    
                    NSDateComponents *snoozeIntervalComponent = [[NSDateComponents alloc] init];
                    snoozeIntervalComponent.minute = snoozeInterval*a;
                    
                    NSCalendar *theCalendar = [NSCalendar currentCalendar];
                    itemDate = [theCalendar dateByAddingComponents:dayComponent toDate:itemDate options:0];
                    itemDate = [theCalendar dateByAddingComponents:snoozeIntervalComponent toDate:itemDate options:0];
                    localNotif = [[UILocalNotification alloc] init];
                    
                    if (localNotif == nil)
                        return;
                    
                    localNotif.repeatInterval = NSWeekCalendarUnit;
                    localNotif.fireDate = itemDate;
                    localNotif.timeZone = [NSTimeZone defaultTimeZone];
                    
                    // Notification details
                    localNotif.alertBody = alarmText;
                    // Set the action button
                    localNotif.alertAction = alarmButtonText;
                    
                    localNotif.soundName = @"Jungle.wav";
                    localNotif.applicationIconBadgeNumber = 1;
                    
                    // Specify custom data for the notification
                    /*NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@snooze%iday%i", name, a, i] forKey:@"AlarmName"];*/
                    
                    NSArray *objs = [[NSArray alloc] initWithObjects:name, [NSNumber numberWithInt:a], [NSNumber numberWithInt:i], nil];
                    NSArray *keys = [[NSArray alloc] initWithObjects:@"Name", @"SnoozeTimes", @"Day", nil];
                    
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
                    localNotif.userInfo = infoDict;
                    
                    // Schedule the notification
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
                }
                
            }
        }
        
        if (times == 0) {
            //Då är det en "once"
            NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
            
            
            //Schemalägg också alla snoozar
            for (int i = 0; i < snoozeNumberOfTimes+1; i++) {
                // Get the current date
                NSDate *pickerDate = fireDate;
                
                // Break the date up into components
                NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
                                                               fromDate:pickerDate];
                NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
                                                               fromDate:pickerDate];
                // Set up the fire time
                NSDateComponents *dateComps = [[NSDateComponents alloc] init];
                [dateComps setDay:[dateComponents day]];
                [dateComps setMonth:[dateComponents month]];
                [dateComps setYear:[dateComponents year]];
                [dateComps setHour:[timeComponents hour]];
                // Notification will fire in one minute
                [dateComps setMinute:[timeComponents minute]];
                [dateComps setSecond:0];
                
                NSDate *itemDate = [calendar dateFromComponents:dateComps];

                
                NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                dayComponent.day = 0;
                if ([fireDate timeIntervalSinceNow] < 0) {
                    dayComponent.day = 1;
                }
                
                NSDateComponents *snoozeIntervalComponent = [[NSDateComponents alloc] init];
                snoozeIntervalComponent.minute = snoozeInterval*i;
                
                NSCalendar *theCalendar = [NSCalendar currentCalendar];
                itemDate = [theCalendar dateByAddingComponents:dayComponent toDate:itemDate options:0];
                itemDate = [theCalendar dateByAddingComponents:snoozeIntervalComponent toDate:itemDate options:0];
                localNotif = [[UILocalNotification alloc] init];
                
                if (localNotif == nil)
                    return;
                
                
                localNotif.fireDate = itemDate;
                localNotif.timeZone = [NSTimeZone defaultTimeZone];
                
                // Notification details
                localNotif.alertBody = alarmText;
                // Set the action button
                localNotif.alertAction = alarmButtonText;
                
                localNotif.soundName = @"Jungle.wav";
                localNotif.applicationIconBadgeNumber = 1;

                
                // Specify custom data for the notification
                /*NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@snooze%iday0", name, i] forKey:@"AlarmName"];
                 */
                
                NSArray *objs = [[NSArray alloc] initWithObjects:name, [NSNumber numberWithInt:i], [NSNumber numberWithInt:0], nil];
                NSArray *keys = [[NSArray alloc] initWithObjects:@"Name", @"SnoozeTimes", @"Day", nil];
                
                NSDictionary *infoDict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
                localNotif.userInfo = infoDict;
                
                // Schedule the notification
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            }
        }
        
    }
}

-(void)resceduleAlarm {
    [self unRegisterAlarm];
    [self registerAlarm];
}

-(void)unRegisterAlarm {
    for (int day = 0; day < 7; day++) {
        for (int i = 0; i < snoozeNumberOfTimes+1; i++) {
            //Id att ta bort
            NSString *uIdToDelete = name;
            int snoozeTimesToDelete = i;
            
            UIApplication *app = [UIApplication sharedApplication];
            NSArray *eventArray = [app scheduledLocalNotifications];
            
            //Loopar igenom alla schemalagda notifications
            for (int i=0; i<[eventArray count]; i++) {
                
                UILocalNotification *oneEvent = [eventArray objectAtIndex:i];
                NSDictionary *userInfoCurrent = oneEvent.userInfo;
                NSString *uid = [userInfoCurrent valueForKey:@"Name"];
                int snoozeTimes = [[userInfoCurrent valueForKey:@"SnoozeTimes"] intValue];
                //Om vi hittar det som ska tas bort, ta bort det och hoppa ur loopen
                if ([uid isEqualToString:uIdToDelete] && snoozeTimes == snoozeTimesToDelete) {
                    [app cancelLocalNotification:oneEvent];
                    break;
                }
                
            }
        }
    }
    
}

-(void)noMoreSnooze {
    int times = 0;
    for (int day = 0; day < 7; day++) {
        if ([[repeat objectAtIndex:day] intValue] == 1) {
            times++;
        }
    }
    if (times == 0) {
        for (int i = 0; i < snoozeNumberOfTimes+1; i++) {
            //Id att ta bort
            NSString *uIdToDelete = name;
            int snoozeTimesToDelete = i;
            int dayToDelete = 0;
            
            UIApplication *app = [UIApplication sharedApplication];
            NSArray *eventArray = [app scheduledLocalNotifications];
            
            //Loopar igenom alla schemalagda notifications
            for (int i=0; i<[eventArray count]; i++) {
                
                UILocalNotification *oneEvent = [eventArray objectAtIndex:i];
                NSDictionary *userInfoCurrent = oneEvent.userInfo;
                NSString *uid = [userInfoCurrent valueForKey:@"Name"];
                int snoozeTimes = [[userInfoCurrent valueForKey:@"SnoozeTimes"] intValue];
                int daya = [[userInfoCurrent valueForKey:@"Day"] intValue];
                //Om vi hittar det som ska tas bort, ta bort det och hoppa ur loopen
                if ([uid isEqualToString:uIdToDelete] && daya == dayToDelete && snoozeTimes == snoozeTimesToDelete) {
                    [app cancelLocalNotification:oneEvent];
                    break;
                }
                
            }
        }

    }
    else {
        for (int i = 0; i < snoozeNumberOfTimes+1; i++) {
            
            //Vi kan ju inte ta bort dessa snoozar som med once-alarm, eftersom det inte blir nån snooze nästa vecka då...
            [self unRegisterAlarm];
            
            //Rescedula från och med nästa dag
            NSCalendar *calendar = [NSCalendar currentCalendar];
            
            NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:fireDate];
            NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:fireDate];
            
            NSDateComponents *components = [calendar components:0 fromDate:[NSDate date]];
            int year = [components year];
            int month = [components month];
            int day = [components day];
            
            [dateComponents setYear:year];
            [dateComponents setMonth:month];
            [dateComponents setDay:day];
            [dateComponents setHour:[timeComponents hour]];
            [dateComponents setMinute:[timeComponents minute]];
            [dateComponents setSecond:[timeComponents second]];
            fireDate = [calendar dateFromComponents:dateComponents];
            
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = 1;
            fireDate = [calendar dateByAddingComponents:dayComponent toDate:fireDate options:0];
            
            [self registerAlarm];
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
 
 
 
