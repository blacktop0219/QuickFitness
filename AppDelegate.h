//
//  AppDelegate.h
//  QuickFitness
//
//  Created by Ashish Sudra on 01/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIdbConfig.h"
#import "DQAlertView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AchievementsObjects.h"
#import "navController.h"

#import <FacebookSDK/FacebookSDK.h>

//====== AdMob
//#import "GADRequest.h"
//#import "GADBannerView.h"

//======== IAd
#import <iAd/iAd.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,ADBannerViewDelegate>
{
    UIButton *btnRemoveAd;
}

@property (nonatomic,strong) UIButton *btnRemoveAd, *btnHideAd;
//@property (retain,nonatomic) GADBannerView *adBanner;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) navController *navCntrlr;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;

@property (nonatomic) BOOL isFirstTimeShowAnimation;
@property (nonatomic, strong) NSString *CurrentSwitchName;
@property (nonatomic,strong)  UIView *PopView;
@property (nonatomic,strong)  UIImageView *popImageView;

@property int UserId;
@property (nonatomic, readwrite) int SelectedPurchaseType;//InApp
@property (nonatomic) BOOL isPurchaseAdvanceWorkout; //InApp
@property (nonatomic) BOOL isPurchaseExpertsWorkout; //InApp
@property (nonatomic) BOOL isPurchaseButtWorkout; //InApp
@property (nonatomic) BOOL isAdRemoved; //InApp

@property (nonatomic, strong) NSMutableArray *arrAllWorkOuts;  /// All Workouts are in this array.
@property (nonatomic,readwrite) BOOL isIphone5;
@property (nonatomic,readwrite) BOOL isVoiceEnable,isCountDownEnable,isRandomizedOrder,isCloudEnable;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;  /// For Play Background Music
@property (nonatomic) BOOL isFacebookAuthenticate;

@property (strong, nonatomic) FBSession *session;
@property id delega;

//---------- IAd
@property BOOL isbannerIsVisible, isResignActive;
@property (nonatomic,retain) ADBannerView *adBanner;
//----------

@property (nonatomic, readwrite) int SelectedBtnType;
@property (nonatomic, strong) NSMutableArray *arrButtWorkOuts;
@property (nonatomic, strong) NSMutableArray *arrExpertSeriesWorkOuts;
@property (nonatomic, strong) NSMutableArray *arrIntermidiateWorkOuts;
-(void)ShowActivity:(NSString*)str;
-(void)HideActivity;
-(void)alertMessage: (NSString *)strMessage;
-(DQAlertView *)showCustomPopups :(AchievementsObjects *)objAchieve;
-(void)hideAds;-(void)ShowAds;
//- (GADRequest *)createRequest;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

-(UIImage *) screenshot : (UIView *)selfView;
- (UIImage*) blur:(UIImage*)theImage;

@end
