//
//  DoMathViewController.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class DoMathViewController;
@protocol DoMathViewControllerDelegate <NSObject>

@end

@interface DoMathViewController : UIViewController {
    
}

@property (nonatomic) int answer;
@property (nonatomic, weak) id <DoMathViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *userAnswerTextField;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

-(IBAction)buttonPressed:(id)sender;

@end
