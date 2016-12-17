//
//  StartWorkoutsViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "StartWorkoutsViewController.h"
#import "UIImage+animatedGIF.h"
#import "WorkoutsObjects.h"
#import "ResultViewController.h"
#import "InAppRageIAPHelper.h"

@interface StartWorkoutsViewController ()

@end

@implementation StartWorkoutsViewController
@synthesize objUserInfo;
@synthesize isPlay;
@synthesize isRestRunning;
@synthesize startVw;
@synthesize btnVideo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewLife Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    view_Av=[[UIView alloc]initWithFrame:ImgWorkout.frame];
    view_Av.backgroundColor=[UIColor clearColor];

    appDelegate.CurrentSwitchName = @"Sound_on_off.png";
  //  appDelegate.isVoiceEnable = [[NSUserDefaults standardUserDefaults] boolForKey:@"VoiceOver"];
    if(appDelegate.isVoiceEnable)
        [self.mySwitch setOn:YES];
    else
        [self.mySwitch setOn:NO];
    NSString *str;
    if([str hasPrefix:@"#%"]){
        
    }
   
    objSongListViewController = [[SongListViewController alloc] initWithNibName:@"SongListViewController" bundle:nil];
    
    [self setFont];
}
-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = TRUE;
     selectWorkoutVw.hidden = false;
    RestVw.hidden = FALSE;
    isRestRunning = true;
    isStartUp = TRUE;
    
    isPurchaseAdvanceWorkout  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseAdvanceWorkout"]boolValue];
    isPurchaseExpertsWorkout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseExpertsWorkout"]boolValue];
    isPurchaseButtWorkout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseButtWorkout"]boolValue];
    isPurchaseAllWorkout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseAllWorkout"]boolValue];
 
    if(isPurchaseAllWorkout){
          arrWorkoutTypes = [[NSMutableArray alloc]initWithObjects:@"DEFAULT WORKOUTS",@"ADVANCE WORKOUTS",@"BUTT WORKOUTS",@"EXPERT WORKOUTS", nil];
    }else{
          arrWorkoutTypes = [[NSMutableArray alloc]initWithObjects:@"DEFAULT WORKOUTS",@"ADVANCE WORKOUTS",@"BUTT WORKOUTS",@"EXPERT WORKOUTS",@"PURCHASE ALL WORKOUTS", nil];
    }
   
    [self setCustomObservers];
    appDelegate.delega = self;
}
-(void)viewDidAppear:(BOOL)animated
{
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductRestoreFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedforAdvancedWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedFailedforAdvancedWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedforExpertsWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedFailedforExpertsWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedforButtWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedFailedforButtWorkout object:nil];
    
    if(!isMusicLaunch){
    [timerCountDown invalidate];
    timerCountDown = nil;
    }
    
    isStopedAudioPlayer = TRUE;
    self.synthesizer = nil;
   [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    
    //------ Set Default to Constant
    startVw.hidden = TRUE;
    CurrentRadious = -1.59;  CurrentRestRadius = -1.59;
    StartRadious = -1.60;   StartRestRadius = -1.60;
    
    strStartTime = @"";
    CircuitComplete = 0;
    PercentComplete = 0;
    TotalPauses = 0;
    
    SelectedIndex = 0;
    nCurrentIndex = -1;
    nGetAchieve = 0;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setUpDefaultLogic
{
    TotalWorkouts = appDelegate.arrAllWorkOuts.count;
    TotalRadious = 6.3;
    everyCycleRadious = TotalRadious/TotalWorkouts;
    //    everyRestRadious  = TotalRadious/RestDuration;
    CurrentRadious = -1.59;  CurrentRestRadius = -1.59;
    StartRadious = -1.60;   StartRestRadius = -1.60;
    
    strStartTime = @"";
    CircuitComplete = 0;
    PercentComplete = 0;
    TotalPauses = 0;
    
    SelectedIndex = 0;
    nCurrentIndex = -1;
    nGetAchieve = 0;
}
#pragma mark - Random Number Methods
- (int)getRandomNumber:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}
- (void)getNewUniqueRandomNumber {
    
    for(int i=1;i>0;i++)
    {
        int randomIndex = [self getRandomNumber:1 to:appDelegate.arrAllWorkOuts.count];
        for (int i = 0; i < [myRandomNumberArray count]; i++) {
            if ([[myRandomNumberArray objectAtIndex:i]intValue] == randomIndex) { //number is already in array
                randomIndex = 0; //let's set it to 0
            }
        }
        
        if (randomIndex == 0) {
            [self getNewUniqueRandomNumber]; //repeat, as we didn't get a random number this time
        }
        else {
            [myRandomNumberArray addObject:[NSNumber numberWithInt:randomIndex]];
            //add your code here to proceed
        }
        if(myRandomNumberArray.count>=appDelegate.arrAllWorkOuts.count){
            NSLog(@"RandomArray:%@",myRandomNumberArray);
            return;
        }
    }
}

#pragma mark - IBAction Events -
-(IBAction)startBtn_click:(id)sender
{
    startVw.hidden = TRUE; isStopedAudioPlayer = FALSE;
    
    if([strStartTime isEqualToString:@""])
    {
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"hh:mm aa"];
        NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formate.locale = twelveHourLocale;
        strStartTime = [formate stringFromDate:[NSDate date]];
    }
    [self setAllTime];
    everyRestRadious  = TotalRadious/RestBetweenCycle;
    everyRestBetweenCycleRadious = TotalRadious/RestDuration;
    
    if(appDelegate.audioPlayer && appDelegate.isVoiceEnable)
        [appDelegate.audioPlayer play];
}

-(IBAction)restartBtn_click:(id)sender
{
    countDownTime = ExcerciseDuration+1;
//    CurrentCycle = 1;
//    SelectedIndex = 0;
//    restTime = RestDuration+1;
//    lblDigit.text = @"0";
//    [timerCountDown invalidate];
//    timerCountDown = nil;
//    timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(CountDown) userInfo:nil repeats:NO];
}

-(IBAction)stopBtn_click:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName message:@"Are you Sure want to Quit?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 102;
    [alert show];
}

-(void)stopWorkouts
{
    ImgWorkout.hidden = TRUE;
    CurrentCycle = 1;
    SelectedIndex = 0;
    RestVw.hidden = FALSE;
    isRestRunning = false;
    lblCountDown.text = @"";
    lblDigit.text = @"0";
    [timerCountDown invalidate];
    timerCountDown = nil;
    startVw.hidden = FALSE;
}

-(IBAction)playPauseBtn_click:(id)sender
{
    if(isPlay){
        btnNext.hidden = FALSE; btnPrevious.hidden = FALSE; imgNextBG.hidden = FALSE;
        btnNext.enabled = TRUE; btnPrevious.enabled = TRUE;
        [btnPlayPause setImage:[UIImage imageNamed:@"SW_play.png"] forState:UIControlStateNormal];
        
       // btnNext.enabled= true; btnPrevious.enabled = true;
        isPlay = FALSE;
        [timerCountDown invalidate];
        timerCountDown = nil;
        [player pause];
        TotalPauses++;
    }
    else{
        
//         if((appDelegate.isRandomizedOrder ? nCurrentIndex+2:SelectedIndex) < TotalWorkouts){
//             btnNext.enabled = FALSE;
//         }else if((appDelegate.isRandomizedOrder ? nCurrentIndex:SelectedIndex-1) <= 0){
//             btnPrevious.enabled = FALSE;
//         }
        
       btnNext.hidden = TRUE; btnPrevious.hidden = TRUE; imgNextBG.hidden = TRUE;
        btnNext.enabled = TRUE; btnPrevious.enabled = TRUE;
        [btnPlayPause setImage:[UIImage imageNamed:@"SW_pause.png"] forState:UIControlStateNormal];
        //btnNext.enabled = false; btnPrevious.enabled = false;
        isPlay = TRUE;
        [player play];
          if(countDownTime >= 1 && [RestVw isHidden]){
            timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ExcerciseCountDown) userInfo:nil repeats:NO];
          }else  if(restTime >= 1 && ![RestVw isHidden]){
              timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(CountDown) userInfo:nil repeats:NO];
          }
    }
}
-(IBAction)restTimePause:(id)sender  // GestureClickEvent
{
    if(isPlay){
        isPlay = FALSE;
        [timerCountDown invalidate];
        timerCountDown = nil;
        TotalPauses++;
        [self pauseLayer:restCircle];
    }
    else{
        isPlay = TRUE;
        [self resumeLayer:restCircle];
        if(restTime >= 1){
            timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(CountDown) userInfo:nil repeats:NO];
        }
    }
}

