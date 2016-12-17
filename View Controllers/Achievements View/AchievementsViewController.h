//
//  AchievementsViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBController.h"

@interface AchievementsViewController : UIViewController
{
    IBOutlet UIButton *btnLock;
    IBOutlet UIButton *btnUnlock;
    IBOutlet UITableView *tblVw;
    BOOL isLock;
    
    NSMutableArray *arrLockedData, *arrUnLockedData;
}

-(IBAction)lockUnlockBtn_click:(id)sender;

@end
