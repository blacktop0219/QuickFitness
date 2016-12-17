//
//  ResultViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultCell.h"
#import "CalendarCell.h"
#import "LineChartViewController.h"
#import "AddWeightViewController.h"
#import "HomeViewController.h"

#define kGapBetweenTwoPoint 80

@interface ResultViewController ()

@end

@implementation ResultViewController
@synthesize strUserWeight;
@synthesize objCurrentGoal;
@synthesize isCycleComplete;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tblVw.backgroundColor = [UIColor clearColor];
    [self setFont];
    
    [scrollVw setContentSize:CGSizeMake(640, 0)];
    isBtnDaySelected = TRUE;
    arrColors = [[NSMutableArray  alloc]init];
    arrLabelsColors = [[NSMutableArray alloc]init];
    [self  UIColorToHexString:[UIColor magentaColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [scrollVw setContentOffset:CGPointMake(0, 0)];
     objUserInfo = [DBController getHeightWeight:appDelegate.UserId];
     int Count = [DBController getCountForGoal:appDelegate.UserId];
    objCurrentGoal = [[Goal alloc]init];
    [self getTodayDate];
    
    [self SetCurrentWeight];
    [self CalculateCurrentBMI];
    [self getCurrentWeekDay];
    
    objCurrentGoal.nUserId = appDelegate.UserId;
    objCurrentGoal.strWeightType = objUserInfo.strWeightType;
    
    if(strUserWeight.length>0){
        [DBController addGoalBMI:objCurrentGoal];
        [self SetCurrentWeight];
        [self CalculateCurrentBMI];
        
        [self LoadChartWithData];
        { //===== Update UserWeight
            NSString *strUpdateWeight = [NSString stringWithFormat:@"update UserDetails set Weight=%@ where id=%d",strUserWeight,appDelegate.UserId];
            [db executeUpdate:strUpdateWeight];
        }
        strUserWeight = @"";
    }else if (Count<=0){
        [DBController addGoalBMI:objCurrentGoal];
        [self SetCurrentWeight];
        [self CalculateCurrentBMI];
        [self LoadChartWithData];
    }else{
        [self LoadChartWithData];
    }
    [self removeAllLayers];
    if([objUserInfo.strWeightType isEqualToString:@"LBS"]){
        float nExpectedWeight = [self goalReachability:[lblMonthlyDigitWeight.text floatValue] :[objUserInfo.strGoalWeight floatValue]];
        float nExpectedWeight1 = [self goalReachability:[lblMonthlyDigit.text floatValue] :[objUserInfo.strGoalWeight floatValue]];
        
        [self circleAnimation : 100];
        [self circleAnimationForMonthly : [self convertLBStoKG:nExpectedWeight]];
        [self circleAnimation : 100];
        [self circleAnimationForMonthly : [self convertLBStoKG:nExpectedWeight1]];

    }else{
        float nExpectedWeight = [self goalReachability:[lblMonthlyDigitWeight.text floatValue] :[objUserInfo.strGoalWeight floatValue]];
        float nExpectedWeight1 = [self goalReachability:[lblMonthlyDigit.text floatValue] :[objUserInfo.strGoalWeight floatValue]];
        [self circleAnimation : 100];
        [self circleAnimationForMonthly : nExpectedWeight];
        [self circleAnimation : 100];
        [self circleAnimationForMonthly : nExpectedWeight1];
    }
    arrResultData = [DBController getResultArray:appDelegate.UserId];
    arrResultMonthData = [DBController getREsultMonthArray:appDelegate.UserId];
    
    [self getWorkoutsWithGroupDate];
    [tblVw reloadData]; [tblVwWorks reloadData];
    
 //   [appDelegate.adBanner addSubview:appDelegate.btnRemoveAd];
    [self.view addSubview:appDelegate.adBanner];
    [self.view addSubview:appDelegate.btnHideAd];
    [self.view addSubview:appDelegate.btnRemoveAd];
    
    if([appDelegate.adBanner isHidden]){
        tblVwWorks.frame = CGRectMake(tblVwWorks.frame.origin.x, tblVwWorks.frame.origin.y, tblVwWorks.frame.size.width,209);
    }else{
        tblVwWorks.frame = CGRectMake(tblVwWorks.frame.origin.x, tblVwWorks.frame.origin.y, tblVwWorks.frame.size.width,165);
    }
    
    self.navigationController.navigationBarHidden = TRUE;
    if(isCycleComplete){
        UIAlertView *alertShare = [[UIAlertView alloc]initWithTitle:appTitle message:@"Congrats..! You have completed Cycle. Do you want to share your Results?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
        alertShare.tag = 721;
        [alertShare show];
        isCycleComplete =FALSE;
    }
    vWBarSuggestion.alpha = 1.0;
    [self performSelector:@selector(hideViewBarSuggestion) withObject:nil afterDelay:4.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideViewBarSuggestion
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.2];
    vWBarSuggestion.alpha = 0;
    [UIView commitAnimations];
}
#pragma mark - ShareREsults
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 721)
    {
    if(buttonIndex == 0){
        UIActionSheet *actionsheetShare = [[UIActionSheet alloc]initWithTitle:@"Tell A Friend" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Share on Twitter",@"Share on Email", nil];
        actionsheetShare.tag = 451;
        [actionsheetShare showInView:self.view];
    }
    }
}
-(void)shareOnFacebook
{
    //========   With Social FrameWork =====//
   /* slComposeController = [[SLComposeViewController alloc]init];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        // Create the view controller defined in the .h file
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:@"I am using this awesome application from apples store & You can download from here"];
        // make the default string
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
            }else
            {
                BOOL isLock =[DBController getLock:2:appDelegate.UserId];
                if(isLock){
                    [DBController getAchievement:2:appDelegate.UserId];
                    [self.view addSubview:appDelegate.PopView];
                    appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                    [appDelegate.window addSubview:appDelegate.popImageView];
                    AchievementsObjects *objAchieve = [DBController getAchievementObject:2:appDelegate.UserId];
                    [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
                }
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        [controller setInitialText:appTitle];
        // show the controller
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
       
        [appDelegate alertMessage:@"Facebook is Unavailable on your device"];
    }*/
    appDelegate.delega = self;
    if (appDelegate.isFacebookAuthenticate)
    {
        [self sharingWithFBForSavedImages];
    }
    else
    {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }

}
-(void)sharingWithFBForSavedImages
{
    //[appDelegate showActivityWithText:@"Facebook Uploading..."];
     //NSString *strMsg = [NSString stringWithFormat:@"IHey guys, i've just completed my workout with SimpleShape Challenge.Check it out app url: %@",appstoreUrl];
    
      NSString *strMsg = [NSString stringWithFormat:@"This is how I workout, Download SimpleShape \n %@ \n #SimpleShapeApp",appstoreUrl];
    [appDelegate ShowActivity:@""];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:strMsg,@"message", nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:dictionary HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Success", nil)] message:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Sharing on Facebook is Successful.", nil)] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            // [appDelegate hideActivity];
            [alert show];
            
            BOOL isLock =[DBController getLock:2:appDelegate.UserId];
            if(isLock){
                [DBController getAchievement:2 :appDelegate.UserId];
                [self.view addSubview:appDelegate.PopView];
                appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                [appDelegate.window addSubview:appDelegate.popImageView];
                AchievementsObjects *objAchieve = [DBController getAchievementObject:2:appDelegate.UserId];
                [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
            }
            [appDelegate HideActivity];
        }
        else
        {
            [appDelegate HideActivity];
            [appDelegate alertMessage:error.localizedDescription];
            NSLog(@"Error: %@",error.localizedDescription);
        }
    }];
}

