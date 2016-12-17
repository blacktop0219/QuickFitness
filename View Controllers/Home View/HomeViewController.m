//
//  HomeViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 01/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "HomeViewController.h"
#import "WorkoutsViewController.h"
#import "SettingViewController.h"

#import "StartWorkoutsViewController.h"
#import "CalendarViewController.h"
#import "ResultViewController.h"
#import "AchievementsViewController.h"
#import "PhotoViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize strUserName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewWillAppear

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    imgVwProfile.layer.masksToBounds = YES;
    imgVwProfile.layer.cornerRadius = imgVwProfile.frame.size.width/2;
    imgVwProfile.layer.borderWidth = 0.0;
    imgVwProfile.layer.borderColor =[UIColor whiteColor].CGColor;
    
    objUserController = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self.view addSubview:appDelegate.adBanner];
 //  [[UIApplication sharedApplication]setStatusBarHidden:TRUE];
    scrollVwBottom.hidden = TRUE;
    scrollVwBottom.pagingEnabled = NO;
    MainVw.frame = CGRectMake(MainVw.frame.origin.x, 0, MainVw.frame.size.width, MainVw.frame.size.height);
    
    self.navigationController.navigationBarHidden = TRUE;
    [self setDetaultData];
    
    appDelegate.arrAllWorkOuts = [[NSMutableArray alloc]initWithArray:[DBController getDefaultWorkOuts:[[NSUserDefaults standardUserDefaults]objectForKey:@"ModelType"]]];
    
    ///========  Spacing between Lines =====//
    if(appDelegate.isIphone5){
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lblTtile.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:7];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lblTtile.text length])];
        lblTtile.attributedText = attributedString;
        lblTtile.textAlignment = NSTextAlignmentLeft;
    }
    //====== Set profile Pic
    NSString *ImageURL = [ProfilePath stringByAppendingPathComponent:objUserInfo.strImageUrl];
    imgVwProfile.image = [UIImage imageWithContentsOfFile:ImageURL];
    imgVwTempProfile.image = [UIImage imageWithContentsOfFile:ImageURL];
    imgVwBgblur.image = [self blur:[self screenshot]];
    
    if([objUserInfo.strWeightType isEqualToString:@"LBS"]){
        lblWeightDigit.text = [NSString stringWithFormat:@"%.0f",[self convertKGtoLBS:[objUserInfo.strGoalWeight floatValue]]];
    }else{
        lblWeightDigit.text = [NSString stringWithFormat:@"%d",[objUserInfo.strGoalWeight intValue]];
    }
    if([objUserInfo.strVoiceType isEqualToString:@"Female"]){
         [[NSUserDefaults standardUserDefaults]setObject:@"WomenSound" forKey:@"SoundType"];
    }else{
         [[NSUserDefaults standardUserDefaults]setObject:@"MenSound" forKey:@"SoundType"];
    }
    if([objUserInfo.strModelType isEqualToString:@"Female"]){
        [[NSUserDefaults standardUserDefaults]setObject:@"WomenModel" forKey:@"ModelType"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"MenModel" forKey:@"ModelType"];
    }
    
    if([objUserInfo.strWeightType isEqualToString:@"LBS"]){
         lblWType.text = @"LBS";
        NSString *sWeight = [NSString stringWithFormat:@"%.0f",[self convertKGtoLBS:[objUserInfo.strWeight floatValue]]];
        NSString *sGoal = [NSString stringWithFormat:@"%.0f",[self convertKGtoLBS:[objUserInfo.strGoalWeight floatValue]]];
        lblGoalReachability.text = [self goalReachability:[sWeight floatValue] :[sGoal floatValue]];
        lblFromGoal.text = [NSString stringWithFormat:@"You are %@ pounds away from your goal weight of %@",lblWeightDigit.text,sGoal];
    }else{
        lblGoalReachability.text = [self goalReachability:[objUserInfo.strWeight floatValue] :[objUserInfo.strGoalWeight floatValue]];
        NSString *sGoal = [NSString stringWithFormat:@"%d",[objUserInfo.strGoalWeight intValue]];
        lblWType.text = @"KG";
         lblFromGoal.text = [NSString stringWithFormat:@"You are %@ kg away from your goal weight of %@",lblWeightDigit.text,sGoal];
    }
    
    nNextObjectIndex = 0;
    arrNextObjects = [DBController getAchievementNextObject:appDelegate.UserId];
    
    imgVwAchieve.alpha = 1.0;
    if(arrNextObjects.count>0){
        AchievementsObjects *obj =[arrNextObjects objectAtIndex:nNextObjectIndex];
        lblStaminaMaster.text = obj.strTitle;
        imgVwAchieve.image = [UIImage imageNamed:obj.strIconImage];
    }
    kNextTime = 1;
   
    timeForNextAchievement = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getNextAchievement) userInfo:nil repeats:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"isLoadAppSecondTime"])
    {
        [self UpMainView];
        [self performSelector:@selector(DownMainView) withObject:nil afterDelay:2.5];
      //  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoadAppSecondTime"];
    }
}

