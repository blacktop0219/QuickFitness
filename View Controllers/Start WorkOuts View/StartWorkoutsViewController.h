//
//  StartWorkoutsViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGSwitch.h"
#import <AVFoundation/AVFoundation.h>
#import "SongListViewController.h"
#import <QuartzCore/QuartzCore.h>

@class ResultViewController;

@interface StartWorkoutsViewController : UIViewController <AVAudioPlayerDelegate,AVSpeechSynthesizerDelegate,UIActionSheetDelegate>
{
    SongListViewController *objSongListViewController;
    
    IBOutlet UIView *startVw, *vWBlur;
    IBOutlet UIImageView *imgBlur;
    IBOutlet UIView *RestVw;
    IBOutlet UIView *finishedCycleVw,*restCycleVw, *preventVw;
    IBOutlet UIButton *btn1,*btn2,*btn3,*btn4,*btn5,*btn6,*btn7,*btn8;
    
    IBOutlet UIButton *btnPhoto, *btnVideo, *btnText;
    IBOutlet UIButton *btnPlayPause, *btnNext, *btnPrevious;
    IBOutlet UIImageView  *imgText, *imgNextBG;
    
    IBOutlet UILabel *lblSelectCycle;
    IBOutlet UILabel *lblDigit;
    IBOutlet UILabel *lblTitle;
    
    IBOutlet UIImageView *ImgWorkout, *imgSelectionType;
    IBOutlet UITextView *txtSteps;
    
    NSInteger SelectedIndex, TotalWorkouts, nCurrentIndex;
    NSString *strDesplayStrings;
    
    NSInteger RestDuration, ExcerciseDuration, RestBetweenCycle;
    NSInteger countDownTime, restTime;
    NSInteger SelectedCycleIndex;
    NSInteger CurrentCycle;
    NSInteger globalRestCycle;
    NSMutableArray *myRandomNumberArray;
    
    IBOutlet UILabel *lblCountDown;
    NSTimer *timerCountDown;
    int nGetAchieve;
    
    BOOL isPlay ,isStopedAudioPlayer, isMusicLaunch, isRest;
    
    NSString *strStartTime;
    NSInteger CircuitComplete;
    NSInteger PercentComplete;
    NSInteger TotalPauses;
    
    float TotalRadious;
    float everyCycleRadious, everyRestRadious, everyRestBetweenCycleRadious;
    float CurrentRadious, CurrentRestRadius;
    float StartRadious, StartRestRadius;
    BOOL isNeedtoRemoveCircle;
    BOOL isCircleRunning;
    
    CAShapeLayer *circle, *restCircle; //// for Circle Draw Animation
    
    
     AVPlayer* player;
    int selected_BtnTag;
    IBOutlet UIView *WorkoutVw;
     UIView *view_Av;
    
    IBOutlet UIView *selectWorkoutVw;
    IBOutlet UITableView *tblViewWorkoutSelect;
    IBOutlet UIButton *btnDone;
    NSMutableArray *arrWorkoutTypes;
    int nSelectedWorkoutType;
    
    
    BOOL isPurchaseAdvanceWorkout;
    BOOL isPurchaseExpertsWorkout;
    BOOL isPurchaseButtWorkout;
    BOOL isPurchaseAllWorkout;
    BOOL isStartUp;
}

@property (nonatomic,strong) UIButton *btnVideo;
@property (nonatomic,strong) UIView *startVw;
@property (nonatomic,readwrite) BOOL isRestRunning;
@property (nonatomic,strong) UserInfo *objUserInfo;
@property (nonatomic, strong) IBOutlet DGSwitch *mySwitch;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@property (nonatomic) BOOL isPlay;

-(IBAction)startBtn_click:(id)sender;
-(IBAction)btn_Click:(id)sender;
-(IBAction)PVTBtn_click:(id)sender;
-(IBAction)backBtn_click:(id)sender;
-(IBAction) onChange:(DGSwitch *)theSwitch;

-(IBAction)restartBtn_click:(id)sender;
-(IBAction)stopBtn_click:(id)sender;
-(IBAction)playPauseBtn_click:(id)sender;
-(IBAction)nextBtn_click:(id)sender;
-(IBAction)previousBtn_click:(id)sender;
-(IBAction)restTimePause:(id)sender;

-(IBAction)setMusicBtn_click:(id)sender;

-(void)playVideoRepeat;
-(void)ClearCircle;

@end