-(void)shareOnTwitter
{
    slComposeController = [[SLComposeViewController alloc]init];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [controller setInitialText:[NSString stringWithFormat:@"This is how I workout, Download SimpleShape \n %@ \n #SimpleShapeApp",appstoreUrl]];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            }else
            {
                BOOL isLock =[DBController getLock:2:appDelegate.UserId];
                if(isLock){
                    [DBController getAchievement:2:appDelegate.UserId];
                    [self.view addSubview:appDelegate.PopView];
                    appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                    [appDelegate.window addSubview:appDelegate.popImageView];
                    AchievementsObjects *objAchieve = [DBController getAchievementObject:2:appDelegate.UserId];
                    [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
                }
            }
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        //[controller setInitialText:appTitle];
        
        //Adding the URL to the facebook post value from iOS
        
        //[controller addURL:[NSURL URLWithString:@"http://www.mobile.safilsunny.com"]];
        
        //Adding the Image to the facebook post value from iOS
        
        //    [controller addImage:[UIImage imageNamed:@"fb.png"]];
        
        [appDelegate.window.rootViewController presentViewController:controller animated:YES completion:Nil];
    }
    else{
        [appDelegate alertMessage:@"Twitter is Unavailable on your device"];
    }
}
-(void)shareOnEmail
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker;
        @autoreleasepool {
            picker = [[MFMailComposeViewController alloc] init];
        }
        picker.mailComposeDelegate = self;
        [picker setSubject:appTitle];
        
        UIDevice *myDevice = [UIDevice currentDevice];
        NSString *strDeviceDetails = [NSString stringWithFormat:@"\n\n\nSystem Name: %@\nSystem Version: %@\nModel: %@",myDevice.systemName,myDevice.systemVersion,myDevice.model];
        //[picker setMessageBody:strDeviceDetails isHTML:NO];
        
        [picker setMessageBody:[NSString stringWithFormat:@"Get in shape with SimpleShape, Download on the AppStore now \n %@ \n #SimpleShapeApp \n\n%@",appstoreUrl,strDeviceDetails]isHTML:NO];
        
        
        [appDelegate.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }else{
        [appDelegate alertMessage:@"No Email Client is Configured !"];
    }
    
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //  message.text = @"Result: canceled";
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            //  message.text = @"Result: saved";
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
        {
            //message.text = @"Result: sent";
            BOOL isLock =[DBController getLock:2:appDelegate.UserId];
            if(isLock){
                [DBController getAchievement:2 :appDelegate.UserId];
                [self.view addSubview:appDelegate.PopView];
                appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                [appDelegate.window addSubview:appDelegate.popImageView];
                AchievementsObjects *objAchieve = [DBController getAchievementObject:2:appDelegate.UserId];
                [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
            }
            NSLog(@"Result: sent");
        }
            break;
        case MFMailComposeResultFailed:
            //message.text = @"Result: failed";
            NSLog(@"Result: failed");
            break;
        default:
            //message.text = @"Result: not sent";
            NSLog(@"Result: sent");
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getResultData
-(void)getWorkoutsWithGroupDate
{
    arrSectionDates = [[NSMutableArray alloc]init];
    arrRowTimes = [[NSMutableArray alloc]init];
    tDictData = [[NSMutableDictionary alloc]init];
    {
        NSString *strGetGroupDate = [NSString stringWithFormat:@"select CreatedDate from UserWorkouts  where UserId=%d GROUP BY CreatedDate ;",appDelegate.UserId];
        rs = [db executeQuery:strGetGroupDate];
        while ([rs next]) {
            NSString *strDate = [rs stringForColumn:@"CreatedDate"];
            [arrSectionDates addObject:strDate];
        }
    }
    
    for (NSString *selectDate in arrSectionDates) {
        
        //--------------- GetData TimeWise -----------------//
       /* NSString *strGetGroupTime = [NSString stringWithFormat:@"select StartTime from UserWorkouts where UserId=%d GROUP BY StartTime",appDelegate.UserId];
        rs = [db executeQuery:strGetGroupTime];
        while ([rs next]) {
            NSString *strDate = [rs stringForColumn:@"StartTime"];
            [arrRowTimes addObject:strDate];
        }*/
        //---------------------------------
        [tDictData setObject:[DBController getResultWorkouts:appDelegate.UserId :selectDate] forKey:selectDate];
    }
}
#pragma mark - Date Functions
-(NSString *)getTodayDate
{
    NSDateFormatter *df,*df2,*df3;
    @autoreleasepool {
        df = [[NSDateFormatter alloc]init];
        df2 = [[NSDateFormatter alloc]init];
        df3 = [[NSDateFormatter alloc]init];
    }
    [df setDateFormat:@"yyyyMMdd"]; [df2 setDateFormat:@"dd/MM/yyyy"]; [df3 setDateFormat:@"MMMM-yyyy"];
    NSString *str = [df stringFromDate:[NSDate date]];
    objCurrentGoal.strDate = [df2 stringFromDate:[NSDate date]];
    objCurrentGoal.strMonth = [df3 stringFromDate:[NSDate date]];
    
    rs = [db executeQuery:@"SELECT max(ID) as CurrId, WeekEndDate FROM Goal"];
    [rs next];
    NSString *CurrId = [rs stringForColumn:@"CurrId"];
    NSString *strED = [rs stringForColumn:@"WeekEndDate"];
    
    NSDate *TD = [df dateFromString:str];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *ED = [df dateFromString:strED];
    
    if(TD <= ED){
        str = CurrId;
    }
    else if(TD == ED){
        str = CurrId;
    }
    
    return str;
}
-(NSString *)getWeekDayfromDate :(NSString *)strDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [df dateFromString:strDate];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:date];
    int m = [comp weekday]; // 1 = Sunday, 2 = Monday, etc.
    
    NSString *strDay;
    switch (m) {
        case 1:
            strDay = @"Sunday";
            break;
        case 2:
            strDay = @"Monday";
            break;
        case 3:
            strDay  = @"TuesDay";
            break;
        case 4:
            strDay = @"WednesDay";
            break;
        case 5:
            strDay = @"Thursday";
            break;
        case 6:
            strDay = @"Friday";
            break;
        case 7:
            strDay = @"SaturDay";
            break;
        default:
            break;
    }
    return strDay;
}
-(NSString *)getMonthfromDate :(NSString *)strDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [df dateFromString:strDate];
    NSDateFormatter *d = [[NSDateFormatter alloc]init];
    [d setDateFormat:@"MMMM"];
    return [d stringFromDate:date];
}
+ (NSString *) dateDifference:(NSDate *)date
{
    const NSTimeInterval secondsPerDay = 60 * 60 * 24;
    NSTimeInterval diff = [date timeIntervalSinceNow] * -1.0;
    
    // if the difference is negative, then the given date/time is in the future
    // (because we multiplied by -1.0 to make it easier to follow later)
    if (diff < 0)
        return @"In the future";
    
    diff /= secondsPerDay; // get the number of days
    
    // if the difference is less than 1, the date occurred today, etc.
    if (diff < 1)
        return @"Today";
    else if (diff < 2)
        return @"Yesterday";
    else
        return [date description]; // use a date formatter if necessary
}

