//
//  AddTimeViewController.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddTimeViewController.h"
#import "Singleton.h"
#import "Alarm.h"

@implementation AddTimeViewController
@synthesize timePicker;

-(IBAction)save:(id)sender {
    
    //Antal klockor
    int y = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"Counter"]; 
    
    //selectedTime innehåller nu tiden som användaren matat in
    NSDate *selectedTime = [timePicker date];
    
    //Korrigerar till rätt format
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];

    //dateString innehåller nu tiden, fast som en sträng
    NSString *dateString = [outputFormatter stringFromDate:selectedTime];
    NSLog(@"Tiden som sträng: %@",dateString);
    
    //Lägger till tiden i sharedFireDates-arrayen
    [[[Singleton sharedSingleton] sharedFireDates] addObject:selectedTime];
    NSLog(@"Lade till ett objekt i sharedFireDates, hela arrayen: %@", [[Singleton sharedSingleton] sharedFireDates]);
    
    //Lägger till i singleton
    [[[Singleton sharedSingleton] sharedPrefs] setValue:dateString forKey:[NSString stringWithFormat:@"time%i",y]];
    
    //Synkar med singleton
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    
    //Användarfeedback
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Time" message:[NSString stringWithFormat:@"Alarm is set to: %@",dateString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
