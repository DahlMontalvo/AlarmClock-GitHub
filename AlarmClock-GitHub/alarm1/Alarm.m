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
@synthesize alarmText;
@synthesize alarmButtonText;

//Grym tut : http://www.icodeblog.com/2010/07/29/iphone-programming-tutorial-local-notifications/

-(void)registerAlarm {
    
    alarmText = @"Dags att vakna!";
    alarmButtonText = @"Touch me!";
    
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
                
                NSDate *itemDate = [calendar dateFromComponents:dateComps];
                
                NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                dayComponent.day = i-daysSinceLastMonday;
                
                NSCalendar *theCalendar = [NSCalendar currentCalendar];
                itemDate = [theCalendar dateByAddingComponents:dayComponent toDate:itemDate options:0];
                NSLog(@"Schemalade att ringa %@, eftersom i = %i och daysSinceLastMonday = %i", itemDate, i, daysSinceLastMonday);
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
                
                localNotif.soundName = UILocalNotificationDefaultSoundName;
                localNotif.applicationIconBadgeNumber = 1;
                
                // Specify custom data for the notification
                NSDictionary *infoDict = [NSDictionary dictionaryWithObject:name forKey:@"AlarmName"];
                localNotif.userInfo = infoDict;
                
                // Schedule the notification
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            }
        }
        
        if (times == 0) {
            //Då är det en "once"
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
            
            NSDate *itemDate = [calendar dateFromComponents:dateComps];
            
            localNotif = [[UILocalNotification alloc] init];
            
            if (localNotif == nil)
                return;
            
            localNotif.fireDate = itemDate;
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            
            // Notification details
            localNotif.alertBody = alarmText;
            // Set the action button
            localNotif.alertAction = alarmButtonText;
            
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            localNotif.applicationIconBadgeNumber = 1;
            
            // Specify custom data for the notification
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:name forKey:@"AlarmName"];
            localNotif.userInfo = infoDict;
            
            // Schedule the notification
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        
    }
}

-(void)resceduleAlarm {
    [self unRegisterAlarm];
    [self registerAlarm];
}

-(void)unRegisterAlarm {
    //Id att ta bort
    NSString *uIdToDelete = name;
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    //Loopar igenom alla schemalagda notifications
    for (int i=0; i<[eventArray count]; i++) {
        
        UILocalNotification *oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"AlarmName"]];
        NSLog(@"UiToDelete är %@ och uid är %@", uIdToDelete, uid);
        //Om vi hittar det som ska tas bort, ta bort det och hoppa ur loopen
        if ([uid isEqualToString:uIdToDelete]) {
            [app cancelLocalNotification:oneEvent];
            NSLog(@"Borta");
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
 
 
 
