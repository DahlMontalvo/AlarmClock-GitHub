//
//  Singleton.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject {
    
    NSUInteger sharedCounter;
    NSUserDefaults *sharedPrefs;
    NSMutableArray *sharedNameArray;
    NSMutableArray *sharedAlarmsArray;
    NSMutableArray *sharedFireDates;
    NSString *lastFireDate;
    
}

@property (nonatomic, retain) NSUserDefaults *sharedPrefs;
@property(nonatomic, assign) NSUInteger sharedCounter;
@property (nonatomic, retain) NSMutableArray *sharedNameArray;
@property (nonatomic, retain) NSMutableArray *sharedAlarmsArray;
@property (nonatomic, retain) NSMutableArray *sharedFireDates;
@property (nonatomic, retain) NSString *lastFireDate;




+ (Singleton *)sharedSingleton;
    

@end
