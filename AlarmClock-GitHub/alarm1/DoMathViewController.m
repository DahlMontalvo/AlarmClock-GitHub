//
//  DoMathViewController.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DoMathViewController.h"
#import "Alarm.h"

@implementation DoMathViewController
@synthesize delegate;
@synthesize alarmID;
@synthesize userAnswerTextField;
@synthesize questionLabel;
@synthesize answer;


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


-(IBAction)buttonPressed:(id)sender {
    
    if ([[userAnswerTextField text] intValue] == answer) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate stopSound];
        //Rätt svar
        //Snooza inte mer... nu är vi tillräckligt vakna
        //Hitta alarmet
        int save = -1;
        for (int i = 0; i < [[[Singleton sharedSingleton] sharedAlarmsArray] count]; i++) {
            if ([[[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:i] name] isEqualToString:alarmID]) {
                //Hittat! Spara i
                save = i;
            }
        }
        if (save != -1) {
            [[[[Singleton sharedSingleton] sharedAlarmsArray] objectAtIndex:save] noMoreSnooze];
        }
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        MasterViewController* myStoryBoardInitialViewController = [storyboard instantiateInitialViewController];
        myStoryBoardInitialViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.navigationController presentModalViewController:myStoryBoardInitialViewController animated:YES];
        
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong" message:@"Wrong answer. Try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [userAnswerTextField setText:@""];
        [userAnswerTextField becomeFirstResponder];
    }
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [userAnswerTextField becomeFirstResponder];
    
    NSLog(@"Användaren kom från alarm som heter: %@", alarmID);
    
    NSString *question;
    
    //Lite minnesplatser
    int number1;
    int number2;    
    
    number1 = arc4random() % 10 + 10;
    number2 = arc4random() % 10 + 10;
    
    //Om nummer 1 är mindre än nummer 2 uppstår problem vid bla subtraktion
    if (number1 < number2) {
        float temp = number1;
        number1 = number2;
        number2 = temp;
    }
        
    //Inte kul att räkna med noll i nämnaren till exempel
    if (number2 == 0) {
        number2 = 1;
    }
    
    int random = arc4random() % 3;
    
    if (random == 0) {
        answer = number1+number2;
        question = [NSString stringWithFormat:@"%i + %i", number1, number2];
    }
    else if (random == 1) {
        answer = number1-number2;
        question = [NSString stringWithFormat:@"%i - %i", number1, number2];
    }
    else if (random == 2) {
        if (number1%number2 != 0) {
            number1 = number1 - (number1%number2);
        }
        if (number1 < 0) {
            number1 = 0;
        }
        answer = (float) number1 / (float) number2;
        question = [NSString stringWithFormat:@"%i / %i", number1, number2];
    }
    else if (random == 3) {
        answer = number1*number2;
        question = [NSString stringWithFormat:@"%i * %i", number1, number2];
    }
    else {
        //FEL!
    }
    
    questionLabel.text = question;
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewDidUnload
{
    [self setQuestionLabel:nil];
    [self setUserAnswerTextField:nil];
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
