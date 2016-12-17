//
//  ResultViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "Goal.h"
#import "DBController.h"

#import "BarChartView.h"
#import "Social/Social.h"
#import <MessageUI/MessageUI.h>


@interface ResultViewController : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UITableView *tblVw, *tblVwWorks;
    IBOutlet UIScrollView *scrollVw;
    IBOutlet UIView *graphView;

    BOOL isBtnDaySelected;
    
////   BMI Outlets
    IBOutlet UILabel *lblTodayBMI;
    IBOutlet UILabel *lblMonthlyBMI;
    IBOutlet UIButton *btnDays;
    IBOutlet UIButton *btnMonths;
    IBOutlet UIView *todayVw;
    IBOutlet UIView *MonthlyVw;
    IBOutlet UILabel *lblTodayDigit;
    IBOutlet UILabel *lblMonthlyDigit;
    IBOutlet UILabel *lblGraphTitle;
    IBOutlet UIView *LineChartView;
    IBOutlet UIScrollView *LineChartSv;
    
////  Weight Outlets
    IBOutlet UILabel *lblTodayWeight;
    IBOutlet UILabel *lblMonthlyWeight;
    IBOutlet UILabel *lblGraphTitleWeight;
    IBOutlet UILabel *lblTodayDigitWeight;
    IBOutlet UILabel *lblMonthlyDigitWeight;
    IBOutlet UIView *todayVwWeight;
    IBOutlet UIView *MonthlyVwWeight;
    IBOutlet UIButton *btnDaysWeight;
    IBOutlet UIButton *btnMonthsWeight;
    IBOutlet UIView *WeightChartVw;
    IBOutlet UIScrollView *weightChartSv;
    
////  Weight Calories
    IBOutlet UILabel *lblTodayCalories;
    IBOutlet UILabel *lblMonthlyCalories;
    IBOutlet UILabel *lblGraphTitleCalories;
    IBOutlet UILabel *lblTodayDigitCalories;
    IBOutlet UILabel *lblMonthlyDigitCalories;
    IBOutlet UIView *todayVwCalories;
    IBOutlet UIView *MonthlyVwCalories;
    IBOutlet UIButton *btnDaysCalories;
    IBOutlet UIButton *btnMonthsCalories;
    IBOutlet UIView *CaloriesChartVw;
    
    UserInfo *objUserInfo;
//    CalculateBMI *objCalBMI, *objLastBMI;
    Goal *objCurrentGoal;
    NSMutableArray *arrResultData ,*arrResultMonthData;
    NSMutableArray *arrSectionDates, *arrRowTimes;
    NSMutableDictionary *tDictData;
    NSString *strTemp;
    
    //====== BarChartView =======//
    IBOutlet BarChartView *vWBarChart;
    NSMutableArray *arrColors, *arrLabelsColors;
    IBOutlet UILabel *lblYyam;
    IBOutlet UIView *vWBarSuggestion;
    
    SLComposeViewController *slComposeController;
    
}

@property (nonatomic,strong)  Goal *objCurrentGoal;
@property (nonatomic,strong) NSString *strUserWeight;
@property (nonatomic,readwrite) BOOL isCycleComplete;

-(IBAction)backBtn_click:(id)sender;
-(IBAction)addBtn_click:(id)sender;
-(void)sharingWithFBForSavedImages;

-(IBAction)dayMonthBtn_click:(id)sender;
@end
