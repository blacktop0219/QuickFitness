//
//  NotificationViewController.m
//  SexyShape
//
//  Created by Mitesh Panchal on 22/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize tDictDaysReminder;

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
    self.title = @"Notification";
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 35);
    [btnBack setImage:[UIImage imageNamed:@"Back_Btn.png"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(BackBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItme = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItme;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 27, 23);
    [btnRight setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    
    [btnRight addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItme = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightItme;

    arrDays = [[NSMutableArray alloc]initWithObjects:@"Every Day",@"Every Weekend",@"Selected Days", nil];
    tDictDaysReminder = [[NSMutableDictionary alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    arrHours  =[[NSMutableArray alloc]init];
    arrMins = [[NSMutableArray alloc]init];
    arrTypes = [[NSMutableArray alloc]initWithObjects:@"AM",@"PM", nil];
    
    for(int hour=0;hour<12;hour++){
        [arrHours addObject:[NSString stringWithFormat:@"%d",hour]];
    }
    for(int min=0;min<60;min++)
    {
        [arrMins addObject:[NSString stringWithFormat:@"%d",min]];
    }
    [tblView reloadData];
    nHour = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"Hour"];
    nMin = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"MIN"];
    strAmPm = [[NSUserDefaults standardUserDefaults]objectForKey:@"AMPM"];
    
    int nPM;
    if([strAmPm isEqualToString:@"AM"])
        nPM= 0;
    else if ([strAmPm isEqualToString:@"PM"])
        nPM = 1;
    
    [timePicker selectRow:nHour inComponent:0 animated:YES];
    [timePicker selectRow:nMin inComponent:1 animated:YES];
    [timePicker selectRow:nPM inComponent:2 animated:YES];
    
    if(appDelegate.isIphone5){
        [self.view addSubview:appDelegate.adBanner];
        [self.view addSubview:appDelegate.btnHideAd];
        [self.view addSubview:appDelegate.btnRemoveAd];
    }
}
#pragma mark = Notification Reminder
-(void)scheduleAlarm
{
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDateComponents *dateComponents = [calender components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDateComponents *timeComponents = [calender components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    //Set up Fire Time--
    NSDateComponents *dateComp= [[NSDateComponents alloc]init];
    [dateComp setDay:[dateComponents day]];
    [dateComp setMonth:[dateComponents month]];
    [dateComp setYear:[dateComponents year]];
    [dateComp setHour:[timeComponents hour]];
    [dateComp setMinute:[timeComponents minute]];
    [dateComp setSecond:[timeComponents second]];
    
    //  NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:[alarmPicker countDownDuration]];
    localNotify = [[UILocalNotification alloc]init];
    
    localNotify.soundName = UILocalNotificationDefaultSoundName;
    if(localNotify==nil) return;
//    appDelegate.def = [NSUserDefaults standardUserDefaults];
//    [appDelegate.def setObject:[NSString stringWithFormat:@"%@", alarmArray] forKey:@"Save_Date"];
    fireDate = [calender dateFromComponents:dateComp];
    
    //Code2
    for(int i=0;i<self.currentSelectedReminders.count;i++)
    {
        //        NSDateFormatter *df=[[NSDateFormatter alloc]init];
        Class cls = NSClassFromString(@"UILocalNotification");
        if(cls!=nil)
        {
            int nHours=[[self.currentSelectedReminders objectAtIndex:i]intValue];
            localNotify.fireDate = [NSDate dateWithTimeInterval:(-nHours)*3600 sinceDate:[NSDate date]]; //PickerDate
            fireDate = localNotify.fireDate;
            NSDate *today = [NSDate date];
            
            NSDate *AlarmDate =[NSDate dateWithTimeInterval:0 sinceDate:[NSDate date]];  // pickerDate
            NSDateFormatter *DateFormatter = [[NSDateFormatter alloc]init];
            [DateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSString *strAlarmDate = [DateFormatter stringFromDate:AlarmDate];
            NSDateFormatter *TimeFormat = [[NSDateFormatter alloc]init];
            [TimeFormat setDateFormat:@"hh:mma"];
            NSString *strAlarmTime = [TimeFormat stringFromDate:AlarmDate];
            
            if([today compare:fireDate]==NSOrderedAscending)
            {
                localNotify.alertBody =[NSString stringWithFormat:@"You have a session %@ at %@",strAlarmDate,strAlarmTime];
                
                localNotify.alertAction = NSLocalizedString(@"View Details", nil);
                localNotify.applicationIconBadgeNumber = 1;
                localNotify.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication]scheduleLocalNotification:localNotify];
                
            }else{
                NSLog(@"Today date Bigger");
            }
        }
    }
    self.currentSelectedReminders = nil;
}
-(void)setDailyNotification :(int)nDay :(int)nMins
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDateComponents *dateComponents = [calender components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    //Set up Fire Time--
    NSDateComponents *dateComp= [[NSDateComponents alloc]init];
    [dateComp setDay:[dateComponents day]];
    [dateComp setMonth:[dateComponents month]];
    [dateComp setYear:[dateComponents year]];
    [dateComp setHour:nDay];
    [dateComp setMinute:nMins];

    NSDate *nitifyDate = [calender dateFromComponents:dateComp];
    
    UILocalNotification  *missingDreamNotify=[[UILocalNotification alloc]init];
    missingDreamNotify.fireDate= nitifyDate;
    missingDreamNotify.timeZone = [NSTimeZone defaultTimeZone];
    missingDreamNotify.alertBody = @"Are you free for workout ? Workout now !!";
    missingDreamNotify.alertAction = @"Show me";
    missingDreamNotify.soundName = UILocalNotificationDefaultSoundName;
    missingDreamNotify.applicationIconBadgeNumber = 1;
    missingDreamNotify.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:missingDreamNotify];
}
-(void)setWeekendNotification :(int)nHourTime :(int)nMinTime
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    NSArray *arrayVal = [tDictDaysReminder allValues];
    for(int i=0;i<arrayVal.count;i++){
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *now = [NSDate date];
        NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit|  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
        [componentsForFireDate setWeekday: [[arrayVal objectAtIndex:i] intValue]] ; //for fixing Sunday
        [componentsForFireDate setHour: nHourTime] ; //for fixing 8PM hour
        [componentsForFireDate setMinute: nMinTime] ;
        [componentsForFireDate setSecond:0] ;
        
        NSDate *fireDateOfNotification = [calendar dateFromComponents: componentsForFireDate];
        UILocalNotification *notification = [[UILocalNotification alloc]  init];
        notification.fireDate = fireDateOfNotification ;
        notification.timeZone = [NSTimeZone localTimeZone] ;
        notification.alertBody = [NSString stringWithFormat: @"Are you free for workout ? Workout now !!"];
        notification.alertAction = @"Show me";
        notification.userInfo= [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"New updates added for that week!"] forKey:@"new"];
        notification.repeatInterval= NSWeekCalendarUnit ;
        notification.soundName=UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
#pragma mark - TableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrDays.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CELl";
    UILabel *lblText ,*lblDetailText;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblText =[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 160, 40)];
        lblText.textColor = [UIColor whiteColor];
        lblText.font = [UIFont fontWithName:kHelveticaNeueThin size:22];
        [cell.contentView addSubview:lblText];
        
        lblDetailText = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 140, 60)];
        lblDetailText.textColor =[UIColor whiteColor];
        lblDetailText.font = [UIFont fontWithName:kHelveticaNeueThin size:18];
        lblDetailText.numberOfLines = 2;
        lblDetailText.hidden = TRUE;
        [cell.contentView addSubview:lblDetailText];
        
        if(indexPath.row==2)
            lblDetailText.hidden = FALSE;
        
       NSString *strNotify = [[NSUserDefaults standardUserDefaults]objectForKey:@"Notification"];
        if([strNotify isEqualToString:@"EveryDay"]){
            if(indexPath.row==0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }else if ([strNotify isEqualToString:@"EveryWeekend"]){
            if(indexPath.row==1)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }else if ([strNotify isEqualToString:@"SelectedDays"]){
            tDictDaysReminder = [[NSUserDefaults standardUserDefaults]objectForKey:@"ReminderDays"];
        }
        
    }
    lblText = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
    lblDetailText = (UILabel *)[cell.contentView.subviews objectAtIndex:1];
    
    lblText.text =[arrDays objectAtIndex:indexPath.row];
    NSArray *array = [tDictDaysReminder allKeys];
    NSString *str = [array componentsJoinedByString:@","];
    if(indexPath.row==2)
        lblDetailText.text = str;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *lblTitle = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
    [tDictDaysReminder removeAllObjects];
    if(indexPath.row==2)
    {
        objDaysController = [[DaysViewController alloc]initWithNibName:@"DaysViewController" bundle:nil];
        objDaysController.deleg = self;
        [self.navigationController pushViewController:objDaysController animated:YES];
    }else{
        if(indexPath.row==1){
            [tDictDaysReminder setObject:@"1" forKey:@"Sunday"];
            [tDictDaysReminder setObject:@"7" forKey:@"Saturday"];
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [[NSUserDefaults standardUserDefaults]setObject:lblTitle.text forKey:@"Notification"];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark -  PickerView Delegate
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==0){
        nHour = [[arrHours objectAtIndex:row]intValue];
    }else if(component ==1){
        nMin = [[arrMins objectAtIndex:row]intValue];
    }else{
        strAmPm = [arrTypes objectAtIndex:row];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return arrHours.count;
    else if(component == 1)
        return arrMins.count;
    else
        return arrTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
        return [arrHours objectAtIndex:row];
    else if(component == 1)
        return [arrMins objectAtIndex:row];
    else
        return [arrTypes objectAtIndex:row];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font  = [UIFont fontWithName:kHelveticaNeueThin size:18];
    [pickerView addSubview:lblTitle];
    if(component==0){
        lblTitle.text = [arrHours objectAtIndex:row];
    }else if(component==1){
        lblTitle.text = [arrMins objectAtIndex:row];
    }else
    {
        lblTitle.text = [arrTypes objectAtIndex:row];
    }
    return lblTitle;
}

#pragma mark - ActionEvents
-(void)BackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtn
{
    [[NSUserDefaults standardUserDefaults]setObject:tDictDaysReminder forKey:@"ReminderDays"];
    [[NSUserDefaults standardUserDefaults]setInteger:nHour forKey:@"Hour"];
    [[NSUserDefaults standardUserDefaults]setInteger:nMin forKey:@"MIN"];
    [[NSUserDefaults standardUserDefaults]setObject:strAmPm forKey:@"AMPM"];
    
    if([strAmPm isEqualToString:@"PM"]){
        nHour = nHour+12;
    }
    
    NSString *strInterval = [[NSUserDefaults standardUserDefaults]objectForKey:@"Notification"];
    if([strInterval isEqualToString:@"EveryDay"]){
        [self setDailyNotification:nHour :nMin];
    }else {
        [self setWeekendNotification:nHour :nMin];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - LocalNotification


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