-(void)getNextAchievement
{
     AchievementsObjects *obj =[arrNextObjects objectAtIndex:kNextTime];
    [UIView beginAnimations:@"fadein" context:nil];
    [UIView setAnimationDuration:0.7];
    imgVwAchieve.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",obj.strTitle]];
    imgVwAchieve.alpha = 1.0;
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideFade) withObject:nil afterDelay:4.9];
    lblStaminaMaster.text = obj.strTitle;
    if(kNextTime==arrNextObjects.count-1)
        kNextTime = 0;
    else
        kNextTime++;
}

- (void)unreadMessageCountChanged:(NSNotification *)notification {
    // Unread message count is contained in the notification's userInfo dictionary.
    NSNumber *unreadMessageCount = [notification.userInfo objectForKey:@"count"];
    
    // Update your UI or alert the user when a new message arrives.
    NSLog(@"You have %@ unread Apptentive messages", unreadMessageCount);
}

-(void)hideFade
{
    imgVwAchieve.alpha = 0.0;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [timeForNextAchievement invalidate];
    timeForNextAchievement = nil;
    [scrRotateAchievement setContentOffset:CGPointMake(0, 0)];
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)goalReachability :(float)nWeight :(float)nGoalWeight
{
    NSString *strText;
    float npercent = 0; float decuctedWeight = 0.0;
    if(nGoalWeight>nWeight){
        npercent = (nWeight/nGoalWeight)*100;
       decuctedWeight = nGoalWeight - nWeight;
    }
    else{
        npercent = (nGoalWeight/nWeight)*100;
        decuctedWeight = nWeight - nGoalWeight;
    }
   if(npercent>=10 && npercent<=25)
       strText = @"You are still far to reach your goal";
    else if (npercent>25 && npercent<=50)
        strText = @"You are half way to reach your goal";
    else if (npercent>50 && npercent<=75)
        strText = @"You are near to reach your goal";
    else if (npercent>75 && npercent<100)
        strText = @"You are very close to reach your goal";
    else if (npercent==100)
        strText = @"Congrats! You reached to your goal";
    
    lblWeightDigit.text = [NSString stringWithFormat:@"%0.0f",decuctedWeight];
    
    [self removeAllLayers];
    [self circleAnimation:npercent];
    return strText;
    
}
#pragma mark - Custom Events -

