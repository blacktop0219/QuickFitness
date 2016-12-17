//
//  AddWeightViewController.h
//  QuickFitness
//
//  Created by Mitesh Panchal on 14/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"

@interface AddWeightViewController : UIViewController
{
    IBOutlet UITextField *txtFldWeight;
    IBOutlet UIButton *btnDone, *btnCancel;
    IBOutlet UILabel *lblNav, *lblWeightType;
}
@property id deleg;
@property BOOL isGoadAdd;
@property (nonatomic,strong) Goal *globalGoal;

-(IBAction)btnDone:(id)sender;
-(IBAction)btnCancel:(id)sender;

@end