#pragma mark - Calculation Methods
-(void)CalculateCurrentBMI
{
    int BMI;
    
    //float nHeightVal = [objUserInfo.strHeight floatValue]/100;
    float nHeightVal;
    if([objUserInfo.strheightType isEqualToString:@"FT"]){
        
        NSArray *arr = [objUserInfo.strHeight componentsSeparatedByString:@" "];
        nHeightVal = [self convertFtToCm:[[arr objectAtIndex:0]intValue] :[[arr objectAtIndex:2]intValue]];
    }else{
        nHeightVal = [objUserInfo.strHeight floatValue]/100;
    }
    
    if(strUserWeight.length!=0){
        if([objUserInfo.strWeightType isEqualToString:@"LBS"])
            BMI = ([self convertLBStoKG:[strUserWeight floatValue]])/(nHeightVal * nHeightVal);
        
        else
            BMI = [strUserWeight floatValue]/(nHeightVal * nHeightVal);
    }else{
        BMI = [objUserInfo.strWeight floatValue]/(nHeightVal * nHeightVal);
    }
    NSString *strGoalWeight = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyGoalWeight"];
    int goalBMI;
    if([objUserInfo.strWeightType isEqualToString:@"LBS"])
    {
        goalBMI = [self convertLBStoKG:[strGoalWeight floatValue]];
    }
    goalBMI = [strGoalWeight floatValue]/(nHeightVal * nHeightVal);
    lblTodayDigit.text = [NSString stringWithFormat:@"%d",goalBMI];
    [[NSUserDefaults standardUserDefaults]setObject:lblTodayDigit.text forKey:@"MyGoalBMI"];
    int AvgBMI = [DBController getAvgBmi:appDelegate.UserId];
    if(AvgBMI==0)
    {
        lblMonthlyDigit.text = [NSString stringWithFormat:@"%d",BMI];
    }else{
        lblMonthlyDigit.text = [NSString stringWithFormat:@"%d",AvgBMI];
    }
    objCurrentGoal.strBMI = [NSString stringWithFormat:@"%d",BMI];
}
-(void)SetCurrentWeight
{
    NSString *strGoalWeight = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyGoalWeight"];
    
    if([objUserInfo.strWeightType isEqualToString:@"LBS"])
    {
        if(strGoalWeight.length>0){
           
            lblTodayDigitWeight.text = [NSString stringWithFormat:@"%d",(int)[self convertKGtoLBS:[strGoalWeight floatValue]]];
        }
        else
            lblTodayDigitWeight.text = @"0";
        
        int AvgWt = [DBController getAvgWeight:appDelegate.UserId];
        if(AvgWt<=0)
            lblMonthlyDigitWeight.text = [NSString stringWithFormat:@"%d",(int)[self convertKGtoLBS:[objUserInfo.strWeight floatValue]]];
        else
            lblMonthlyDigitWeight.text = [NSString stringWithFormat:@"%d",AvgWt];
        if(strUserWeight.length>0)
            objCurrentGoal.strWeight  = strUserWeight;
        else
            objCurrentGoal.strWeight = [NSString stringWithFormat:@"%d",(int)[self convertKGtoLBS:[objUserInfo.strWeight floatValue]]];
    }else{
        if(strGoalWeight.length>0)
            lblTodayDigitWeight.text = [NSString stringWithFormat:@"%d",(int)[strGoalWeight floatValue]];
        else
            lblTodayDigitWeight.text = @"0";
        
        int AvgWt = [DBController getAvgWeight:appDelegate.UserId];
        if(AvgWt<=0)
            lblMonthlyDigitWeight.text = [NSString stringWithFormat:@"%d",(int)[objUserInfo.strWeight floatValue]];
        else
            lblMonthlyDigitWeight.text = [NSString stringWithFormat:@"%d",AvgWt];
        if(strUserWeight.length>0)
            objCurrentGoal.strWeight  = strUserWeight;
        else
            objCurrentGoal.strWeight = [NSString stringWithFormat:@"%d",(int)[objUserInfo.strWeight floatValue]];
    }
}