-(void)setDetaultData
{
    [self setfont];
    
    NSDate *currdate = [NSDate date];
    NSDateFormatter *formet = [[NSDateFormatter alloc] init];
    [formet setDateFormat:@"HH"];
    NSString *str = [formet stringFromDate:currdate];
    
    NSString *strMessage;
    
    if([str integerValue] > 4 && [str integerValue] <= 12){
        strMessage = @"Good Morning";
    }
    else if([str integerValue] > 12 && [str integerValue] <= 17){
        strMessage = @"Good Afternoon";
    }
    else if([str integerValue] > 17 && [str integerValue] <= 20){
        strMessage = @"Good Evening";
    }
    else{
        strMessage = @"Good Night";
    }
    NSMutableArray *arrUsers = [DBController getUsers];
    if(arrUsers.count>0){
        if(arrUsers.count == 1 && appDelegate.UserId == 2){
            [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"USERID"];
            appDelegate.UserId = 1;
        }
        objUserInfo =[arrUsers objectAtIndex:appDelegate.UserId-1];
        lblTtile.text = [NSString stringWithFormat:@"%@ %@", strMessage, objUserInfo.strName];
    }else{
        strUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserName"];
        lblTtile.text = [NSString stringWithFormat:@"%@ %@", strMessage, strUserName];
    }
    [[NSUserDefaults standardUserDefaults]setObject:objUserInfo.strGoalWeight forKey:@"MyGoalWeight"];
    
    [scrollVwBottom setContentSize:CGSizeMake(480, scrollVwBottom.frame.size.height)];
    [scrollViewMiddle setContentSize:CGSizeMake(640, scrollViewMiddle.frame.size.height)];
    scrollViewMiddle.pagingEnabled = YES;
}

-(void)setfont
{
//    if([[UIScreen mainScreen] bounds].size.height == 568){
//         lblTtile.font = [UIFont fontWithName:kHelveticaNeueThin size:35];
//    }
//    else{
//         lblTtile.font = [UIFont fontWithName:kHelveticaNeueThin size:35];
//    }
    lblStaminaMaster.font = [UIFont fontWithName:kHelveticaBold size:kFontSize15];
    
    lblWeightDigit.font = [UIFont fontWithName:kHelveticaNeueThin size:30.0];
    lblWeightDigit.textColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
}

#pragma mark - Conversion Formula
-(float)convertKGtoLBS :(float)kg
{
    float nLBS;
    nLBS = kg * 2.205;
    return nLBS;
}

#pragma mark - IBActin Events -

-(IBAction)WorkOutsBtn_click:(id)sender
{
    WorkoutsViewController *objWorkoutsViewController = [[WorkoutsViewController alloc] initWithNibName:@"WorkoutsViewController" bundle:nil];
    
    [self.navigationController pushViewController:objWorkoutsViewController animated:YES];
}

-(IBAction)calendarBtn_click:(id)sender
{
    CalendarViewController *objCalendarViewController = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    
    [self.navigationController pushViewController:objCalendarViewController animated:YES];
}

-(IBAction)resultBtn_click:(id)sender
{
    ResultViewController *objResultViewController = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
    
    [self.navigationController pushViewController:objResultViewController animated:YES];
}

-(IBAction)achievementsBtn_click:(id)sender
{
    AchievementsViewController *objAchievementsViewController = [[AchievementsViewController alloc] initWithNibName:@"AchievementsViewController" bundle:nil];
    
    [self.navigationController pushViewController:objAchievementsViewController animated:YES];
}

-(IBAction)photoBtn_click:(id)sender
{
    PhotoViewController *objPhotoViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
    
//    ADTransition * transition = [[ADGlueTransition alloc] initWithDuration:0.7f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
//    objPhotoViewController.transition = transition;
    
    [self.navigationController pushViewController:objPhotoViewController animated:YES];
}

-(IBAction)userBtn_click:(id)sender
{
    [self.navigationController pushViewController:objUserController animated:YES];
}

-(IBAction)settingBtn_click:(id)sender
{
    SettingViewController *objSettingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
//    ADTransition *trans = [[ADGlueTransition alloc] initWithDuration:0.7f orientation:ADTransitionRightToLeft sourceRect:self.view.bounds];
    
//    objSettingViewController.transition = trans;
    [self.navigationController pushViewController:objSettingViewController animated:YES];
}

-(IBAction)startWorkoutsBtn_click:(id)sender
{
    StartWorkoutsViewController *objStartWorkoutsViewController;
    if(appDelegate.isIphone5)
    {
        objStartWorkoutsViewController = [[StartWorkoutsViewController alloc] initWithNibName:@"StartWorkoutsViewController" bundle:nil];
    }else
    {
        objStartWorkoutsViewController = [[StartWorkoutsViewController alloc] initWithNibName:@"StartWorkoutViewController_i4" bundle:nil];
    }
//    ADTransition *trans = [[ADGlueTransition alloc] initWithDuration:0.7f orientation:ADTransitionRightToLeft sourceRect:self.view.bounds];
//    objStartWorkoutsViewController.transition = trans;
    [self.navigationController pushViewController:objStartWorkoutsViewController animated:YES];
}

