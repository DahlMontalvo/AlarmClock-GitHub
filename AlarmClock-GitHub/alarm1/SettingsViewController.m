//
//  SettingsViewController.m
//  alarm1
//
//  Created by Philip Montalvo on 2012-08-06.
//
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize delegate;

-(IBAction)cancel:(id)sender {
    [self.delegate settingsViewControllerDidCancel:self];
}

-(IBAction)save:(id)sender {
 // Do stuff here
     [self.delegate settingsViewControllerDidSave:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