-(float)goalReachability :(float)nWeight :(float)nGoalWeight
{
    float npercent = 0;
    if(nGoalWeight>nWeight)
        npercent = (nWeight/nGoalWeight)*100;
    else
        npercent = (nGoalWeight/nWeight)*100;
    
    return npercent;
}
#pragma mark - Conversion Formula
-(float)convertKGtoLBS :(float)kg
{
    float nLBS;
    nLBS = kg * 2.205;
    return nLBS;
}
-(float)convertLBStoKG :(float)lbs
{
    float nKG;
    nKG = lbs * 0.45359237;
    return nKG;
}
-(int)convertFtToCm:(int)ft :(int)inc
{
    int cm;
    inc = inc+ ft*12;
    cm = inc * 2.54;
    return cm;
}

#pragma mark - TableView Events
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView.tag == 1111)
        return arrSectionDates.count;
    else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView.tag == 1111){
        NSArray *arrays = [tDictData objectForKey:[arrSectionDates objectAtIndex:section]];
        return arrays.count;
    }else{
        return  arrResultData.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1111){
        NSArray *arrObject = [tDictData objectForKey:[arrSectionDates objectAtIndex:indexPath.section]];
        CalendarDataObjects *objCale =  [arrObject objectAtIndex:indexPath.row];
        NSMutableArray *arrData = [DBController getRecordsWithTime:objCale.strStartTime withUserId:appDelegate.UserId];
        if(arrData.count>3)
            return 245.0f;
        else
            return 125.0f;
    }else{
        return 60.0f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 1111)
    {
        static NSString *CellIdentifier = @"CalendarCell";
        CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            cell.lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize18];
            cell.lblDetail.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
            cell.lblTime.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize16];
            
            //cell.lblDetail.textColor = [UIColor whiteColor];
            cell.lblTitle.textColor = [UIColor whiteColor];
            cell.lblTitle.textAlignment = NSTextAlignmentLeft;
