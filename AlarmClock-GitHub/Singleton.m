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



- (id)init
{
    if ( self = [super init] )
    {
        
        self.sharedNameArray = [[NSMutableArray alloc] init];
        self.sharedPrefs = [[NSUserDefaults alloc] init];
        self.sharedSettings = [[NSUserDefaults alloc] init];
        self.sharedAlarmsArray = [[NSMutableArray alloc] initWithCapacity:10];
        self.sharedFireDates = [[NSMutableArray alloc] init];
        NSLog(@"Singletons initierade");
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
