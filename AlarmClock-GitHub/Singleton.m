//
//  Singleton.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"

static Singleton *shared = NULL;

@implementation Singleton
@synthesize sharedPrefs;
@synthesize sharedCounter;
@synthesize sharedNameArray;
@synthesize sharedAlarmsArray;
@synthesize sharedSettings;

@synthesize sharedFireDates;
@synthesize lastFireDate;

/*

 Dessa inställningar finns lagrade i [[Singleton sharedSingleton] sharedPrefs]
 Fyll på listan vid nya inställningar
 
 Key                        Possible values     Function
 
 24HourClockSetting         int 0 or 1          If user uses 12 or 24 hour days
 MathLevelSetting           int 1-5             The math level for alarms
 ClearBackgroundSetting     int 0 or 1          Clear home screen details
 
*/
 
- (id)init
{
    if ( self = [super init] )
    {
        
        self.sharedNameArray = [[NSMutableArray alloc] init];
        self.sharedPrefs = [[NSUserDefaults alloc] init];
        self.sharedSettings = [[NSUserDefaults alloc] init];
        self.sharedAlarmsArray = [[NSMutableArray alloc] initWithCapacity:10];
        self.sharedFireDates = [[NSMutableArray alloc] init];
        // NSLog(@"SINGLETON_Number of objects in alarms after ViewDidLoad in AddAlarm: %i",[[[Singleton sharedSingleton] sharedAlarmsArray]count]);
       
        
    }
    return self;
    
}

+ (Singleton *)sharedSingleton
{
   
    {
        if ( !shared || shared == NULL )
        {
            
            // allocate the shared instance, because it hasn't been done yet
            shared = [[Singleton alloc] init];
        }
        
        return shared;
    }
}


@end