//           cell.lblTitle.textColor = [UIColor colorWithRed:99.0/255.0 green:205.0/255.0 blue:155.0/255.0 alpha:1.0];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        NSArray *arrObject = [tDictData objectForKey:[arrSectionDates objectAtIndex:indexPath.section]];
        CalendarDataObjects *objCale =  [arrObject objectAtIndex:indexPath.row];
        if(objCale.PercentComplete >= 100){
             cell.lblTitle.text = [NSString stringWithFormat:@"1 - Circuit Complete"];
        }else{
              cell.lblTitle.text = [NSString stringWithFormat:@"%ld - Circuit Performed", (long)objCale.CircuitComplete];
        }
        
        NSMutableArray *arrData = [DBController getRecordsWithTime:objCale.strStartTime withUserId:appDelegate.UserId];
        for(int n=0; n<arrData.count;n++){
            
            if(n>3){
                int j = n-4;
                
                UIImageView *imgCircle = [[UIImageView alloc]initWithFrame:CGRectMake(7+(j*78), 134, 72, 72)];
                imgCircle.image = [UIImage imageNamed:@"test1.png"];
                [cell.contentView addSubview:imgCircle];
                
                NSMutableDictionary *tDictD = [arrData objectAtIndex:n];
                UIView *vWCircle = [[UIView alloc]initWithFrame:CGRectMake(7+(j*78), 134, 72, 72)];
                vWCircle.backgroundColor =[UIColor clearColor];
                [vWCircle.layer addSublayer:[self circleAnimation:[[tDictD objectForKey:@"PercentComplete"] intValue]]];
                [cell.contentView addSubview:vWCircle];
                
                UILabel *lblPer = [[UILabel alloc]initWithFrame:CGRectMake(7+(j*78), 152, 72, 38)];
                lblPer.text = [NSString stringWithFormat:@"%@%%",[tDictD objectForKey:@"PercentComplete"]];
                lblPer.textAlignment = NSTextAlignmentCenter;
                lblPer.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
                [cell.contentView addSubview:lblPer];
                
                UILabel *lblPaus = [[UILabel alloc]initWithFrame:CGRectMake((j*78), 200, 75, 38)];
                lblPaus.text = [NSString stringWithFormat:@"%@ Pause",[tDictD objectForKey:@"Pauses"]];
                lblPaus.textAlignment = NSTextAlignmentCenter;
                lblPaus.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize16];
                lblPaus.textColor = [UIColor darkGrayColor];
                [cell.contentView addSubview:lblPaus];
                
            }else{
                UIImageView *imgCircle = [[UIImageView alloc]initWithFrame:CGRectMake(7+(n*78), 28, 72, 72)];
                imgCircle.image = [UIImage imageNamed:@"test1.png"];
                [cell.contentView addSubview:imgCircle];
                
                 NSMutableDictionary *tDictD = [arrData objectAtIndex:n];
                UIView *vWCircle = [[UIView alloc]initWithFrame:CGRectMake(7+(n*78), 28, 72, 72)];
                vWCircle.backgroundColor =[UIColor clearColor];
                [vWCircle.layer addSublayer:[self circleAnimation:[[tDictD objectForKey:@"PercentComplete"] intValue]]];
                [cell.contentView addSubview:vWCircle];
                
                UILabel *lblPer = [[UILabel alloc]initWithFrame:CGRectMake(7+(n*78), 46, 72, 38)];
                lblPer.text = [NSString stringWithFormat:@"%@%%",[tDictD objectForKey:@"PercentComplete"]];
                lblPer.textAlignment = NSTextAlignmentCenter;
                lblPer.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
                [cell.contentView addSubview:lblPer];
                
                UILabel *lblPaus = [[UILabel alloc]initWithFrame:CGRectMake((n*78), 94, 75, 38)];
                lblPaus.text = [NSString stringWithFormat:@"%@ Pause",[tDictD objectForKey:@"Pauses"]];
                lblPaus.textAlignment = NSTextAlignmentCenter;
                lblPaus.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize16];
                lblPaus.textColor = [UIColor darkGrayColor];
                [cell.contentView addSubview:lblPaus];
            }
            
        }
        
        cell.lblDetail.text = [NSString stringWithFormat:@"%ld%% complete, %ld Pauses", (long)objCale.PercentComplete, (long)objCale.Pauses];
        cell.lblTime.text = objCale.strStartTime;
        
//        if(SelectedIndexforDelete == indexPath.row){
//            cell.btnDelete.hidden = FALSE;
//        }
//        else{
//            cell.btnDelete.hidden = TRUE;
//        }
        return cell;
        
    }else{
        static NSString *CellIdentifier = @"ResultCell";
        ResultCell *cell = (ResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
             cell.lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
             cell.lblDight.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
             cell.lblBMI.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize13];
             
             cell.backgroundColor = [UIColor clearColor];
             cell.accessoryType = UITableViewCellAccessoryNone;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
         if(isBtnDaySelected){
         Goal *objCal = [arrResultData objectAtIndex:indexPath.row];
         cell.lblTitle.text =  objCal.strWeekDate;
         if(scrollVw.contentOffset.x < 320){
             
         if ([objCal.strWeightType isEqualToString:@"LBS"]){
             
             cell.lblDight.text = [NSString stringWithFormat:@"%d",[objCal.strWeight intValue]];
             cell.lblBMI.text = @"LBS";
         }else{
             
             cell.lblDight.text = [NSString stringWithFormat:@"%d",[objCal.strWeight intValue]];
             cell.lblBMI.text = @"KG";
         }
         }
         else if (scrollVw.contentOffset.x >= 320 &&  scrollVw.contentOffset.x < 640){
         
         cell.lblDight.text = objCal.strBMI;
         cell.lblBMI.text = @"BMI";
         }
         }else
         {
         Goal *objCal = [arrResultMonthData objectAtIndex:indexPath.row];
         cell.lblTitle.text = objCal.strMonth;
         if(scrollVw.contentOffset.x < 320){
         if ([objCal.strWeightType isEqualToString:@"LBS"]){
         cell.lblDight.text = [NSString stringWithFormat:@"%d",[DBController getAvgWeightMonth:appDelegate.UserId]];
         cell.lblBMI.text = @"LBS";
         }else{
         cell.lblDight.text = [NSString stringWithFormat:@"%d",[DBController getAvgWeightMonth:appDelegate.UserId]];
         cell.lblBMI.text = @"KG";
         }
         }
         else if (scrollVw.contentOffset.x >= 320 && scrollVw.contentOffset.x < 640){
         cell.lblDight.text = [NSString stringWithFormat:@"%d",[DBController getAvgBmiMonth:appDelegate.UserId]];
         cell.lblBMI.text = @"BMI";
         }
         }
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 1111)
    {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,24)];
    UIImageView *headerImgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    
    headerView.backgroundColor = [UIColor clearColor];
    //headerImgView.image = [UIImage imageNamed:@"bg_summary_header.png"];
    headerImgView.backgroundColor = [UIColor whiteColor];
    headerImgView.alpha = 0.5;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.text = [arrSectionDates objectAtIndex:section];
    headerLabel.backgroundColor = [UIColor clearColor];
    //headerLabel.textColor = pinkColor;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:17.0];
    
    [headerView addSubview:headerImgView];
    [headerView addSubview:headerLabel];
    
    return headerView;
    }
    else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,22)];
       
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
        
        headerView.backgroundColor = [UIColor whiteColor];
        //headerImgView.image = [UIImage imageNamed:@"bg_summary_header.png"];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.text = @"Result Weights";
        headerLabel.backgroundColor = [UIColor clearColor];
        //headerLabel.textColor = pinkColor;
        headerLabel.textColor = [UIColor grayColor];
        headerLabel.font = [UIFont fontWithName:kHelveticaRegular size:17.0];
        
        [headerView addSubview:headerLabel];
        
        return headerView;
    }
}
#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* if(isBtnDaySelected && scrollVw.contentOffset.x < 320){
    Goal *objGoal = [arrResultData objectAtIndex:indexPath.row];
    AddWeightViewController *objAddWeight = [[AddWeightViewController alloc]initWithNibName:@"AddWeightViewController" bundle:nil];
    objAddWeight.deleg = self;
    objAddWeight.globalGoal = objGoal;
    [self presentViewController:objAddWeight animated:YES completion:nil];
    }*/
   
        UIActionSheet *actionsheetShare = [[UIActionSheet alloc]initWithTitle:@"Tell A Friend" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Share on Twitter",@"Share on Email", nil];
        actionsheetShare.tag = 452;

        [actionsheetShare showInView:self.view];
}