-(IBAction)nextBtn_click:(id)sender
{
    btnPrevious.enabled  = TRUE;  isRestRunning = true;
    if((appDelegate.isRandomizedOrder ? nCurrentIndex+2:SelectedIndex) < TotalWorkouts){
        if(CurrentCycle <= SelectedCycleIndex)
        {
            countDownTime = ExcerciseDuration+1;
            if(appDelegate.isRandomizedOrder){
                nCurrentIndex++;
                SelectedIndex = [[myRandomNumberArray objectAtIndex:nCurrentIndex]intValue];
                
                 int Last = [[myRandomNumberArray objectAtIndex:nCurrentIndex-1]intValue];
                [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                         selector:@selector(speakExcerciseName:)
                                                           object:[NSString stringWithFormat:@"%ld",(long)Last]];
                
                [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
            }
            else{
                SelectedIndex++;
                [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                         selector:@selector(speakExcerciseName:)
                                                           object:[NSString stringWithFormat:@"%ld",(long)SelectedIndex-2]];
                [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex-1] afterDelay:1.0];
            }
//            if(!isPlay){
//                isPlay = TRUE;
//                [btnPlayPause setImage:[UIImage imageNamed:@"SW_pause.png"] forState:UIControlStateNormal];
//            }
            
            restTime = 1;
            [timerCountDown invalidate];
            timerCountDown = nil;
            RestVw.hidden = TRUE;
            [self PVTBtn_click:btnVideo];
            timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ExcerciseCountDown) userInfo:nil repeats:NO];
        }
    }
    else{
        //start againg
      /*  if(CurrentCycle < SelectedCycleIndex){
            countDownTime = ExcerciseDuration+1;
            SelectedIndex = 1; nCurrentIndex =0;
            CurrentCycle++;
            [timerCountDown invalidate];
            timerCountDown = nil;
            RestVw.hidden = TRUE;
            [self PVTBtn_click:btnVideo];
           
            timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ExcerciseCountDown) userInfo:nil repeats:NO];
        }
        else*/
        { //            stop
            //SelectedIndex = 0; nCurrentIndex=-1;
            //RestVw.hidden = FALSE;
            btnNext.enabled = FALSE;
            //-----
           /* isPlay = TRUE;
            btnNext.hidden = TRUE; btnPrevious.hidden = TRUE; imgNextBG.hidden = TRUE;
            [btnPlayPause setImage:[UIImage imageNamed:@"SW_pause.png"] forState:UIControlStateNormal]; */
            //------

//          ImgWorkout.hidden = TRUE;
            lblCountDown.text = @"";
            lblDigit.text = @"0";
            //CurrentCycle = 1;
            [timerCountDown invalidate];
            imgBlur.image = nil;
            CurrentRadious = -1.59;
            StartRadious = -1.60;
            isNeedtoRemoveCircle = TRUE;
            
           // [self setCapturedImage];
           // timerCountDown = nil;
           // startVw.hidden = FALSE;
        }
    }
}
-(IBAction)previousBtn_click:(id)sender
{
    btnNext.enabled  = TRUE; isRestRunning = true;
    
    if((appDelegate.isRandomizedOrder ? nCurrentIndex:SelectedIndex-1) <= 0){
       /* if(CurrentCycle > 1){
            CurrentCycle--;
            
            
            if(appDelegate.isRandomizedOrder){
                nCurrentIndex--;
                
                if(nCurrentIndex>=0){
                    SelectedIndex = [[myRandomNumberArray objectAtIndex:nCurrentIndex]intValue];
                    
                    int Last = [[myRandomNumberArray objectAtIndex:nCurrentIndex+1]intValue];
                    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                             selector:@selector(speakExcerciseName:)
                                                               object:[NSString stringWithFormat:@"%ld",(long)Last]];
                    [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
                }
            }
            else{
                SelectedIndex--;
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                         selector:@selector(speakExcerciseName:)
                                                           object:[NSString stringWithFormat:@"%ld",(long)SelectedIndex+1]];
                [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
            }
            
            SelectedIndex = TotalWorkouts;
            nCurrentIndex = TotalWorkouts-2;
            countDownTime = ExcerciseDuration+1;
            [timerCountDown invalidate];
            timerCountDown = nil;
            RestVw.hidden = TRUE;
            [self PVTBtn_click:btnVideo];
            timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ExcerciseCountDown) userInfo:nil repeats:NO];
           
        }*/
      //  else
        {
           // SelectedIndex = 0; nCurrentIndex = -1;
            //RestVw.hidden = FALSE;
            btnPrevious.enabled = FALSE;
            //------
           /* isPlay = TRUE;
            btnNext.hidden = TRUE; btnPrevious.hidden = TRUE; imgNextBG.hidden = TRUE;
            [btnPlayPause setImage:[UIImage imageNamed:@"SW_pause.png"] forState:UIControlStateNormal];*/
            //-------
            ImgWorkout.hidden = TRUE;
            lblCountDown.text = @"";
            lblDigit.text = @"0";
          //  CurrentCycle = 1;
            [timerCountDown invalidate];
            imgBlur.image = nil;
           // [self setCapturedImage];
            CurrentRadious = -1.59;
            StartRadious = -1.60;
            isNeedtoRemoveCircle = TRUE;
            timerCountDown = nil;
           // startVw.hidden = FALSE;
        }
    }
    else{
        if(CurrentCycle > 0){
            
            if(appDelegate.isRandomizedOrder){
                nCurrentIndex--;
                if(nCurrentIndex>=0){
                    SelectedIndex = [[myRandomNumberArray objectAtIndex:nCurrentIndex]intValue];
                    
                    int Last = [[myRandomNumberArray objectAtIndex:nCurrentIndex+1]intValue];
                    
                    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                             selector:@selector(speakExcerciseName:)
                                                               object:[NSString stringWithFormat:@"%ld",(long)Last]];
                    [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
                }
            }
            else{
                SelectedIndex--;
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                         selector:@selector(speakExcerciseName:)
                                                           object:[NSString stringWithFormat:@"%ld",(long)SelectedIndex]];
                [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex-1] afterDelay:1.0];
            }
            
            countDownTime = ExcerciseDuration+1;
            [timerCountDown invalidate];
            timerCountDown = nil;
            RestVw.hidden = TRUE;
            [self PVTBtn_click:btnVideo];
            timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ExcerciseCountDown) userInfo:nil repeats:NO];
            
        }
    }
}
-(IBAction)backBtn_click:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName message:@"Are you Sure want to Leave this Workouts...?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 101;
    [alert show];
}

-(IBAction) onChange:(DGSwitch *)theSwitch {
    if (theSwitch.on) {
        NSLog(@"Sound On");
        [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"VoiceOver"];
        appDelegate.isVoiceEnable = TRUE;
    } else {
        NSLog(@"Sound Off");
        [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:@"VoiceOver"];
        appDelegate.isVoiceEnable = FALSE;
    }
}

-(IBAction)btn_Click:(id)sender
{
    btn1.selected = btn2.selected = btn3.selected = btn4.selected = btn5.selected = btn6.selected = btn7.selected = btn8.selected = FALSE;
    UIButton *btn = sender;
    
    btn.selected = TRUE;
    
    SelectedCycleIndex = [btn.titleLabel.text integerValue];
}

