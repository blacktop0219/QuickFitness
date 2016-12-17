//
//  AddWeightViewController.m
//  QuickFitness
//
//  Created by Mitesh Panchal on 14/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import "AddWeightViewController.h"
#import "ResultViewController.h"

@interface AddWeightViewController ()

@end

@implementation AddWeightViewController
@synthesize deleg,isGoadAdd;
@synthesize globalGoal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark- ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [txtFldWeight becomeFirstResponder];
    
    ResultViewController *obj = (ResultViewController *)deleg;
    NSString *strGoal = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyGoalWeight"];
    if(isGoadAdd)
        lblNav.text= @"Add Your Goal";
    else  if(globalGoal)
        lblNav.text = @"Update Your Weight";
    else
        lblNav.text = @"Add Your Weight";
    
     lblWeightType.text = obj.objCurrentGoal.strWeightType;
    if(strGoal.length>0 && isGoadAdd){
        if([obj.objCurrentGoal.strWeightType isEqualToString:@"LBS"]){
            txtFldWeight.text = [NSString stringWithFormat:@"%.0f",[self convertKGtoLBS:[strGoal floatValue]]];
        }else{
            txtFldWeight.text = [NSString stringWithFormat:@"%d",[strGoal intValue]];
        }
    }
    else if (globalGoal)
        txtFldWeight.text = globalGoal.strWeight;
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
-(void)getDaysBetweenDates
{
    NSString *strGetOldDateQuery = [NSString stringWithFormat:@"SELECT min(CreatedDate) as OldDate FROM UserWorkouts"];
    rs = [db executeQuery:strGetOldDateQuery];
    [rs next];
    NSString *strOldDate = [rs stringForColumn:@"OldDate"];
    
    if(strOldDate.length>0){
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *oldDate = [df dateFromString:strOldDate];
    
    int nDaysCount = (int)[self daysBetweenDate:oldDate andDate:[NSDate date]];
    if(nDaysCount>28)
    {
        BOOL isLock =[DBController getLock:4:appDelegate.UserId];
        if(isLock){
            [DBController getAchievement:4:appDelegate.UserId];
            [self.view addSubview:appDelegate.PopView];
            [appDelegate.PopView addSubview:appDelegate.adBanner];
            [self.view addSubview:appDelegate.btnHideAd];
            [self.view addSubview:appDelegate.btnRemoveAd];
            appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
            [appDelegate.window addSubview:appDelegate.popImageView];
            AchievementsObjects *objAchieve = [DBController getAchievementObject:4:appDelegate.UserId];
            [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
        }
    }
    }
}
#pragma mark - Calculation Formula
-(float)convertLBStoKG :(float)lbs
{
    float nKG;
    nKG = lbs * 0.45359237 ; //0.45359237
    return nKG;
}

-(float)convertKGtoLBS :(float)kg
{
    float nLBS;
    nLBS = kg  * 2.205; //2.2046226218
    return nLBS;
}

#pragma mark - ActionEvent
-(IBAction)btnDone:(id)sender
{
    if(isGoadAdd)
    {
         ResultViewController *obj = (ResultViewController *)deleg;
        if([obj.objCurrentGoal.strWeightType isEqualToString:@"LBS"]){
            float nKg = [self convertLBStoKG:[txtFldWeight.text floatValue]];
             [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%.0f",nKg] forKey:@"MyGoalWeight"];
            NSString *strUpdateGoalweight = [NSString stringWithFormat:@"update UserDetails set GoalWeight = %@ where id=%d",[NSString stringWithFormat:@"%.0f",nKg],appDelegate.UserId];
            [db executeUpdate:strUpdateGoalweight];
            
        }else{
            [[NSUserDefaults standardUserDefaults]setObject:txtFldWeight.text forKey:@"MyGoalWeight"];
            NSString *strUpdateGoalweight = [NSString stringWithFormat:@"update UserDetails set GoalWeight = %@ where id=%d",txtFldWeight.text,appDelegate.UserId];
            [db executeUpdate:strUpdateGoalweight];
        }
        
        
    }else if (globalGoal){
        NSString *strQuery = [NSString stringWithFormat:@"update Goal set Weight=%@ where ID=%d",txtFldWeight.text,globalGoal.nID];
        [db executeUpdate:strQuery];
        
        { //===== Update UserWeight
            NSString *strUpdateWeight = [NSString stringWithFormat:@"update UserDetails set Weight=%@ where id=%d",txtFldWeight.text,appDelegate.UserId];
            [db executeUpdate:strUpdateWeight];
        }
        
        [self CalculateCurrentBMI];
    }
    else{

        int nCount = [DBController getCycleCountForWorkout:appDelegate.UserId];  //== Weigh In Workout
        if(nCount>0)
        {
            BOOL isLock =[DBController getLock:3:appDelegate.UserId];
            if(isLock){
                [DBController getAchievement:3:appDelegate.UserId];
                [self.view addSubview:appDelegate.PopView];
                appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                [appDelegate.window addSubview:appDelegate.popImageView];
                AchievementsObjects *objAchieve = [DBController getAchievementObject:3:appDelegate.UserId];
                [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
            }
        }
        [self getDaysBetweenDates];  //== Weigh-In Master workout
        ResultViewController *obj = (ResultViewController *)deleg;
        obj.strUserWeight = txtFldWeight.text;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)btnCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)CalculateCurrentBMI
{
    NSString *strHeight = [NSString stringWithFormat:@"select Height from UserDetails where id=%d",appDelegate.UserId];
    rs = [db executeQuery:strHeight];
    [rs next];
    
    NSString *strheight = [rs stringForColumn:@"Height"];
    float nHeight  = [strheight floatValue]/100;
    int BMI;
    if([globalGoal.strWeightType isEqualToString:@"LBS"]){
          BMI = ([self convertLBStoKG:[txtFldWeight.text floatValue]])/(nHeight * nHeight);
    }else{
          BMI = [txtFldWeight.text intValue]/(nHeight * nHeight);
    }
    
    NSString *strUpdateBmi = [NSString stringWithFormat:@"update Goal set BMI = %d where UserId=%d",BMI,appDelegate.UserId];
    [db executeUpdate:strUpdateBmi];
}


#pragma mark -  TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - orientation Delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return FALSE;
}
-(BOOL)shouldAutorotate
{
    return FALSE;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



@end