#pragma mark - IBAction Events -

-(IBAction)backBtn_click:(id)sender
{
    if([[self.navigationController.viewControllers objectAtIndex:0]isKindOfClass:[HomeViewController class]]){
        
         [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        HomeViewController *obj = (HomeViewController *)[self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:obj animated:YES];
    }
}
-(IBAction)addBtn_click:(id)sender
{
    NSString *strGoal = [[NSUserDefaults standardUserDefaults]objectForKey:@"MyGoalWeight"];
    if(strGoal.length>0)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:appTitle delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Your Current Week Weight",@"Edit Your Goal",nil];
        [actionSheet showInView:appDelegate.window];
    }else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:appTitle delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Your Current Week Weight",@"Add Your Goal", nil];
        [actionSheet showInView:appDelegate.window];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 451 || actionSheet.tag == 452){
    if(buttonIndex==actionSheet.cancelButtonIndex)
    {
        
    }else if (buttonIndex==0)
    {
        [self shareOnFacebook];
    }else if (buttonIndex==1)
    {
        [self shareOnTwitter];
    }else if (buttonIndex==2)
    {
        [self shareOnEmail];
    }
    }else{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        
    }else
    if(buttonIndex==0)
    {
        AddWeightViewController *objAddWeight = [[AddWeightViewController alloc]initWithNibName:@"AddWeightViewController" bundle:nil];
        objAddWeight.deleg = self;
      //  objAddWeight.globalGoal = objCurrentGoal;
        [self presentViewController:objAddWeight animated:YES completion:nil];

    }else if (buttonIndex==1)
    {
        AddWeightViewController *objAddWeight = [[AddWeightViewController alloc]initWithNibName:@"AddWeightViewController" bundle:nil];
        objAddWeight.deleg = self;
        objAddWeight.isGoadAdd = TRUE;
      //  objAddWeight.globalGoal = objCurrentGoal;
        [self presentViewController:objAddWeight animated:YES completion:nil];
    }
    }
}
-(IBAction)dayMonthBtn_click:(id)sender
{
    btnDays.selected = FALSE;
    btnDaysCalories.selected = FALSE;
    btnDaysWeight.selected = FALSE;
    
    btnMonths.selected = FALSE;
    btnMonthsCalories.selected = FALSE;
    btnMonthsWeight.selected = FALSE;
    
    UIButton *btnTemp = sender;
    btnTemp.selected = TRUE;
    
    if(btnTemp.tag == 101){
        btnDays.selected = TRUE;
        btnDaysCalories.selected = TRUE;
        btnDaysWeight.selected = TRUE;
        isBtnDaySelected = TRUE;
    }
    else
    {
        btnMonths.selected = TRUE;
        btnMonthsCalories.selected = TRUE;
        btnMonthsWeight.selected = TRUE;
        isBtnDaySelected = FALSE;
    }
    [tblVw reloadData];
    strTemp = @"";
}

#pragma mark - Custom Method -

-(void)setFont
{
    lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize25];
    
    lblTodayBMI.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    lblMonthlyBMI.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    btnDays.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    btnMonths.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    lblTodayDigit.font = [UIFont fontWithName:kHelveticaNeueThin size:30.0];
    lblMonthlyDigit.font = [UIFont fontWithName:kHelveticaNeueThin size:30.0];
    lblTodayDigit.textColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
    lblMonthlyDigit.textColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
    lblGraphTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
    
    lblGraphTitleWeight.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
    lblTodayWeight.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    lblMonthlyWeight.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    btnDaysWeight.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    btnMonthsWeight.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    lblTodayDigitWeight.font = [UIFont fontWithName:kHelveticaNeueThin size:30.0];
    lblMonthlyDigitWeight.font = [UIFont fontWithName:kHelveticaNeueThin size:30.0];
    lblTodayDigitWeight.textColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
    lblMonthlyDigitWeight.textColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
    
    lblGraphTitleCalories.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
    lblTodayCalories.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    lblMonthlyCalories.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    btnDaysCalories.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    btnMonthsCalories.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    lblTodayDigitCalories.font = [UIFont fontWithName:kHelveticaNeueThin size:26.0];
    lblMonthlyDigitCalories.font = [UIFont fontWithName:kHelveticaNeueThin size:26.0];
    lblTodayDigitCalories.textColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
    lblMonthlyDigitCalories.textColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
}

#pragma mark - Draw Circle -
#define SHKdegreesToRadians(x) (M_PI * x / 180.0)