-(IBAction)PVTBtn_click:(id)sender
{
    UIButton *btn = sender;
    
    btnPhoto.selected = FALSE;
    btnVideo.selected = FALSE;
    btnText.selected = FALSE;
    
    txtSteps.hidden = TRUE;
    ImgWorkout.hidden = FALSE;
    
    switch (btn.tag) {
        case 501:
            selected_BtnTag=501;
            view_Av.hidden=TRUE;
            ImgWorkout.hidden=FALSE;
            txtSteps.hidden=TRUE;
            btnPhoto.selected = TRUE;
            imgSelectionType.image = [UIImage imageNamed:@"imgSelected1.png"];
            [self SelectImage];
            break;

        case 502:
            selected_BtnTag=502;
             view_Av.hidden=FALSE;
            ImgWorkout.hidden=TRUE;
            txtSteps.hidden=TRUE;

            btnVideo.selected = TRUE;
            imgSelectionType.image = [UIImage imageNamed:@"imgSelected2.png"];
            [self selectVideo];
            break;

        case 503:
            selected_BtnTag=503;
             view_Av.hidden=TRUE;
            ImgWorkout.hidden=TRUE;
            txtSteps.hidden=FALSE;

            btnText.selected = TRUE;
            imgSelectionType.image = [UIImage imageNamed:@"imgSelected3.png"];
            [self SetStepsRelatedIndex];
            txtSteps.hidden = FALSE;
            txtSteps.text = strDesplayStrings;
            break;

        default:
            break;
    }
    
    [self.view bringSubviewToFront:btnPhoto];
    [self.view bringSubviewToFront:btnVideo];
    [self.view bringSubviewToFront:btnText];
}

-(IBAction)setMusicBtn_click:(id)sender
{
    isMusicLaunch = TRUE;
    [self presentViewController:objSongListViewController animated:YES completion:nil];
}

-(void)btnDone_click
{
    selectWorkoutVw.hidden = true;
    switch (nSelectedWorkoutType) {
        case 1:
            appDelegate.arrAllWorkOuts = [[NSMutableArray alloc]initWithArray:[DBController getDefaultWorkOuts:[[NSUserDefaults standardUserDefaults]objectForKey:@"ModelType"]]];
            break;
        case 2:
            appDelegate.arrAllWorkOuts = [[NSMutableArray alloc]initWithArray:[DBController getIntermediateWorkOuts:[[NSUserDefaults standardUserDefaults]objectForKey:@"ModelType"]]];
            break;
        case 3:
            appDelegate.arrAllWorkOuts = [[NSMutableArray alloc]initWithArray:[DBController getButtWorkOuts:[[NSUserDefaults standardUserDefaults]objectForKey:@"ModelType"]]];
            break;
        case 4:
            appDelegate.arrAllWorkOuts = [[NSMutableArray alloc]initWithArray:[DBController getExpertsSeriesWorkOuts:[[NSUserDefaults standardUserDefaults]objectForKey:@"ModelType"]]];
            break;
            
        default:
            break;
    }
    
    if(appDelegate.isRandomizedOrder){
        myRandomNumberArray  = [[NSMutableArray alloc]init];
        [self getNewUniqueRandomNumber];
    }
    [self setUpDefaultLogic];
    [imgBlur setImage:nil];
    [self setCapturedImage];
    
    isRestRunning = false;
    startVw.hidden = false;
    
    if(isMusicLaunch){
        isStopedAudioPlayer = FALSE;
        isMusicLaunch = FALSE;
    }else{
        CurrentCycle = 1;
        [self btn_Click:btn1];
        
        ImgWorkout.hidden = FALSE;
        WorkoutsObjects *wo = [appDelegate.arrAllWorkOuts objectAtIndex:0];
        
        NSURL *GifUrl = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@",wo.strVideoUrl] withExtension:@"gif"];
        ImgWorkout.image = [UIImage animatedImageWithAnimatedGIFURL:GifUrl];
    }
    isPlay = TRUE;
    isCircleRunning = FALSE;
    [RestVw addSubview:appDelegate.adBanner];
    [RestVw addSubview:appDelegate.btnHideAd];
    [RestVw addSubview:appDelegate.btnRemoveAd];
}