-(IBAction)menuBtn_click:(id)sender
{
    if(MainVw.frame.origin.y<0){
        [self DownMainView];
    }
    else{
        [self UpMainView];
    }
}
/*-(IBAction)nextAchievement:(id)sender
{
    if(nNextObjectIndex+1 == arrNextObjects.count)
        return;
     nNextObjectIndex++;
    AchievementsObjects *obj =[arrNextObjects objectAtIndex:nNextObjectIndex];
    lblStaminaMaster.text = obj.strTitle;
    imgVwAchieve.image = [UIImage imageNamed:obj.strIconImage];
}
-(IBAction)previousAchievement:(id)sender
{
    if(nNextObjectIndex <=0)
        return;
    nNextObjectIndex--;
    AchievementsObjects *obj =[arrNextObjects objectAtIndex:nNextObjectIndex];
    lblStaminaMaster.text = obj.strTitle;
    imgVwAchieve.image = [UIImage imageNamed:obj.strIconImage];
}*/

-(IBAction)btnProfileTap:(id)sender
{
    UpdateProfileViewController *objUpdate;
    if(appDelegate.isIphone5)
    {
       objUpdate = [[UpdateProfileViewController alloc]initWithNibName:@"UpdateProfileViewController" bundle:nil];

    }else{
        objUpdate = [[UpdateProfileViewController alloc]initWithNibName:@"UpdateProfileViewController_i4" bundle:nil];
    }
    objUpdate.objUserInfo = objUserInfo;
    [self.navigationController pushViewController:objUpdate animated:YES];
}
-(IBAction)btnGoalTap:(id)sender
{
    ResultViewController *objResultViewController = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
    
    [self.navigationController pushViewController:objResultViewController animated:YES];
}
-(IBAction)btnAchievementTap:(id)sender
{
    AchievementsViewController *objAchievementsViewController = [[AchievementsViewController alloc] initWithNibName:@"AchievementsViewController" bundle:nil];
    
    [self.navigationController pushViewController:objAchievementsViewController animated:YES];
}

-(IBAction)btnSelection:(UIButton *)btnSelected
{
    // [[ATConnect sharedConnection] engage:@"completed_level" fromViewController:self];
    btnAchievementSelect.selected = FALSE;
    btnGoalSelect.selected = FALSE;
    switch (btnSelected.tag) {
        case 221:
            [scrollViewMiddle setContentOffset:CGPointMake(0, scrollViewMiddle.contentOffset.y)];
            [btnGoalSelect setSelected:TRUE];
            
            break;
        case 222:
            [scrollViewMiddle setContentOffset:CGPointMake(320, scrollVwBottom.contentOffset.y)];
            [btnAchievementSelect setSelected:TRUE];
            
            break;
        default:
            break;
    }
}

