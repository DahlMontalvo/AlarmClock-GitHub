//
//  EditAlarmAddTimeViewController.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditAlarmAddTimeViewController.h"
#import "Singleton.h"
#import "Alarm.h"

@implementation EditAlarmAddTimeViewController
@synthesize timePicker;

-(IBAction)save:(id)sender {
    
    //Antal klockor
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"];
    
    //selectedTime innehåller nu tiden som användaren matat in
    NSDate *selectedTime = [timePicker date];
    [[[Singleton sharedSingleton] sharedPrefs] setValue:selectedTime forKey:@"editAlarmTime"];
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    
    //Användarfeedback
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Time set" message:[NSString stringWithFormat:@"Time set"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
        
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    
    
    
    [timePicker setDate:[[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"editAlarmTime"]];
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
