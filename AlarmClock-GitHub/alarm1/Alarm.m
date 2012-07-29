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
    if (alarmState == 1) {
        //Dagens veckodag är weekday 0-6
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents =
        [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
        NSInteger weekday = [weekdayComponents weekday]-1;
        
        //Nästa alarm ska ringa vilken veckodag?
        int nextday = -1;
        
        //Vilken tid ska alarmet ringa?
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm:ss"];
        
        NSString *theTime = [timeFormat stringFromDate:fireDate];
        NSString *theTimeNow = [timeFormat stringFromDate:[[NSDate alloc] init]];
        
        NSDate *theTimeAsNSDate = [timeFormat dateFromString:theTime];
        NSDate *theTimeNowAsNSDate = [timeFormat dateFromString:theTimeNow];
        
        for (int i = weekday-1; i >= 0; i--) {
            if ([[repeat objectAtIndex:i] integerValue] == 1) {
                nextday = i;
            }
        }
        for (int i = 6; i > weekday; i--) {
            if ([[repeat objectAtIndex:i] integerValue] == 1) {
                nextday = i;
            }
        }
        
        int inAWeek = 0;
        //Kan det vara senare samma dag?
        if ([theTimeAsNSDate timeIntervalSince1970] > [theTimeNowAsNSDate timeIntervalSince1970] && [[repeat objectAtIndex:weekday] integerValue] == 1) {
            //Senare idag, och då ska den verkligen ringa!
            nextday = weekday;    
        }
        else if ([theTimeAsNSDate timeIntervalSince1970] > [theTimeNowAsNSDate timeIntervalSince1970]) {
            //Senare idag, men står inte i upprepningslistan
        }
        else if ([[repeat objectAtIndex:weekday] integerValue] == 1) {
            //Tidigare idag, men den ska ringa om en vecka endast om nextday inte är ändrad
            if (nextday == -1) {
                nextday = weekday; 
                inAWeek = 1;
            }   
        }
        else {    
            //Tidigare idag men ska inte upprepas
            inAWeek = 1;
        }
        
        int norepeat = 0;
        if (nextday == -1) {
            if ([fireDate timeIntervalSince1970] > [theTimeNowAsNSDate timeIntervalSince1970]) {
                //Firedatet är efter. Måste ha ett alarm
                norepeat = 1;
            }
            else {
                //Stäng av alarmet
                alarmState = 0;
            }
        }
        
        //****************************
        //Test
        //****************************
        NSLog(@"Kommer hit");
        for (int i = 0; i<7; i++) {
            NSLog(@"%i",i);
            if ([[repeat objectAtIndex:i] integerValue] == 1) {
            NSDateComponents *nowComponents = [gregorian components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:today];
            
            [nowComponents setWeekday:i+1];
             [nowComponents setHour:8]; //8a.m.
             [nowComponents setMinute:0];
             [nowComponents setSecond:0];
             
             NSDate *weeklyDay = [gregorian dateFromComponents:nowComponents];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"EEE"];
                
                
                NSString *stringFromDate = [formatter stringFromDate:weeklyDay];
                
                NSLog(@"%i%i%i%i",[nowComponents weekday],[nowComponents hour],[nowComponents minute],[nowComponents second]);
                NSLog(@"%@",stringFromDate);
                
                
                if (alarmState == 1 && norepeat == 1) {
                    localNotif = [[UILocalNotification alloc] init];
                    localNotif.fireDate = weeklyDay;
                    NSLog(@"Firedate blev: %@", fireDate);
                    localNotif.timeZone = [NSTimeZone defaultTimeZone];
                    localNotif.alertBody = [NSString stringWithFormat:@"Alla alarm borde få samma text nu..."];
                    localNotif.alertAction = @"Matteknapp";
                    localNotif.soundName = UILocalNotificationDefaultSoundName;
                    localNotif.applicationIconBadgeNumber = 1;
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:name forKey:@"AlarmName"];
                    NSLog(@"Alarmname blev %@", name);
                    localNotif.userInfo = infoDict;
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
                }
             }
            
        }
        
        //****************************
        //Test
        //****************************
        
    /*    
        if (alarmState == 1 && norepeat == 1) {
            localNotif = [[UILocalNotification alloc] init];
            localNotif.fireDate = fireDate;
            NSLog(@"Firedate blev: %@", fireDate);
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.alertBody = [NSString stringWithFormat:@"Alla alarm borde få samma text nu..."];
            localNotif.alertAction = @"Matteknapp";
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            localNotif.applicationIconBadgeNumber = 1;
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:name forKey:@"AlarmName"];
            NSLog(@"Alarmname blev %@", name);
            localNotif.userInfo = infoDict;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        else {
            localNotif = [[UILocalNotification alloc] init];
            
            //Firedaten ska ju vara samma tid. Men nästa datum blir ju nästa gång veckodagen infaller
            
            NSDateComponents *comp = [[NSDateComponents alloc] init];
            int addDays = nextday-weekday;
            if (addDays < 0) {
                addDays = addDays + 7;
            }
            [comp setDay:addDays];   // Lägger till antalet dagar            
            
            NSLog(@"Nästa alarm: %@", [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:[NSDate date] options:0]);
            
             
             HÄR ÄR DET INTE KLART PÅ LÅNGA VÄGAR
             
            
            
            localNotif.fireDate = fireDate;
            NSLog(@"Firedate blev: %@", fireDate);
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.alertBody = [NSString stringWithFormat:@"Alla alarm borde få samma text nu..."];
            localNotif.alertAction = @"Matteknapp";
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            localNotif.applicationIconBadgeNumber = 1;
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:name forKey:@"AlarmName"];
            NSLog(@"Alarmname blev %@", name);
            localNotif.userInfo = infoDict;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
    */
    
        NSLog(@"Nästa dag alarmet ska ringa är en %i-dag om %i veckor", nextday, inAWeek);
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
 
 
 
