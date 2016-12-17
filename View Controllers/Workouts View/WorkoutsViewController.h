//
//  WorkoutsViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 04/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutsViewController : UIViewController <UIActionSheetDelegate>
{
    IBOutlet UIImageView *imgBg;
    
    IBOutlet UIImageView *imgAdvancedLock;
    IBOutlet UIImageView *imgExpertsLock;
    IBOutlet UIImageView *imgButtLock;
    IBOutlet UIScrollView *scrMain;
    
    IBOutlet UIButton *btnGeneral, *btnAdvance, *btnExpert, *btnButt;
}

-(IBAction)generalBtn_click:(id)sender;
-(IBAction)advancesBtn_click:(id)sender;
-(IBAction)expertsBtn_click:(id)sender;
-(IBAction)buttBtn_click:(id)sender;

@end