#pragma mark - Blur Methods
-(UIImage *) screenshot
{
    CGRect rect;
    rect=CGRectMake(0, 0, vWProfileImage.frame.size.width, vWProfileImage.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [vWProfileImage.layer renderInContext:context];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:3.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

#pragma mark - Custom Events -

-(void)UpMainView
{
    scrollVwBottom.hidden = FALSE;
    scrollVwBottom.pagingEnabled = NO;

    [UIView animateWithDuration:0.4
                          delay:0.2
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         MainVw.frame = CGRectMake(MainVw.frame.origin.x, -80, MainVw.frame.size.width, MainVw.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if(![[NSUserDefaults standardUserDefaults]boolForKey:@"isLoadAppSecondTime"])
                         {
                             [self ScrollAnimation];
                             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoadAppSecondTime"];
                         }
//                         if(!appDelegate.isFirstTimeShowAnimation){
//                             [self ScrollAnimation];
//                             appDelegate.isFirstTimeShowAnimation = TRUE;
//                         }
                         [btnMenu setSelected:TRUE];
                     }];
}
-(void)DownMainView
{
    scrollVwBottom.pagingEnabled = NO;

    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         MainVw.frame = CGRectMake(MainVw.frame.origin.x, 0, MainVw.frame.size.width, MainVw.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         scrollVwBottom.hidden = TRUE;
                         [btnMenu setSelected:FALSE];
                     }];
}
-(void)ScrollAnimation
{
    scrollVwBottom.pagingEnabled = NO;

    [UIView animateWithDuration:0.6
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         scrollVwBottom.frame = CGRectMake(-80, scrollVwBottom.frame.origin.y, scrollVwBottom.frame.size.width, scrollVwBottom.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.6
                                               delay:0.3
                                             options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              scrollVwBottom.frame = CGRectMake(0, scrollVwBottom.frame.origin.y, scrollVwBottom.frame.size.width, scrollVwBottom.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              
                                          }];
                     }];
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}
/* - (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    UITouch *touch = [touches anyObject];
    
    if(touch.phase == UITouchPhaseMoved)
    {
        return NO;
    }
    else
    {
        return [self touchesShouldBegin:touches withEvent:event inContentView:view];
    }
}*/


/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt1 = [[touches anyObject] locationInView:MainVw];
    startLocation = pt1;
    //    CGPoint pt = [[touches anyObject] locationInView:self.view];
    //    startLocation = pt;
    [[self.view superview] bringSubviewToFront:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:MainVw];
    CGRect MainViewRect = [MainVw frame];
    
    if(MainViewRect.origin.y <=0 && MainViewRect.origin.y >= -80){
        MainViewRect.origin.y += pt.y - startLocation.y;
        
        if(MainViewRect.origin.y < -80){
            MainViewRect.origin.y = -80.0;
        }
        if(MainViewRect.origin.y > 0){
            MainViewRect.origin.y = 0;
        }
        
        if (startLocation.y < pt.y) {
            if (MainVw.frame.origin.y < 0) {
                MainVw.frame = CGRectMake(0, MainViewRect.origin.y, MainVw.frame.size.width, MainVw.frame.size.height);
            }
        }
        else{
            if (MainVw.frame.origin.y> -79) {
                MainVw.frame = CGRectMake(0, MainViewRect.origin.y, MainVw.frame.size.width, MainVw.frame.size.height);
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (MainVw.frame.origin.y < -40) {
        [self UpMainView];
    }
    else{
        [self DownMainView];
    }
}
*/
#pragma mark - Draw Circle -

#define SHKdegreesToRadians(x) (M_PI * x / 180.0)

-(void)circleAnimation :(int)CurrentVal
{
    int radius = 39;
    int nCircleCount = (360*CurrentVal)/100 - 90;
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:radius startAngle:SHKdegreesToRadians(-90) endAngle:SHKdegreesToRadians(nCircleCount) clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
  //  circle.strokeColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f].CGColor;
    circle.strokeColor = [UIColor yellowColor].CGColor;
    circle.lineWidth = 9.5;
    
    // Add to parent layer
    [imgMonthlyWeight.layer addSublayer:circle];
    // Configure animation
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
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

-(void)circleAnimationForMonthlyWaight
{
    int radius = 39;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:radius startAngle:SHKdegreesToRadians(-90) endAngle:SHKdegreesToRadians(140) clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
 //   circle.strokeColor = [UIColor colorWithRed:130.0f/255.0f green:130.0f/255.0f blue:130.0f/255.0f alpha:1.0f].CGColor;
     circle.strokeColor = [UIColor yellowColor].CGColor;
    circle.lineWidth = 8;
    
    // Add to parent layer
    [imgMonthlyWeight.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
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
    for(CAShapeLayer *vW in imgMonthlyWeight.layer.sublayers)
    {
//        vW.backgroundColor = [UIColor clearColor].CGColor;
        vW.strokeColor = [UIColor clearColor].CGColor;
    }
}

#pragma mark - UISCrollView Delegate -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if(scrollView.tag == 101){
             [self circleAnimation:[objUserInfo.strWeight intValue]];
    }
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