-(CAShapeLayer *)circleAnimation :(int)CurrentVal
{
    int radius = 31;
    int nCircleCount = (360*CurrentVal)/100 - 90;
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(36, 36) radius:radius startAngle:SHKdegreesToRadians(-90) endAngle:SHKdegreesToRadians(nCircleCount) clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
  //  circle.strokeColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f].CGColor;
     circle.strokeColor = [UIColor yellowColor].CGColor;
    circle.lineWidth = 8.0;
    
    
    
    // Add to parent layer
   /* if(scrollVw.contentOffset.x >=0  && scrollVw.contentOffset.x<320){
       [todayVwWeight.layer addSublayer:circle];
    }
    else if(scrollVw.contentOffset.x >= 320){
         [todayVw.layer addSublayer:circle];
    }*/
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [drawAnimation setValue:circle forKey:@"animationLayer"];
    drawAnimation.duration            = 0; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.removedOnCompletion = YES;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    return circle;
}

-(void)circleAnimationForMonthly :(int)CurrentVal
{
    int radius = 39;
    int nCircleCount = (360*CurrentVal)/100 - 90;
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:radius startAngle:SHKdegreesToRadians(-90) endAngle:SHKdegreesToRadians(nCircleCount) clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
   // circle.strokeColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f].CGColor;
    circle.strokeColor = [UIColor yellowColor].CGColor;
    circle.lineWidth = 8;
    circle.name = @"weightCircle";
    // Add to parent layer
    if(scrollVw.contentOffset.x >=0 && scrollVw.contentOffset.x < 320){
        [MonthlyVwWeight.layer addSublayer:circle];
//        [MonthlyVwWeight.layer insertSublayer:circle atIndex:0];
         circle.name = @"MonthlyVwWeight";
    }
    else if(scrollVw.contentOffset.x >= 320){
        [MonthlyVw.layer addSublayer:circle];
        circle.name = @"MonthlyVw";
//         [MonthlyVw.layer insertSublayer:circle atIndex:0];
    }
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [drawAnimation setValue:circle forKey:@"animationLayer"];
    drawAnimation.duration            = 0.7; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.removedOnCompletion = YES;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}
-(void)removeAllLayers
{
    for(CALayer *vW in MonthlyVw.layer.sublayers)
    {
//      vW.backgroundColor = [UIColor clearColor].CGColor;
        if([vW.name isEqualToString:@"weightCircle"])
            [vW removeFromSuperlayer];
    }
    for(CALayer *vW in MonthlyVwWeight.layer.sublayers)
    {
     // vW.backgroundColor = [UIColor clearColor].CGColor;
        if([vW.name isEqualToString:@"weightCircle"])
            [vW removeFromSuperlayer];
    }
}

#pragma mark - UIScrollView Delegate -
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
/*- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
   if(scrollView.tag==301)
   {
    isBtnDaySelected = TRUE;
    [btnDays setSelected:true]; [btnMonths setSelected:false];
    [btnDaysWeight setSelected:true]; [btnMonthsWeight setSelected:false];
       
    [tblVw reloadData];
       [self removeAllLayers];
    if(scrollView.contentOffset.x < 320){
        if([objUserInfo.strWeightType isEqualToString:@"LBS"]){
             [self circleAnimation : 100];
            float nExpectedWeight = [self goalReachability:[lblMonthlyDigitWeight.text floatValue]:[objUserInfo.strGoalWeight floatValue]];
            [self circleAnimationForMonthly : [self convertLBStoKG:nExpectedWeight]];

        }else{
            [self circleAnimation : 100];
            float nExpectedWeight = [self goalReachability:[lblMonthlyDigitWeight.text floatValue] :[objUserInfo.strGoalWeight floatValue]];
            [self circleAnimationForMonthly : nExpectedWeight];
        }
    }
    else if (scrollView.contentOffset.x >= 320 &&  scrollView.contentOffset.x < 640){
        if([objUserInfo.strWeightType isEqualToString:@"LBS"]){
             [self circleAnimation : 100];
            float nExpectedWeight = [self goalReachability:[lblMonthlyDigit.text floatValue]:
                                     [lblTodayDigit.text floatValue]];
            [self circleAnimationForMonthly : [self convertLBStoKG:nExpectedWeight]];
            
        }else{
             [self circleAnimation : 100];
            float nExpectedWeight = [self goalReachability:[lblMonthlyDigit.text floatValue] :[lblTodayDigit.text floatValue]];
            [self circleAnimationForMonthly : nExpectedWeight];
        }
    }
   }
}
*/
#pragma mark - ChartView
-(void)LoadChartWithData
{
   /* for(id obj in weightChartSv.subviews){
        [obj removeFromSuperview];
    }
    
    for(id obj in LineChartSv.subviews){
        [obj removeFromSuperview];
    }
    
    NSMutableArray *arrXLabelsWeight = [NSMutableArray arrayWithArray:[DBController GetweeklyXLabels:appDelegate.UserId]];
    NSMutableArray *arrWeight = [NSMutableArray arrayWithArray:[DBController getWeeklyWEIGHT:appDelegate.UserId]];
    LineChartViewController *lcvc = [[LineChartViewController alloc] init:arrWeight withXLabels:arrXLabelsWeight];
    if([objUserInfo.strWeightType isEqualToString:@"LBS"]){
        lcvc.lineChartView.maxValue = 200;
        lcvc.lineChartView.interval = 40;
    }else{
        lcvc.lineChartView.maxValue = 100;
        lcvc.lineChartView.interval = 20;
    }
    [weightChartSv addSubview:lcvc.view];
    [weightChartSv setContentSize:CGSizeMake(kGapBetweenTwoPoint*arrWeight.count, 0)];
    
    NSMutableArray *arrLineChart = [NSMutableArray arrayWithArray:[DBController getWeeklyBMI:appDelegate.UserId]];
    LineChartViewController *detailViewController = [[LineChartViewController alloc] init:arrLineChart withXLabels:arrXLabelsWeight];
    [LineChartSv addSubview:detailViewController.view];
    [LineChartSv setContentSize:CGSizeMake(kGapBetweenTwoPoint*arrLineChart.count, 0)];*/
    
    //========Implement BarChart ======== ///
    NSMutableArray *arrXLabelsWeight = [NSMutableArray arrayWithArray:[DBController GetweeklyXLabels:appDelegate.UserId]];
    NSMutableArray *arrWeight = [NSMutableArray arrayWithArray:[DBController getWeeklyWEIGHT:appDelegate.UserId]];
    [arrColors removeAllObjects]; [arrLabelsColors removeAllObjects];
    for (int t=0; t<arrWeight.count; t++) {
        [arrColors addObject:@"#3CC6AA"];
        [arrLabelsColors addObject:@"FFFFFF"];
    }
    
    NSArray *array = [vWBarChart createChartDataWithTitles:[NSArray arrayWithArray:arrXLabelsWeight]
                                                  values:[NSArray arrayWithArray:arrWeight]
                                                  colors:[NSArray arrayWithArray:arrColors]
                                             labelColors:[NSArray arrayWithArray:arrLabelsColors]];
    //Set the Shape of the Bars (Rounded or Squared) - Rounded is default
    [vWBarChart setupBarViewShape:BarShapeRounded];
   /* if([objUserInfo.strWeightType isEqualToString:@"LBS"])
        vWBarChart.maxValue = 200;
    else
        vWBarChart.maxValue = 100; */
    
    //Set the Style of the Bars (Glossy, Matte, or Flat) - Glossy is default
    [vWBarChart setupBarViewStyle:BarStyleGlossy];
    
    //Set the Drop Shadow of the Bars (Light, Heavy, or None) - Light is default
    [vWBarChart setupBarViewShadow:BarShadowLight];
    
    //Generate the bar chart using the formatted data
    [vWBarChart setDataWithArray:array
                      showAxis:DisplayBothAxes
                     withColor:[UIColor whiteColor]
       shouldPlotVerticalLines:YES];
    //lblYyam.transform = CGAffineTransformMakeRotation(-M_PI_2);
}

