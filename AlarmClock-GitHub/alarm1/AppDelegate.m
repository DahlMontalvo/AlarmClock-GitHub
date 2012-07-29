//
//  AppDelegate.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Alarm.h"
#import "minTableViewController.h"
#import "DoMathViewController.h"
#import <AVFoundation/AVAudioplayer.h>
@implementation AppDelegate {
    
  //  NSMutableArray* alarms;
    
}

@synthesize window = _window;
@synthesize mySound;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];  
    if (localNotif) {       
        NSLog(@"Kom hit, blev pushad av notifen");
    }


    
    /*
    
    alarms = [NSMutableArray arrayWithCapacity:10];
    
    //alarms = [[NSMutableArray alloc]init];
        
    Alarm *alarm = [[Alarm alloc] init];
	alarm.name = @"Hej Alarmet";
	[alarms addObject:alarm];
    
    alarm = [[Alarm alloc] init];
	alarm.name = @"Hej Alarmtvå";
	[alarms addObject:alarm];
     
  
    
    
    
   
    UINavigationController *navigationController = [[navigationController viewControllers] objectAtIndex:1];
    minTableViewController *minnTableViewController = [[navigationController viewControllers] objectAtIndex:0];
	minnTableViewController.alarms = alarms;
    
      
     
     */
    
    NSLog(@"Did get to loading");
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)localNotif {
    
    NSLog(@"Fick notif jao: %@", localNotif); 
    
    //Ringer om användaren är i appen, musik etc borde nog kallas här i UIAlertViewn
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Här ringer det" message:[NSString stringWithFormat:@"Ring"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    //Startar att spela ett ljud då en notif går av, borde dock kollas om den kom från en notif eller om pers. var i appen
    
    /*NSString *path = [[NSBundle mainBundle]
                    pathForResource:@"chimes" ofType:@"wav"];
   mySound = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
   [mySound play];
     
     */
    
    //Cancela alla alarm för det alarm som ringde
    //Loopa igenom det alarm som ringde
    //Kolla att alla inte är 0
    //Om alla är 0 sätt allt på off
    //Om det finns en 1a, kolla vilken/vilka dag/ar det är och sätt upp alarm på alla.
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
	if([title isEqualToString:[NSString stringWithFormat:@"OK"]])
	{
            //Stoppar ljudet när användaren trycker på OK
      //  [mySound stop];
        NSLog(@"Stop Sound called.");
        
    }

}

@end
