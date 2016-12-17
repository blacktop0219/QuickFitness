//
//  HomeViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 01/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UpdateProfileViewController.h"
#import "UserViewController.h"


@interface HomeViewController : UIViewController
{    
    IBOutlet UILabel *lblTtile;
    IBOutlet UILabel *lblDetails;
    IBOutlet UILabel *lblStaminaMaster;
    
    IBOutlet UIView *MainVw;
    IBOutlet UIScrollView *scrollVwBottom;
    IBOutlet UIButton *btnMenu;
    IBOutlet UIButton *btnProfileTap, *btnGoalTap ,*btnAchievementTap;
    IBOutlet UIButton *btnGoalSelect, *btnAchievementSelect;
    CGPoint startLocation;
    
    IBOutlet UIView *imgMonthlyWeight;
    IBOutlet UIView *vWProfileImage;
    IBOutlet UIView *monthlyView, *steminaView;
    IBOutlet UIScrollView *scrollViewMiddle;
    
    IBOutlet UILabel *lblWeightDigit, *lblGoalReachability, *lblWType, *lblFromGoal;
    IBOutlet UIImageView *imgVwAchieve , *imgVwProfile, *imgVwBgblur;
    IBOutlet UIImageView *imgVwTempProfile;
    
    IBOutlet UIScrollView *scrRotateAchievement;
    NSMutableArray *arrNextObjects;
    int nNextObjectIndex, kNextTime;
    NSTimer *timeForNextAchievement;
    
    UserInfo *objUserInfo;
    UpdateProfileViewController *objUpdateProfile;
    UserViewController *objUserController;
}

@property (nonatomic, strong) NSString *strUserName;

-(IBAction)settingBtn_click:(id)sender;
-(IBAction)menuBtn_click:(id)sender;
-(IBAction)startWorkoutsBtn_click:(id)sender;

-(IBAction)WorkOutsBtn_click:(id)sender;
-(IBAction)calendarBtn_click:(id)sender;
-(IBAction)resultBtn_click:(id)sender;
-(IBAction)achievementsBtn_click:(id)sender;
-(IBAction)photoBtn_click:(id)sender;
-(IBAction)userBtn_click:(id)sender;

-(IBAction)btnProfileTap:(id)sender;
-(IBAction)btnGoalTap:(id)sender;
-(IBAction)btnAchievementTap:(id)sender;

-(IBAction)btnSelection:(UIButton *)btnSelected;

@end