-(NSString *) UIColorToHexString:(UIColor *)uiColor{
    CGColorRef color = [uiColor CGColor];
    
    int numComponents = CGColorGetNumberOfComponents(color);
    int red,green,blue, alpha;
    const CGFloat *components = CGColorGetComponents(color);
    if (numComponents == 4){
        red =  (int)(components[0] * 255.0);
        green = (int)(components[1] * 255.0);
        blue = (int)(components[2] * 255.0);
        alpha = (int)(components[3] * 255.0);
    }else{
        red  =  (int)(components[0] * 255.0);
        green  =  (int)(components[0] * 255.0);
        blue  =  (int)(components[0] * 255.0);
        alpha = (int)(components[1] * 255.0);
    }
    
    NSString *hexString  = [NSString stringWithFormat:@"#%02x%02x%02x%02x",
                            1,23,180,180];
    return hexString;
}
-(void)getCurrentWeekDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *formatterId = [[NSDateFormatter alloc]init];
    [formatterId setDateFormat:@"yyyyMMdd"];
    
    NSString *strTemp1 = [formatter stringFromDate:[NSDate date]];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"IST"];
    [formatter setTimeZone:gmt];

    NSDate *tempDate = [formatter dateFromString:strTemp1];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strStartDate = [formatter stringFromDate:[self getFirstDateOfWeek:[NSDate date]]];
    NSString *strEndDate = [formatter stringFromDate:[self getLastDateOfWeek:[NSDate date]]];
    
    objCurrentGoal.strWeekStartDate = strStartDate;
    objCurrentGoal.strWeekEndDate = strEndDate;
    NSString *strID = [NSString stringWithFormat:@"%@%d",[formatterId stringFromDate:[self getFirstDateOfWeek:[NSDate date]]],appDelegate.UserId];
    
    objCurrentGoal.nID = [strID intValue];
}
-(NSDate *)getFirstDateOfWeek:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}
-(NSDate *)getLastDateOfWeek:(NSDate *)date
{
    NSDate *startDate = [self getFirstDateOfWeek:date];
    NSDate *lastDate = [startDate dateByAddingTimeInterval:6*24*60*60];
    return lastDate;
}
#pragma mark - orientation Delegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return TRUE;
}
-(BOOL)shouldAutorotate
{
    return TRUE;
}
-(NSUInteger)supportedInterfaceOrientations
{
    [self getOrientView];
    return UIInterfaceOrientationMaskAll;
}
-(void)getOrientView
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if((orientation == UIInterfaceOrientationLandscapeLeft) | (orientation == UIInterfaceOrientationLandscapeRight))
    {
        [self.view addSubview:graphView];
        if(appDelegate.isIphone5){
            graphView.frame = CGRectMake(graphView.frame.origin.x, graphView.frame.origin.y, 568, graphView.frame.size.height);
        }else{
            graphView.frame = CGRectMake(graphView.frame.origin.x, graphView.frame.origin.y, 480, graphView.frame.size.height);
        }
    }else if ((orientation == UIInterfaceOrientationPortrait) | (orientation == UIInterfaceOrientationPortraitUpsideDown)){
        [graphView removeFromSuperview];
    }
    
}



@end
