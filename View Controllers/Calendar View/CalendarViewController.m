//
//  CalendarViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"
#import "CalendarDataObjects.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

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
    self.title = @"Calendar";
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 35);
    [btnBack setImage:[UIImage imageNamed:@"Back_Btn.png"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(BackBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItme = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItme;
    
    arrCalendar = [[NSMutableArray alloc] init];
    
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    [self.view addSubview:calendar];
    
    tblVw.backgroundColor = [UIColor clearColor];
    lblMessage.font = [UIFont fontWithName:kHelveticaNeueThin size:20];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = FALSE;
    
    SelectedIndexforDelete = -1;
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formate stringFromDate:[NSDate date]];
    
    [self GetCalendarData:strDate];
    [self.view addSubview:appDelegate.adBanner];
    [self.view addSubview:appDelegate.btnHideAd];
    [self.view addSubview:appDelegate.btnRemoveAd];
    
    if(appDelegate.isIphone5){
    if([appDelegate.adBanner isHidden]){
        tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width,238);
    }else{
        tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width, 180);
    }
    }else{
        if([appDelegate.adBanner isHidden]){
            tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width,136);
        }else{
            tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width, 92);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Events

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrCalendar.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDataObjects *cdo = [arrCalendar objectAtIndex:indexPath.row];
    NSMutableArray *arrData = [DBController getRecordsWithTime:cdo.strStartTime withUserId:appDelegate.UserId];
     if(arrData.count > 3)
        return 245.0f;
    else
        return 125.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    imgVw.image = [UIImage imageNamed:@"Cal_table_top.png"];
    [view addSubview:imgVw];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CalendarCell";
    
    CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        
        cell.lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize18];
        cell.lblDetail.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
        cell.lblTime.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize16];
        
        cell.lblTitle.textColor = [UIColor whiteColor];
        cell.lblTitle.textAlignment = NSTextAlignmentLeft;
//        cell.lblDetail.textColor = [UIColor blackColor];
      //  cell.lblTitle.textColor = [UIColor colorWithRed:99.0/255.0 green:205.0/255.0 blue:155.0/255.0 alpha:1.0];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = indexPath.row;
    
    CalendarDataObjects *cdo = [arrCalendar objectAtIndex:indexPath.row];

    if(cdo.PercentComplete >= 100){
          cell.lblTitle.text = [NSString stringWithFormat:@"1 - Circuit Complete"];
    }else{
          cell.lblTitle.text = [NSString stringWithFormat:@"%ld - Circuit Performed", (long)cdo.CircuitComplete];
    }
  
    NSMutableArray *arrData = [DBController getRecordsWithTime:cdo.strStartTime withUserId:appDelegate.UserId];
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
            lblPaus.textColor = [UIColor darkGrayColor];
            lblPaus.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize16];
            [cell.contentView addSubview:lblPaus];
        }

    }
    
   // cell.lblDetail.text = [NSString stringWithFormat:@"%ld%% complete, %ld Pauses", (long)cdo.PercentComplete, (long)cdo.Pauses];
    cell.lblTime.text = cdo.strStartTime;
    
    if(SelectedIndexforDelete == indexPath.row){
        cell.btnDelete.hidden = FALSE;
    }
    else{
        cell.btnDelete.hidden = TRUE;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        CalendarDataObjects *cdo = [arrCalendar objectAtIndex:indexPath.row];
        [DBController deleteWorkOutForTime:cdo.strStartTime withUserId:appDelegate.UserId];
        [arrCalendar removeObjectAtIndex:indexPath.row];
//        [tblVw reloadData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Custom Events -
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

-(void)BackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Calendar Delegate -

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    
    float Height = self.view.frame.size.height - (targetHeight+90)-44;
    tblVw.frame = CGRectMake(tblVw.frame.origin.x, targetHeight+90, tblVw.frame.size.width, Height);
    lblMessage.frame = CGRectMake(lblMessage.frame.origin.x, tblVw.frame.origin.y+20, lblMessage.frame.size.width, lblMessage.frame.size.height);
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
//    NSLog(@"Selected date = %@",date);
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formate stringFromDate:date];
    
    [self GetCalendarData:strDate];
}

-(void)GetCalendarData:(NSString*)strDate
{
    [arrCalendar removeAllObjects];
    
    NSString * str = [NSString stringWithFormat:@"SELECT * FROM UserWorkouts Where CreatedDate = '%@' AND UserID=%d GROUP BY StartTime", strDate,appDelegate.UserId];
    rs = [db executeQuery:str];
    while ([rs next]) {
        CalendarDataObjects *cdo = [[CalendarDataObjects alloc] init];
        cdo.Id = [rs intForColumnIndex:0];
        cdo.strStartTime = [rs stringForColumnIndex:1];
        cdo.CircuitComplete = [rs intForColumnIndex:2];
        cdo.PercentComplete = [rs intForColumnIndex:3];
        cdo.Pauses = [rs intForColumnIndex:4];
        cdo.strCreatedDate = [rs stringForColumnIndex:5];
        
        [arrCalendar addObject:cdo];
    }
    
    if(arrCalendar.count > 0){
        lblMessage.hidden = TRUE;
        tblVw.hidden = FALSE;
    }
    else{
        lblMessage.hidden = FALSE;
        tblVw.hidden = TRUE;
    }
    [tblVw reloadData];
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