#pragma mark - TableView Events

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWorkoutTypes.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CELl";
    UILabel *lblText;  UIButton *btnAccessory;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellWorkoutType.png"]];
        cell.backgroundView.alpha = 0.5;
        
        lblText =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 250, 40)];
        lblText.textColor = [UIColor whiteColor];
        lblText.font = [UIFont fontWithName:kHelveticaNeueThin size:18];
        [cell.contentView addSubview:lblText];
        
        btnAccessory = [[UIButton alloc]initWithFrame:CGRectMake(268, 13, 34, 34)];
        [btnAccessory setImage:[UIImage imageNamed:@"unselectWorkoutType.png"] forState:UIControlStateNormal];
        [btnAccessory setImage:[UIImage imageNamed:@"selectWorkoutType.png"] forState:UIControlStateSelected];
        btnAccessory.tag = indexPath.row + 701;
        [btnAccessory addTarget:self action:@selector(accessoryClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:btnAccessory];
    }
  
      //  cell.accessoryType = UITableViewCellAccessoryNone;
       /* if(indexPath.row == 1)
        {
            if(!isPurchaseAdvanceWorkout){
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setMusic"]];
                [cell setEditing:FALSE animated:YES];
            }
        }else if (indexPath.row == 2)
        {
            if(!isPurchaseButtWorkout){
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setMusic"]];
                [cell setEditing:FALSE animated:YES];
            }
        }else if (indexPath.row == 3)
        {
            if(!isPurchaseExpertsWorkout){
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setMusic"]];
                [cell setEditing:FALSE animated:YES];
            }
        }*/
    lblText = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
    btnAccessory = (UIButton *)[cell.contentView.subviews objectAtIndex:1];
    
    lblText.text = [arrWorkoutTypes objectAtIndex:indexPath.row];
    
    if(indexPath.row == 1){
        if(!isPurchaseAdvanceWorkout){
            [btnAccessory setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        }else{
            [btnAccessory setImage:[UIImage imageNamed:@"unselectWorkoutType.png"] forState:UIControlStateNormal];
        }
    }else if (indexPath.row == 2){
        
        if(!isPurchaseButtWorkout){
            [btnAccessory setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        }else{
            [btnAccessory setImage:[UIImage imageNamed:@"unselectWorkoutType.png"] forState:UIControlStateNormal];
        }
    }else if (indexPath.row == 3){
        if(!isPurchaseExpertsWorkout){
            [btnAccessory setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        }else{
            [btnAccessory setImage:[UIImage imageNamed:@"unselectWorkoutType.png"] forState:UIControlStateNormal];
        }
    }else if (indexPath.row == 4){
        if(!isPurchaseAllWorkout){
            
            [btnAccessory setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        }else{
            [btnAccessory setImage:[UIImage imageNamed:@"unselectWorkoutType.png"] forState:UIControlStateNormal];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *btnAccessory = (UIButton *)[cell.contentView.subviews objectAtIndex:1];
    [self accessoryClick:btnAccessory];
    
  //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    BOOL isPurchaseAdvanceWorkout = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPurchaseAdvanceWorkout"];
//    BOOL isPurchaseExpertsWorkout = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPurchaseExpertsWorkout"];
//    BOOL isPurchaseButtWorkout = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPurchaseButtWorkout"];
    
  //  nSelectedWorkoutType = indexPath.row + 1;
  //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  //  cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // cell.accessoryType = UITableViewCellAccessoryNone;
}
#pragma mark - BlurEffect
-(UIImage *) screenshot
{
    CGRect rect;
    rect=CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    
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
    [filter setValue:[NSNumber numberWithFloat:4.0f] forKey:@"inputRadius"];
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
- (UIImage *)imageWithGaussianBlur {
    float weight[5] = {0.2270270270, 0.1945945946, .01216216216, .00540540541, .00162162162};
    /////////////// Blur horizontally
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [imgBlur.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame .size.height) blendMode:kCGBlendModePlusLighter alpha:weight[1]];
    for (int x = 1; x < 5; ++x) {
        [imgBlur.image drawInRect:CGRectMake(x, 0, self. view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
        [imgBlur.image drawInRect:CGRectMake(-x, 0, self. view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
    }
    UIImage *horizBlurredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /////// Blur vertically.
    UIGraphicsBeginImageContext(self.view.frame.size);
    [horizBlurredImage drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[1]];
    
    for (int y = 1; y < 5; ++y) {
        [horizBlurredImage drawInRect:CGRectMake(0, y, self.view.frame.size.width, self.view.frame. size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
        [horizBlurredImage drawInRect:CGRectMake(0, -y, self.view.frame.size.width, self.view.frame. size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
    }
    UIImage *blurredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blurredImage;
}
#pragma mark - Achievement Section
- (NSMutableArray *)getDatesArray
{
    NSString *strQueryGetData = [NSString stringWithFormat:@"select CreatedDate from UserWorkouts where CircuitComplete >= 1"];
  rs = [db executeQuery:strQueryGetData];
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    while ([rs next]) {
        NSString *strDate = [rs stringForColumn:@"CreatedDate"];
        [arrData addObject:strDate];
    }
    return arrData;
}
-(void)getInRowsAchievements
{
    NSMutableArray *arrDates = [self getDatesArray];  //==== In a Row Achievements
    if(arrDates.count>0){
    for(int i=0;i<arrDates.count-1;i++)
    {
        NSDate *startDate = [self dateFromString:[arrDates objectAtIndex:i]];
        NSDate *endDate = [self dateFromString:[arrDates objectAtIndex:i+1]];
        
        int nDayDifference = [self daysBetweenDate:startDate andDate:endDate];
        if(nDayDifference==1){
            nGetAchieve = nGetAchieve+1;
            if(nGetAchieve>=2){
                
                BOOL isLock =[DBController getLock:11:appDelegate.UserId];
                if(isLock){
                    [DBController getAchievement:11:appDelegate.UserId];
                    AchievementsObjects *objAchieve = [DBController getAchievementObject:11:appDelegate.UserId];
                    [self.view addSubview:appDelegate.PopView];
                    appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                    [appDelegate.window addSubview:appDelegate.popImageView];
                    [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
                }
            }
            if (nGetAchieve>=3){
                
                BOOL isLock =[DBController getLock:7:appDelegate.UserId];
                if(isLock){
                    [DBController getAchievement:7:appDelegate.UserId];
                    AchievementsObjects *objAchieve = [DBController getAchievementObject:7:appDelegate.UserId];
                    [self.view addSubview:appDelegate.PopView];
                    appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                    [appDelegate.window addSubview:appDelegate.popImageView];
                    [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
                }
            }
            if (nGetAchieve>=5){
                BOOL isLock =[DBController getLock:8:appDelegate.UserId];
                if(isLock){
                    [DBController getAchievement:8:appDelegate.UserId];
                    AchievementsObjects *objAchieve = [DBController getAchievementObject:8:appDelegate.UserId];
                    [self.view addSubview:appDelegate.PopView];
                    appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                    [appDelegate.window addSubview:appDelegate.popImageView];
                    [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
                }
            }
            if (nGetAchieve>=13){
                BOOL isLock =[DBController getLock:9:appDelegate.UserId];
                if(isLock){
                    [DBController getAchievement:9:appDelegate.UserId];
                    AchievementsObjects *objAchieve = [DBController getAchievementObject:9:appDelegate.UserId];
                    [self.view addSubview:appDelegate.PopView];
                    appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                    [appDelegate.window addSubview:appDelegate.popImageView];
                    [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
                }
            }
            continue;
        }else{
            nGetAchieve = 0;
        }
    }
    }
}
-(NSDate*)dateFromString :(NSString *)strDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[df dateFromString:strDate];
    return date;
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

#pragma mark - TexttoSpeech
-(void)textToSpeech :(NSString *)speechText
{
    if(appDelegate.isVoiceEnable && !isStopedAudioPlayer){
        
    BOOL isPlaySong;
    isPlaySong = appDelegate.audioPlayer.isPlaying;
    
 //   [self.synthesizer stopSpeakingAtBoundary:AVSpeechUtteranceDefaultSpeechRate];
    if(isPlaySong){
        [appDelegate.audioPlayer pause];
    }
    //es_AR,en-US,en-gb
        NSString *strSound = [[NSUserDefaults standardUserDefaults]objectForKey:@"SoundType"];
        NSString *strVoice;
        if([strSound isEqualToString:@"MenSound"]){
            strVoice = @"en-gb";
            
        }else if ([strSound isEqualToString:@"WomenSound"]){
            strVoice = @"en-AU";
        }
        
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:strVoice];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:speechText];
    utterance.voice = voice;
         
   /* float adjustedRate = 0.125;
    if (adjustedRate > AVSpeechUtteranceMaximumSpeechRate)
    {
        adjustedRate = AVSpeechUtteranceMaximumSpeechRate;
    }
    
    if (adjustedRate < AVSpeechUtteranceMinimumSpeechRate)
    {
        adjustedRate = AVSpeechUtteranceMinimumSpeechRate;
    }*/
    
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate/2.2;
    
    float pitchMultiplier = 1.1;
    utterance.pitchMultiplier = pitchMultiplier;
    [self.synthesizer speakUtterance:utterance];

    if(isPlaySong){
        [self performSelector:@selector(startBackgroundSong) withObject:nil afterDelay:1.0];
    }
    }
}
-(void)startBackgroundSong
{
    if(!isStopedAudioPlayer)
        [appDelegate.audioPlayer play];
}
- (AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer)
    {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}
-(void)speakExcerciseName :(NSString *)nExcer
{
    WorkoutsObjects *obj;
    if(appDelegate.isRandomizedOrder){
        obj = [appDelegate.arrAllWorkOuts objectAtIndex:([nExcer intValue]-1)];
    }else{
        obj = [appDelegate.arrAllWorkOuts objectAtIndex:[nExcer intValue]];
    }
    if([obj.strTitle isEqualToString:@"PUSH-UPS"])
        [self textToSpeech:@"Push ups"];
    else if ([obj.strTitle isEqualToString:@"CHAIR STEP-UPS"])
        [self textToSpeech:@"Chair Step ups"];
    else if ([obj.strTitle isEqualToString:@"PUSH-UPS WITH ROTATION"])
        [self textToSpeech:@"Push ups With Rotation"];
    else
        [self textToSpeech:obj.strTitle];
        
}

#pragma mark - UIAlert View Delegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        if(buttonIndex == 1) //// Go Out form this screen
        {
            if([startVw isHidden])
                CircuitComplete++;
            
            [self CalculateAndSaveWorkouts];
            [self getInRowsAchievements];
            [appDelegate.audioPlayer stop];
            isStopedAudioPlayer = TRUE;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag == 102)
    {
        if(buttonIndex == 1)  //// Stop
        {
            CircuitComplete++;
            [self CalculateAndSaveWorkouts];
            [self getInRowsAchievements];
            [appDelegate.audioPlayer stop];
            isStopedAudioPlayer = TRUE;
            [self stopWorkouts];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - Custom Method -
-(void)CalculateAndSaveWorkouts
{
    if(![strStartTime isEqualToString:@""]){
        NSDate *todayDate = [NSDate date];
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [formate stringFromDate:todayDate];
        [self setBetweenTime:todayDate];
        //NSInteger Per = TotalWorkouts*SelectedCycleIndex;
        NSInteger Per = TotalWorkouts;
        if(Per > 0){
            PercentComplete = (PercentComplete*100)/Per;
        }
        else{
            PercentComplete = 0;
        }
        NSString *str = [NSString stringWithFormat:@"Insert into UserWorkouts('StartTime', 'CircuitComplete', 'PercentComplete', 'Pauses', 'CreatedDate', 'UserId') values('%@', '%ld', '%ld', '%ld', '%@','%d')", strStartTime, (long)CircuitComplete, (long)PercentComplete, (long)TotalPauses, strDate ,appDelegate.UserId];
        [db executeUpdate:str];
        
        int nCycleCount = [DBController getCycleCountForWorkout:appDelegate.UserId];
        int nCycleInSingleDay = [DBController getCycleCountInSingleDay:strDate:appDelegate.UserId];
        
        if(nCycleCount>0) //=== FullHouse Achievement
        {
            BOOL isLock =[DBController getLock:1:appDelegate.UserId];
            if(isLock){
                [DBController getAchievement:1:appDelegate.UserId];
                [self.view addSubview:appDelegate.PopView];
                appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                [appDelegate.window addSubview:appDelegate.popImageView];
                AchievementsObjects *objAchieve = [DBController getAchievementObject:1:appDelegate.UserId];
                [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
            }
        }
//        int nCount = [DBController getCountForWorkout];  //===== First,Double & triple Achievements In a single Day
        if (nCycleInSingleDay>2)
        {
            BOOL isLock =[DBController getLock:18:appDelegate.UserId];
            if(isLock){
                [DBController getAchievement:18:appDelegate.UserId];
                [self.view addSubview:appDelegate.PopView];
                appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                [appDelegate.window addSubview:appDelegate.popImageView];
                AchievementsObjects *objAchieve = [DBController getAchievementObject:18:appDelegate.UserId];
                [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
            }
        }
        else if (nCycleInSingleDay>1)
        {
            BOOL isLock =[DBController getLock:17:appDelegate.UserId];
            if(isLock){
                [DBController getAchievement:17:appDelegate.UserId];
                [self.view addSubview:appDelegate.PopView];
                appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                [appDelegate.window addSubview:appDelegate.popImageView];
                AchievementsObjects *objAchieve = [DBController getAchievementObject:17:appDelegate.UserId];
                [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
            }
        }
       else if(nCycleInSingleDay>0)
        {
            BOOL isLock =[DBController getLock:16:appDelegate.UserId];
            if(isLock){
                [DBController getAchievement:16:appDelegate.UserId];
                [self.view addSubview:appDelegate.PopView];
                appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                [appDelegate.window addSubview:appDelegate.popImageView];
                AchievementsObjects *objAchieve = [DBController getAchievementObject:16:appDelegate.UserId];
                [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
            }
        }
    }
}
-(void)setBetweenTime: (NSDate* )todayDate
{
    NSString *time1 = @"04:00:00"; NSString *time2 = @"10:00:00";
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSString *strTime = [timeFormat stringFromDate:todayDate];
    
    NSDate *CurrentDate  =[timeFormat dateFromString:strTime];
    NSDate *date1= [timeFormat dateFromString:time1];
    NSDate *date2 = [timeFormat dateFromString:time2];
    NSComparisonResult result = [CurrentDate compare:date1];
    if(result == NSOrderedDescending)
    {
        NSLog(@"date1 is later than date2");
        NSComparisonResult result = [CurrentDate compare:date2];
        if(result == NSOrderedAscending)
        {
            NSLog(@"date2 is later than date1");
            BOOL isLock =[DBController getLock:15:appDelegate.UserId];
            if(isLock){
                [DBController getAchievement:15:appDelegate.UserId];
                [self.view addSubview:appDelegate.PopView];
                appDelegate.popImageView.image = [appDelegate blur:[appDelegate screenshot:self.view]];
                [appDelegate.window addSubview:appDelegate.popImageView];
                AchievementsObjects *objAchieve = [DBController getAchievementObject:15:appDelegate.UserId];
                [[appDelegate showCustomPopups:objAchieve] showInView:appDelegate.window];
            }
        }
    }
}
-(void)setFont
{
    lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize14];
    
    btn1.titleLabel.font = btn2.titleLabel.font = btn3.titleLabel.font = btn4.titleLabel.font = btn5.titleLabel.font = btn6.titleLabel.font = btn7.titleLabel.font = btn8.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize20];
    
    btnPhoto.titleLabel.font = btnVideo.titleLabel.font = btnText.titleLabel.font = [UIFont fontWithName:kHelveticaBold size:kFontSize12];
    
    lblDigit.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize20];
    lblSelectCycle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
    lblCountDown.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize90];
}
-(void)SelectImageForCapture
{
    if(player)
    {
        [player pause];
        //[player removeAllItems];
        player = [AVQueuePlayer playerWithURL:[NSURL URLWithString:@""]];
        player = nil;
    }
    [WorkoutVw bringSubviewToFront:ImgWorkout];
    ImgWorkout.hidden = FALSE;
    WorkoutsObjects *wo;
    
    if(appDelegate.isRandomizedOrder){
        int nINdex = [[myRandomNumberArray objectAtIndex:nCurrentIndex+1] intValue];
        wo = [appDelegate.arrAllWorkOuts objectAtIndex:nINdex-1];
    }
    else{
        wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex];
    }
   // NSLog(@"Image URL : %@",wo.strImageUrl);
    ImgWorkout.image = [UIImage imageNamed:wo.strImageUrl];
    lblTitle.text = wo.strTitle;
}
-(void)SelectImage
{
    if(player)
    {
        [player pause];
        //[player removeAllItems];
        player = [AVQueuePlayer playerWithURL:[NSURL URLWithString:@""]];
        player = nil;
    }
    [WorkoutVw bringSubviewToFront:ImgWorkout];
    ImgWorkout.hidden = FALSE;
    WorkoutsObjects *wo;
    
    if(appDelegate.isRandomizedOrder){
         if(nCurrentIndex>=0){
             int nINdex = [[myRandomNumberArray objectAtIndex:nCurrentIndex] intValue];
             wo = [appDelegate.arrAllWorkOuts objectAtIndex:nINdex-1];
         }
    }
    else{
        if(SelectedIndex>0)
            wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex-1];
    }
    ImgWorkout.image = [UIImage imageNamed:wo.strImageUrl];
    lblTitle.text = wo.strTitle;
}

-(void)selectVideo
{
   /*  WorkoutsObjects *wo; NSLog(@"SelectedIndex:%ld",(long)SelectedIndex);
    if(appDelegate.isRandomizedOrder){
        if(nCurrentIndex>=0){
            int nINdex = [[myRandomNumberArray objectAtIndex:nCurrentIndex] intValue];
            wo = [appDelegate.arrAllWorkOuts objectAtIndex:nINdex-1];
        }
    }else{
        if(SelectedIndex>0)
            wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex-1];
    }
    
     NSURL *GifUrl = [[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"%@",wo.strVideoUrl] withExtension:@"gif"];
    ImgWorkout.image = [UIImage animatedImageWithAnimatedGIFURL:GifUrl];
    lblTitle.text = wo.strTitle;*/
    [self playVideoRepeat];
}
-(void)itemDidFinishPlaying:(NSNotification *) notification
{
    // Will be called when AVPlayer finishes playing playerItem
    if(selected_BtnTag==502)
    {
        [self playVideoRepeat];
        //[self performSelector:@selector(playVideoRepeat) withObject:nil afterDelay:0.5];
    }
}

-(void)playVideoRepeat
{
    WorkoutsObjects *wo;
    //[self PVTBtn_click:btnVideo];
    if(SelectedIndex > TotalWorkouts)
        SelectedIndex = TotalWorkouts;
    
    if(SelectedIndex>0 && SelectedIndex<=TotalWorkouts)
        wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex-1];
    lblTitle.text = wo.strTitle;
    NSString *strVideo = wo.strVideoUrl;
    //NSLog(@"strVideo is %@",strVideo);
    NSURL * VideoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:strVideo ofType:@"mov"]];
    
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:VideoURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    if(player)
    {
        player = nil;
    }
    
    player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    //NSLog(@"%ld",(long)player.rate);
    
    AVPlayerLayer *layer = [AVPlayerLayer layer];
    
    [layer setPlayer:player];
    //    [layer setPlayer:queuePlayer];
    if(appDelegate.isIphone5)
    {
         [layer setFrame:CGRectMake(60, 63, 200, 200)];
    }
    else
    {
         [layer setFrame:CGRectMake(85, 56, 150, 150)];
    }
   
    [layer setBackgroundColor:[UIColor clearColor].CGColor];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    for(AVPlayerLayer *layer in WorkoutVw.layer.sublayers)
    {
        if([layer isKindOfClass:[AVPlayerLayer class]]){
            // [layer removeFromSuperlayer];
            [self performSelector:@selector(removelayer:) withObject:layer afterDelay:0.1];
        }
    }

    [WorkoutVw.layer addSublayer:layer];
    if(isPlay)
        [player play];
    else
        [player pause];
    
   /* player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    AVPlayerLayer *layer = [AVPlayerLayer layer];
    
    [layer setPlayer:player];
    //    [layer setPlayer:queuePlayer];
    [layer setFrame:ImgWorkout.frame];
    [layer setBackgroundColor:[UIColor clearColor].CGColor];
    
    [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
    //[view_Av removeFromSuperview];
    
    for(AVPlayerLayer *layer in view_Av.layer.sublayers)
    {
        if([layer isKindOfClass:[AVPlayerLayer class]]){
            // [layer removeFromSuperlayer];
            [self performSelector:@selector(removelayer:) withObject:layer afterDelay:0.1];
        }
    }
    [view_Av.layer addSublayer:layer];
    [self.view addSubview:view_Av];
    
    //[WorkoutVw.layer addSublayer:layer];
    
    [player play];*/
}
-(void)removelayer:(AVPlayerLayer*)layer
{
    [layer removeFromSuperlayer];
}

-(void)SetStepsRelatedIndex
{
    if(player)
    {
        [player pause];
        //[player removeAllItems];
        player = [AVQueuePlayer playerWithURL:[NSURL URLWithString:@""]];
        player = nil;
    }
    [WorkoutVw bringSubviewToFront:ImgWorkout];
    [WorkoutVw bringSubviewToFront:txtSteps];

    WorkoutsObjects *wo;
    if(appDelegate.isRandomizedOrder){
        if(nCurrentIndex>=0){
            int nINdex = [[myRandomNumberArray objectAtIndex:nCurrentIndex] intValue];
            wo = [appDelegate.arrAllWorkOuts objectAtIndex:nINdex-1];
        }
    }else{
        if(SelectedIndex>0)
            wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex-1];
    }
    strDesplayStrings = wo.strSteps;
    lblTitle.text = wo.strTitle;
}
-(void)setAllTime
{
    NSString *strDuration;
    strDuration = [[NSUserDefaults standardUserDefaults] objectForKey:@"RestBetweenCycle"];
    strDuration = [strDuration stringByReplacingOccurrencesOfString:@"S" withString:@""];
    if(appDelegate.isCountDownEnable)
        RestDuration = [strDuration integerValue];
    else
        RestDuration = 0;
    
    strDuration = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExcerciseDuration"];
    strDuration = [strDuration stringByReplacingOccurrencesOfString:@"S" withString:@""];
    ExcerciseDuration = [strDuration integerValue];
    
    strDuration = [[NSUserDefaults standardUserDefaults] objectForKey:@"RestDuration"];
    strDuration = [strDuration stringByReplacingOccurrencesOfString:@"S" withString:@""];
    if(appDelegate.isCountDownEnable)
        RestBetweenCycle = [strDuration integerValue];
    else
        RestBetweenCycle = 0;
    
    restTime = RestDuration+1;
    timerCountDown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(CountDown) userInfo:nil repeats:NO];
}
/*-(void)setAllTime
{
    NSString *strDuration;
    strDuration = [[NSUserDefaults standardUserDefaults] objectForKey:@"RestDuration"];
    strDuration = [strDuration stringByReplacingOccurrencesOfString:@"S" withString:@""];
    if(appDelegate.isCountDownEnable)
        RestDuration = [strDuration integerValue];
    else
        RestDuration = 0;

    strDuration = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExcerciseDuration"];
    strDuration = [strDuration stringByReplacingOccurrencesOfString:@"S" withString:@""];
    ExcerciseDuration = [strDuration integerValue];

    strDuration = [[NSUserDefaults standardUserDefaults] objectForKey:@"RestBetweenCycle"];
    strDuration = [strDuration stringByReplacingOccurrencesOfString:@"S" withString:@""];
    if(appDelegate.isCountDownEnable)
        RestBetweenCycle = [strDuration integerValue];
    else
        RestBetweenCycle = 0;
    
    restTime = RestDuration+1;
    timerCountDown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(CountDown) userInfo:nil repeats:NO];
}
*/
-(void)CountDown
{
    if(restTime == 1){
        if(isNeedtoRemoveCircle){
            [self removeCircle];
            isNeedtoRemoveCircle = FALSE;
        }
        timerCountDown = nil;
        RestVw.hidden = TRUE;  isRestRunning = true;
        countDownTime = ExcerciseDuration+1;
        if(appDelegate.isRandomizedOrder){
            nCurrentIndex++;
            SelectedIndex = [[myRandomNumberArray objectAtIndex:nCurrentIndex]intValue];
        }
        else{
            SelectedIndex++;
        }
        
        [self PVTBtn_click:btnVideo];
        imgBlur.image = nil;
        timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ExcerciseCountDown) userInfo:nil repeats:NO];
    }
    else{
        if(isPlay){
            if(restTime == RestBetweenCycle)
            {
                if(isStartUp)
                {
                    isStopedAudioPlayer = FALSE; isStartUp = FALSE;
                    [self textToSpeech:@"Began"];
                    if(appDelegate.isRandomizedOrder){
                        [self textToSpeech:@"Next Up"];
                         SelectedIndex = [[myRandomNumberArray objectAtIndex:nCurrentIndex+1]intValue];
                        [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
                    }else{
                        [self textToSpeech:@"Next Up"];
                        [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
                    }
                }
                //====== Change Image & Nav Layout
                WorkoutsObjects *wo;
                if(appDelegate.isRandomizedOrder){
                    wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex-1];
                    NSURL *GifUrl = [[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"%@",wo.strVideoUrl] withExtension:@"gif"];
                    ImgWorkout.image = [UIImage animatedImageWithAnimatedGIFURL:GifUrl];
                    lblTitle.text = wo.strTitle;
                }else{
                    wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex];
                     NSURL *GifUrl = [[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"%@",wo.strVideoUrl] withExtension:@"gif"];
                    ImgWorkout.image = [UIImage animatedImageWithAnimatedGIFURL:GifUrl];
                    lblTitle.text = wo.strTitle;
                }
            }
//            CurrentRestRadius+= everyRestBetweenCycleRadious; // ====== RestCircle Animation
            if(globalRestCycle==0)
                globalRestCycle = restTime;
           // CurrentRestRadius+= TotalRadious/(globalRestCycle-2);
            if(!isCircleRunning)
                [self circleRestBetweenCycleAnimation];
            restTime--;
            if(restTime==3){
                [self textToSpeech:[NSString stringWithFormat:@"%ld",(long)restTime]];
            }else if (restTime==2){
                [self textToSpeech:[NSString stringWithFormat:@"%ld",(long)restTime]];
            }else if (restTime==1){
                [self textToSpeech:[NSString stringWithFormat:@"%ld",(long)restTime]];
                if(appDelegate.isRandomizedOrder){
                    SelectedIndex = [[myRandomNumberArray objectAtIndex:nCurrentIndex+1]intValue];
                    [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
                }else{
                    [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
                }
                preventVw.frame = CGRectMake(0, 570, preventVw.frame.size.width, preventVw.frame.size.height);
                
                [self performSelector:@selector(removeRestCircle) withObject:nil afterDelay:0.1];
            }
            lblCountDown.text = [NSString stringWithFormat:@"%ld", (long)restTime];
            timerCountDown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(CountDown) userInfo:nil repeats:NO];
        }
    }
}
-(void)ExcerciseCountDown
{
    if(countDownTime == 1){
        /// Circla Animation
        CurrentRadious+= everyCycleRadious;
        [self circleAnimation];
        RestVw.hidden = FALSE; isRestRunning = false;
//        Waiting time
        timerCountDown = nil;
        restTime = RestBetweenCycle+1;
        lblDigit.text = @"0";
        
        int nNo = 0;
        if(nCurrentIndex< TotalWorkouts-1)
            nNo = [[myRandomNumberArray objectAtIndex:nCurrentIndex+1]intValue];
        else if (nCurrentIndex>= TotalWorkouts-1)
            nNo = TotalWorkouts+1;
        
        if((appDelegate.isRandomizedOrder ? nNo-1:SelectedIndex) < TotalWorkouts){
            PercentComplete++;
           
            imgBlur.image = nil;lblCountDown.text = @"";
            
            [self setCapturedImage];
           
            timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(CountDown) userInfo:nil repeats:NO];
        }
        else{
            if(CurrentCycle >= SelectedCycleIndex){
                SelectedIndex = 1; nCurrentIndex = 0;
                CurrentRadious = -1.59;
                StartRadious = -1.60;
                isNeedtoRemoveCircle = TRUE;
                PercentComplete++;
                CurrentCycle++;
                CircuitComplete++;
                isStopedAudioPlayer = TRUE;
                [self PVTBtn_click:btnVideo];
                RestVw.hidden = FALSE;
                lblCountDown.text = @"";
                timerCountDown = nil;
                //====== Complete Cycle =====//
                if(StartRadious >= (TotalWorkouts-1)*0.45-1.60)
                {
                     startVw.hidden = FALSE;
                    [self CalculateAndSaveWorkouts];
                    [self getInRowsAchievements];
                    [appDelegate.audioPlayer stop];
                  //  isStopedAudioPlayer = TRUE;

                    ResultViewController *objResultController = [[ResultViewController alloc]initWithNibName:@"ResultViewController" bundle:nil];
                    objResultController.isCycleComplete = TRUE;
                    [self.navigationController pushViewController:objResultController animated:YES];
                }else{
                    SelectedIndex = 0; nCurrentIndex=-1;
                    RestVw.hidden = FALSE;
                    btnNext.enabled = FALSE;
                   // isStopedAudioPlayer = TRUE;
                    //-----
                     isPlay = TRUE;
                     btnNext.hidden = TRUE; btnPrevious.hidden = TRUE; imgNextBG.hidden = TRUE;
                     [btnPlayPause setImage:[UIImage imageNamed:@"SW_pause.png"] forState:UIControlStateNormal];
                    //------
                    
                    lblCountDown.text = @"";
                    lblDigit.text = @"0";
                    CurrentCycle = 1;
                    [timerCountDown invalidate];
                    imgBlur.image = nil;
                    
                     [self setCapturedImage];
                     startVw.hidden = FALSE;
                }
            }
            else{
                CurrentRadious = -1.59;
                StartRadious = -1.60;
                isNeedtoRemoveCircle = TRUE;
                PercentComplete++;
                CurrentCycle++;
                CircuitComplete++;
                SelectedIndex = 0; nCurrentIndex = -1;
                restTime = RestDuration+1;
                timerCountDown = nil; [timerCountDown invalidate]; lblCountDown.text = @"";
                [self CalculateAndSaveWorkouts];
                [self setCapturedImage];
                TotalPauses = 0; PercentComplete = 0;
                timerCountDown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(CountDown) userInfo:nil repeats:NO];
               /* CurrentRestRadius+= everyRestBetweenCycleRadious; // ====== RestBetweenCycleCircle Animation
                [self circleRestBetweenCycleAnimation];*/
            }
        }
        if(appDelegate.isRandomizedOrder){
            [self textToSpeech:@"Next Up"];
            SelectedIndex = [[myRandomNumberArray objectAtIndex:nCurrentIndex+1]intValue];
            [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
        }else{
            [self textToSpeech:@"Next Up"];
            [self performSelector:@selector(speakExcerciseName:) withObject:[NSString stringWithFormat:@"%ld",(long)SelectedIndex] afterDelay:1.0];
        }
    }
    else{
        if(isPlay){
            countDownTime--;
            if(ExcerciseDuration/2 == countDownTime){
                [self textToSpeech:@"HalfWay There"];
            }
            
            if(countDownTime==3){
                [self textToSpeech:[NSString stringWithFormat:@"%ld",(long)countDownTime]];
            }else if (countDownTime==2){
                [self textToSpeech:[NSString stringWithFormat:@"%ld",(long)countDownTime]];
            }else if (countDownTime==1){
                [self textToSpeech:[NSString stringWithFormat:@"%ld",(long)countDownTime]];
                [self textToSpeech:@"Rest"];
            }
            
            lblDigit.text = [NSString stringWithFormat:@"%ld", (long)countDownTime];
            timerCountDown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ExcerciseCountDown) userInfo:nil repeats:NO];
        }
    }
}

-(void)setCapturedImage
{
    [appDelegate hideAds];
    if(imgBlur.image == nil){
       
        [self SelectImageForCapture];
        imgBlur.image = [self blur:[self screenshot]];
    }
    
    if(!appDelegate.isAdRemoved)
        [appDelegate ShowAds];
}

-(void)accessoryClick:(UIButton *)btn
{
    if(btn.tag == 702){
        
        if(isPurchaseAdvanceWorkout){
            [btn setSelected:true];
            nSelectedWorkoutType = btn.tag - 700;
            [self performSelector:@selector(btnDone_click) withObject:nil afterDelay:0.1];
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you want to buy AdvanceWorkouts?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Buy Now", @"Restore", nil];
            
            actionSheet.tag = 201;
            actionSheet.delegate = self;
            [actionSheet showInView:appDelegate.window];
        }
        
    }else if (btn.tag == 703){
        
        if(isPurchaseButtWorkout){
            [btn setSelected:true];
            nSelectedWorkoutType = btn.tag - 700;
            [self performSelector:@selector(btnDone_click) withObject:nil afterDelay:0.1];
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you want to buy ButtWorkouts?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Buy Now", @"Restore", nil];
            actionSheet.tag = 203;
            actionSheet.delegate = self;
            [actionSheet showInView:appDelegate.window];
        }
    }else if (btn.tag == 704){
        
        if(isPurchaseExpertsWorkout){
            [btn setSelected:true];
            nSelectedWorkoutType = btn.tag - 700;
            [self performSelector:@selector(btnDone_click) withObject:nil afterDelay:0.1];
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you want to buy ExpertWorkouts?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Buy Now", @"Restore", nil];
            actionSheet.tag = 202;
            actionSheet.delegate = self;
            [actionSheet showInView:appDelegate.window];
        }
    }else if (btn.tag == 705){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you want to buy AllWorkouts?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Buy Now", @"Restore", nil];
        actionSheet.tag = 204;
        actionSheet.delegate = self;
        [actionSheet showInView:appDelegate.window];
    }
    else{
        [btn setSelected:true];
        nSelectedWorkoutType = btn.tag - 700;
        [self performSelector:@selector(btnDone_click) withObject:nil afterDelay:0.1];
    }
    
   
 //   [self btnDone_click];
}
#pragma mark - Draw Circle -

#define SHKdegreesToRadians(x) (M_PI * x / 180.0)

-(void)circleAnimation
{
    int radius = 39;
    
    circle = [CAShapeLayer layer];
    
//    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:radius startAngle:SHKdegreesToRadians(-90) endAngle:SHKdegreesToRadians(270) clockwise:YES].CGPath;

    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:radius startAngle:StartRadious endAngle:CurrentRadious clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    
    circle.strokeColor = [UIColor colorWithRed:16.0f/255.0f green:145.0f/255.0f blue:141.0f/255.0f alpha:1.0f].CGColor;
    circle.lineWidth = 10;
    
    // Add to parent layer
    [finishedCycleVw.layer addSublayer:circle];
    
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
    StartRadious+=everyCycleRadious;
}
-(void)circleRestDurationAnimation
{
    int radius = 65;
    
    restCircle = [CAShapeLayer layer];
    
    //    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:radius startAngle:SHKdegreesToRadians(-90) endAngle:SHKdegreesToRadians(270) clockwise:YES].CGPath;
    
    restCircle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:radius startAngle:StartRestRadius endAngle:CurrentRestRadius clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    restCircle.fillColor = [UIColor clearColor].CGColor;
    
    restCircle.strokeColor = [UIColor whiteColor].CGColor;
    restCircle.lineWidth = 3;
    
    // Add to parent layer
    [restCycleVw.layer addSublayer:restCircle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 1.12; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.removedOnCompletion = YES;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [restCircle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
//    StartRestRadius+=everyRestRadious;
    StartRestRadius+=TotalRadious/restTime;
}

-(void)circleRestBetweenCycleAnimation
{
    int radius = 65;
    restCircle = [CAShapeLayer layer];
    
    restCircle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:radius startAngle:StartRestRadius endAngle:5.40 clockwise:YES].CGPath;   //5.40
    
    // Configure the apperence of the circle
    restCircle.fillColor = [UIColor clearColor].CGColor;
    
    restCircle.strokeColor = [UIColor whiteColor].CGColor;
    restCircle.lineWidth = 3;
    // Add to parent layer

    [restCycleVw.layer addSublayer:restCircle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if(isPlay)
        drawAnimation.duration = restTime-1.2; // "animate over 10 seconds or so.."
    else{
        //[restCircle removeAnimationForKey:@"drawCircleAnimation"];
    }
    // "animate over 10 seconds or so.."
    drawAnimation.repeatCount  = 1.0;  // Animate only once..
    drawAnimation.removedOnCompletion = YES;   // Remain stroked after the animation..
    
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
   // drawAnimation.timingFunction = nil;
    
    // Add the animation to the circle
    [restCircle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];

//    StartRestRadius+=everyRestBetweenCycleRadious;
  // StartRestRadius+=TotalRadious/(globalRestCycle-2);
    isCircleRunning = TRUE;
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}
-(void)removeCircle
{
    for(CAShapeLayer *Shape in finishedCycleVw.layer.sublayers){
        Shape.strokeColor = [UIColor clearColor].CGColor;
    }
}
-(void)removeRestCircle
{
    //NSLog(@"Layers:%@",restCycleVw.layer.sublayers);
    for(CAShapeLayer *Shape in restCycleVw.layer.sublayers){
//        Shape.strokeColor = [UIColor clearColor].CGColor;
        [Shape removeFromSuperlayer];
    }
    CurrentRestRadius = -1.59;
    StartRestRadius = -1.60;
    globalRestCycle = 0;
    isCircleRunning = FALSE;
}
-(void)ClearCircle
{
   // NSLog(@"Layers:%@",restCycleVw.layer.sublayers);
    for(CAShapeLayer *Shape in restCycleVw.layer.sublayers){
       [Shape removeFromSuperlayer];
    }
  // StartRestRadius = TotalRadious/restTime;
    [self circleRestBetweenCycleAnimation];
}

#pragma mark - In App Purchase -

#pragma mark - Upgrade
-(void)BuyAdvancedWorkout
{
    NSString *productId;
    productId = INAPP_PRODUCT_AdvancedWorkout;
    appDelegate.SelectedPurchaseType=1;
    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}
-(void)restoreAdvancedWorkout
{
    NSString *productId;
    productId = INAPP_PRODUCT_AdvancedWorkout;
    appDelegate.SelectedPurchaseType=1;
    [[InAppRageIAPHelper sharedHelper] restoreProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}

-(void)BuyExpertsWorkout
{
    NSString *productId;
    productId = INAPP_PRODUCT_ExpertsWorkout;
    appDelegate.SelectedPurchaseType=2;
    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}
-(void)restoreExpertsWorkout
{
    NSString *productId;
    productId = INAPP_PRODUCT_ExpertsWorkout;
    appDelegate.SelectedPurchaseType=2;
    [[InAppRageIAPHelper sharedHelper] restoreProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}

-(void)BuyButtWorkout
{
    NSString *productId;
    productId = INAPP_PRODUCT_ButtWorkouts;
    appDelegate.SelectedPurchaseType=3;
    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}
-(void)restoreButtWorkout
{
    NSString *productId;
    productId = INAPP_PRODUCT_ButtWorkouts;
    appDelegate.SelectedPurchaseType=3;
    [[InAppRageIAPHelper sharedHelper] restoreProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}

-(void)BuyAllWorkouts
{
    NSString *productId;
    productId = INAPP_PRODUCT_AllWorkout;
    appDelegate.SelectedPurchaseType=5;
    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}
-(void)restoreAllWorkouts
{
    NSString *productId;
    productId = INAPP_PRODUCT_AllWorkout;
    appDelegate.SelectedPurchaseType=5;
    [[InAppRageIAPHelper sharedHelper] restoreProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}

#pragma mark - Set Observers
-(void)setCustomObservers
{
//    if ([InAppRageIAPHelper sharedHelper].products == nil)
//    {
//        [[InAppRageIAPHelper sharedHelper] requestProducts];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreFailed:) name:kProductRestoreFailed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchased:) name:kProductPurchasedforAdvancedWorkout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasedFailed:) name:kProductPurchasedFailedforAdvancedWorkout object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccesforExperts:) name:kProductPurchasedforExpertsWorkout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasedFailedforExperts:) name:kProductPurchasedFailedforExpertsWorkout object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccesforButt:) name:kProductPurchasedforButtWorkout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasedFailedforButt:) name:kProductPurchasedFailedforButtWorkout object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccesforAll:) name:kProductPurchasedforAllWorkout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasedFailedforAll:) name:kProductPurchasedFailedforAllWorkout object:nil];
}

#pragma mark - InApp
- (void)productsLoaded:(NSNotification *)notification
{
    NSLog(@"Products Loaded...");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)restoreFailed:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [appDelegate HideActivity];
}

#pragma mark -

-(void)purchased:(NSNotification *)notify
{
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:isPurchased])
//    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
     //   [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isPurchased];
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseAdvanceWorkout"];
        isPurchaseAdvanceWorkout = TRUE;
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([InAppRageIAPHelper sharedHelper].isRestored)
        {
            [self showAlert:@"Restored Successfully."];
        }
        else
        {
            [self showAlert:@"Purchased Successfully."];
        }
        [tblViewWorkoutSelect reloadData];
        [appDelegate HideActivity];
    //}
   // [appDelegate HideActivity];
}

-(void)purchasedFailed:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notify.object;
    if (transaction.error.code != SKErrorPaymentCancelled){
        [self showAlert:@"Purchased Failed!!!"];
    }
    [appDelegate HideActivity];
}

-(void)purchaseSuccesforExperts:(NSNotification *)notify
{
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:isPurchased])
//    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
      //  [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isPurchased];
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseExpertsWorkout"];
        isPurchaseExpertsWorkout = TRUE;
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([InAppRageIAPHelper sharedHelper].isRestored)
        {
            [self showAlert:@"Restored Successfully."];
        }
        else
        {
            [self showAlert:@"Purchased Successfully."];
        }
        [tblViewWorkoutSelect reloadData];
        [appDelegate HideActivity];
        //        [self reloadView];
   // }
    [appDelegate HideActivity];
}

-(void)purchasedFailedforExperts:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notify.object;
    if (transaction.error.code != SKErrorPaymentCancelled){
        [self showAlert:@"Purchased Failed!!!"];
    }
    [appDelegate HideActivity];
}

-(void)purchaseSuccesforButt:(NSNotification *)notify
{
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:isPurchased])
//    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        //[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isPurchased];
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseButtWorkout"];
        isPurchaseButtWorkout = TRUE;
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([InAppRageIAPHelper sharedHelper].isRestored)
        {
            [self showAlert:@"Restored Successfully."];
        }
        else
        {
            [self showAlert:@"Purchased Successfully."];
        }
        [tblViewWorkoutSelect reloadData];
        [appDelegate HideActivity];
        //        [self reloadView];
   // }
    [appDelegate HideActivity];
}

-(void)purchasedFailedforButt:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notify.object;
    if (transaction.error.code != SKErrorPaymentCancelled){
        [self showAlert:@"Purchased Failed!!!"];
    }
    [appDelegate HideActivity];
}
-(void)purchaseSuccesforAll:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isPurchased];
    [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseAllWorkout"];
    [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseButtWorkout"];
    [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseExpertsWorkout"];
    [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseAdvanceWorkout"];
    
    isPurchaseAllWorkout = TRUE;
    isPurchaseAdvanceWorkout = TRUE;
    isPurchaseButtWorkout = TRUE;
    isPurchaseExpertsWorkout = TRUE;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    if([InAppRageIAPHelper sharedHelper].isRestored)
    {
        [self showAlert:@"Restored Successfully."];
    }
    else
    {
        [self showAlert:@"Purchased Successfully."];
    }
     arrWorkoutTypes = [[NSMutableArray alloc]initWithObjects:@"DEFAULT WORKOUTS",@"ADVANCE WORKOUTS",@"BUTT WORKOUTS",@"EXPERT WORKOUTS", nil];
    [tblViewWorkoutSelect reloadData];
    [appDelegate HideActivity];
}
-(void)purchasedFailedforAll:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notify.object;
    if (transaction.error.code != SKErrorPaymentCancelled){
        [self showAlert:@"Purchased Failed!!!"];
    }
    [appDelegate HideActivity];
}
-(void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appTitle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 201){
        if(buttonIndex == 0){
            [self BuyAdvancedWorkout];
        }
        else if (buttonIndex == 1){
            [self restoreAdvancedWorkout];
        }
    }
    else if(actionSheet.tag == 202){
        if(buttonIndex == 0){
            [self BuyExpertsWorkout];
        }
        else if (buttonIndex == 1){
            [self restoreExpertsWorkout];
        }
    }else if (actionSheet.tag == 203){
        if(buttonIndex == 0){
            [self BuyButtWorkout];
        }
        else if (buttonIndex == 1){
            [self restoreButtWorkout];
        }
    }else if (actionSheet.tag == 204){
        if(buttonIndex == 0){
            [self BuyAllWorkouts];
        }else{
            [self restoreAllWorkouts];
        }
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
