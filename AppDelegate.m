//
//  AppDelegate.m
//  QuickFitness
//
//  Created by Ashish Sudra on 01/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "ResultViewController.h"

#import "WorkoutsObjects.h"
#import "SVProgressHUD.h"
#import "DQAlertView.h"
#import "StartWorkoutsViewController.h"

//InApp starts...
#import "InAppRageIAPHelper.h"
//InApp ends.
#import "Appirater.h"

NSString * sampleTitle = @"Title";
NSString * shortSampleMessage = @"Hello World!";
NSString * sampleMessage = @"The quick brown fox jumps over the lazy dog.";
NSString * longSampleMessage = @"Yesterday, all my troubles seemed so far away. Now it looks as though they're here to stay. Oh, I believe in yesterday. Suddenly I'm not half the man I used to be. There's a shadow hanging over me. Oh, yesterday came suddenly.";

@interface AppDelegate () <DQAlertViewDelegate>

@end

#define kSampleAdUnitID @"ca-app-pub-8493144932677429/4393446991" //a1533bf143335c6
NSString *const SCSessionStateChangedNotification = @"com.facebook.Scrumptious:SCSessionStateChangedNotification";
#define kFBSharingForAllImage @"sharingWithFBForAllImage"

@implementation AppDelegate

@synthesize btnRemoveAd,btnHideAd;
@synthesize isAdRemoved;
@synthesize isResignActive;
@synthesize navCntrlr;
@synthesize isFirstTimeShowAnimation;
@synthesize isIphone5,isVoiceEnable,isCountDownEnable,isRandomizedOrder,isCloudEnable;
@synthesize PopView,popImageView;
@synthesize musicPlayer;
@synthesize SelectedPurchaseType;//InApp
@synthesize arrAllWorkOuts,arrButtWorkOuts,arrExpertSeriesWorkOuts,arrIntermidiateWorkOuts; /// All Workouts are in this array.
@synthesize audioPlayer,UserId;
//@synthesize adBanner;
@synthesize isFacebookAuthenticate;
@synthesize delega;
@synthesize SelectedBtnType;

@synthesize adBanner, isbannerIsVisible;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:2];
    [self CommonMethods];
    
    //-------- Audion Configuration ------//
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    //-------- Audion Configuration -------//

    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    if([UIScreen mainScreen].bounds.size.height==568)
        isIphone5 = true;
     else
         isIphone5 = false;
    
    [Appirater appLaunched:YES];
    BOOL AppLoad = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoadAppSecondTime"];
    if(!AppLoad)
    {
        [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"VoiceOver"];
        [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"CountDown"];
        [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:@"iCloud"];
        [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:@"Randomize"];
        [[NSUserDefaults standardUserDefaults]setObject:@"MenSound" forKey:@"SoundType"];
        [[NSUserDefaults standardUserDefaults]setObject:@"MenModel" forKey:@"ModelType"];
    }
    isVoiceEnable = [[NSUserDefaults standardUserDefaults]boolForKey:@"VoiceOver"];
    isCountDownEnable = [[NSUserDefaults standardUserDefaults]boolForKey:@"CountDown"];
    isRandomizedOrder = [[NSUserDefaults standardUserDefaults]boolForKey:@"Randomize"];
    isCloudEnable = [[NSUserDefaults standardUserDefaults]boolForKey:@"iCloud"];
    isAdRemoved = [[NSUserDefaults standardUserDefaults]boolForKey:@"isAdRemoved"];

    NSString *strDay = [[NSUserDefaults standardUserDefaults]objectForKey:@"Notification"];
    NSInteger strHour = [[NSUserDefaults standardUserDefaults]integerForKey:@"Hour"];
    NSInteger strMin =[[NSUserDefaults standardUserDefaults]integerForKey:@"MIN"];
    NSString *strAmPm = [[NSUserDefaults standardUserDefaults]objectForKey:@"AMPM"];
    
    if(strDay.length == 0){
        [[NSUserDefaults standardUserDefaults]setObject:@"EveryDay" forKey:@"Notification"];
    }
    if(strHour == 0){
        [[NSUserDefaults standardUserDefaults]setInteger:8 forKey:@"Hour"];
    }
    if(strMin == 0){
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"MIN"];
    }
    if(strAmPm.length == 0){
        [[NSUserDefaults standardUserDefaults]setObject:@"AM" forKey:@"AMPM"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemovedAds:) name:kProductPurchasedforRemoveAds object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemovedAdsFailed:) name:kProductFailedforRemoveAds object:nil];

    
//    if([[NSUserDefaults standardUserDefaults]boolForKey:@"FBAUTH"])
//        isFacebookAuthenticate = YES;
//    else
//        isFacebookAuthenticate = NO;
    
   /* if (![self openSessionWithAllowLoginUI:NO]) // Facebook Integration
    {
        isFacebookAuthenticate = NO;
    }
    else
    {
        isFacebookAuthenticate = YES;
    }*/

  // AppLoad = FALSE;
    
    UserId = [[NSUserDefaults standardUserDefaults]integerForKey:@"USERID"];
    
    if(AppLoad){
        
        if(isIphone5){
            HomeViewController *objHomeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            navCntrlr = [[navController  alloc] initWithRootViewController:objHomeViewController];
        }else{
            HomeViewController *objHomeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController_i4" bundle:nil];
            navCntrlr = [[navController alloc] initWithRootViewController:objHomeViewController];
        }
    }
    else{
        if(isIphone5)
        {
            ProfileViewController *objProfileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            navCntrlr = [[navController alloc] initWithRootViewController:objProfileViewController];
        }else
        {
            ProfileViewController *objProfileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController_i4" bundle:nil];
            navCntrlr = [[navController alloc] initWithRootViewController:objProfileViewController];
        }
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    
    //=================== Admob IMplement ===============///
    CGPoint origin;
//    origin  = CGPointMake(0.0,
//                          self.window.frame.size.height -
//                          CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    // Use predefined GADAdSize constants to define the GADBannerView.
 /*   self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner
                                                   origin:origin];
    self.adBanner.adUnitID = kSampleAdUnitID;
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:navCntrlr];
    self.adBanner.center =
    CGPointMake(self.window.center.x, self.adBanner.center.y);
    [self.adBanner loadRequest:[self createRequest]]; */

    //-----------iAd
    adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.window.frame.size.height, 320, 50)];
    adBanner.delegate = self;
    
    origin = CGPointMake(0.0, self.window.frame.size.height-50);
    //----- Hide Button
    btnHideAd = [[UIButton alloc]initWithFrame:CGRectMake(0, origin.y-15, 50, 20)];
    [btnHideAd setTitle:@"Hide Ad" forState:UIControlStateNormal];
    [btnHideAd.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btnHideAd addTarget:self action:@selector(hideAds) forControlEvents:UIControlEventTouchUpInside];
    
    //------ Remove button
    btnRemoveAd = [[UIButton alloc]initWithFrame:CGRectMake(250, origin.y-15, 70, 20)];
   // [btnRemoveAd setImage:[UIImage imageNamed:@"close.png"]];
    [btnRemoveAd setTitle:@"Remove Ad" forState:UIControlStateNormal];
    [btnRemoveAd.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btnRemoveAd addTarget:self action:@selector(removeAds) forControlEvents:UIControlEventTouchUpInside];
    //    [self languageSelectedStringForKey:@"AppleLanguages"];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID
    // before compiling.

    if(isAdRemoved)
        [self hideAds];
    // ============  Global View =============== ///
    PopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height)];
    PopView.backgroundColor = [UIColor blackColor];
    PopView.alpha = 0.55;
    popImageView = [[UIImageView alloc]initWithFrame:PopView.frame];
    popImageView.backgroundColor  =[UIColor clearColor];
    popImageView.alpha = 0.9;
    
    UIButton *btnDone = [[UIButton alloc]initWithFrame:CGRectMake(110, 310, 90, 35)];
    [btnDone setBackgroundColor:[UIColor magentaColor]];
    [btnDone setTitle:@"Click" forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
//    [PopView addSubview:btnDone];
    
    /// ===========================    ======================/
    self.window.rootViewController = navCntrlr;
    [self.window makeKeyAndVisible];
    
    //---------- AppTentetive -------//
 /*   [ATConnect sharedConnection].apiKey = kApptentiveUniqID;
  //  [ATConnect sharedConnection].appID = kApptentiveAppID;
    
    [[ATConnect sharedConnection] addIntegration:@"SimpleShape_configuration" withConfiguration:@{@"apikey": kApptentiveUniqID}];
    
    double delayInSeconds = 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		BOOL didEngageInteraction = [[ATConnect sharedConnection] engage:@"app.launch" fromViewController:navCntrlr];
		if (didEngageInteraction) {
			NSLog(@"Successfully engaged an interaction for code point \"app.launch\"");
		} else {
			NSLog(@"Did not engage any interactions for code point \"app.launch\"");
		}
	});
    
    NSUInteger unreadMessageCount = [[ATConnect sharedConnection] unreadMessageCount]; NSLog(@"%d",unreadMessageCount);*/

    return YES;
}

#pragma mark - Remove Ads -
-(void)removeAds
{
    UIAlertView *alertRemoveAd = [[UIAlertView alloc]initWithTitle:appTitle message:@"Are you sure want to remove Ads?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Remove Ads",@"Restore", nil];
    alertRemoveAd.tag = 789;
    [alertRemoveAd show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 789)
    {
        if(buttonIndex == 1)
        {
            [self BuyRemoveAds];
        }else if (buttonIndex == 2)
        {
            [self restoreRemovedAds];
        }
    }
}

-(void)BuyRemoveAds
{
    NSString *productId;
    productId = INAPP_PRODUCT_RemoveAds;
    SelectedPurchaseType = 4;
    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}
-(void)restoreRemovedAds
{
    NSString *productId;
    productId = INAPP_PRODUCT_RemoveAds;
    SelectedPurchaseType = 4;
    [[InAppRageIAPHelper sharedHelper] restoreProductIdentifier:productId];
    [appDelegate ShowActivity:@""];
}

-(void)RemovedAds:(NSNotification *)notify
{
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:isPurchased])
//    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        //[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isPurchased];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"isAdRemoved"];
        isAdRemoved = TRUE;
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([InAppRageIAPHelper sharedHelper].isRestored)
        {
            [self alertMessage:@"Restored Successfully."];
        }
        else
        {
            [self alertMessage:@"Purchased Successfully."];
        }
         [self hideAds];
        [appDelegate HideActivity];
//    }
//    [appDelegate HideActivity];
}

-(void)RemovedAdsFailed:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notify.object;
    if (transaction.error.code != SKErrorPaymentCancelled){
        [self alertMessage:@"Purchased Failed!!!"];
    }
    [appDelegate HideActivity];
}

-(void)hideAds
{
    [adBanner setHidden:TRUE];
    [btnHideAd setHidden:TRUE];
    [btnRemoveAd setHidden:TRUE];
}
-(void)ShowAds
{
    [adBanner setHidden:FALSE];
    [btnHideAd setHidden:FALSE];
    [btnRemoveAd setHidden:FALSE];
}
-(IBAction)done:(id)sender
{
    [PopView removeFromSuperview];
}
-(void)CommonMethods
{
    arrAllWorkOuts = [[NSMutableArray alloc] init];
    arrButtWorkOuts = [[NSMutableArray alloc] init];
    arrExpertSeriesWorkOuts = [[NSMutableArray alloc] init];
    arrIntermidiateWorkOuts = [[NSMutableArray alloc] init];
    isFirstTimeShowAnimation = FALSE;
    
 //   [self LoadAllWorkoutsData];
    
    db = [VIDatabase databaseWithName:kDBName];
    if([db open])
        NSLog(@"Database Open");
    else
        NSLog(@"Database couldn't open.");
    
    
//InApp starts...
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppRageIAPHelper sharedHelper]];
//InApp ends.

    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"RestDuration"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"15S" forKey:@"RestDuration"];
    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"ExcerciseDuration"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"30S" forKey:@"ExcerciseDuration"];
        
    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"RestBetweenCycle"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"15S" forKey:@"RestBetweenCycle"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Topbar_5.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Topbar_4.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:kHelveticaNeueThin size:kFontSize25], NSFontAttributeName, nil]];
}

#pragma mark - Application Delegate Methods -
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    isResignActive = TRUE;
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
            isResignActive = FALSE;
            if([delega isKindOfClass:[StartWorkoutsViewController class]]){
                if(![delega isRestRunning] && [[delega startVw]isHidden]){
                    [delega setIsPlay:TRUE];
                    [delega restTimePause:nil];
                }
        }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [Appirater appEnteredForeground:NO];

   [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    application.applicationIconBadgeNumber = 0;
    
    if(isResignActive){
        isResignActive = FALSE;
    }else{
        if([self.navCntrlr.topViewController isKindOfClass:[StartWorkoutsViewController class]])
        {
            if([delega isKindOfClass:[StartWorkoutsViewController class]]){
                NSLog(@"StartWorkout Controller");
                if([delega isRestRunning])
                {
                    if([[delega btnVideo]isSelected])
                        [delega playVideoRepeat];
                }else if([[delega startVw]isHidden]){
                    [delega setIsPlay:FALSE];
                    [delega playPauseBtn_click:nil];
                    [delega ClearCircle];
                }
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}
#pragma mark - Facebook Methods
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //return [FBSession.activeSession handleOpenURL:url];
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            isFacebookAuthenticate = YES;
           // [[NSUserDefaults standardUserDefaults]setBool:isFacebookAuthenticate forKey:@"FBAUTH"];
            if([delega isKindOfClass:[ResultViewController class]] || [delega isKindOfClass:[SettingViewController class]]){
                [delega sharingWithFBForSavedImages];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kFBSharingForAllImage object:nil];
            
        }
            break;
        case FBSessionStateClosed:
            break;
        case FBSessionStateClosedLoginFailed:
            isFacebookAuthenticate = NO;
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification
                                                        object:session];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI //publish_stream ,user_photos ,user_notes,publish_actions
{
    //,@"publish_stream",@"email",@"public_profile" ,publish_actions
     NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream",@"email", nil];
    
//    return [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceOnlyMe allowLoginUI:allowLoginUI completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
//            {
//                [self sessionStateChanged:session state:state error:error];
//            }];
    
   
//    return [FBSession openActiveSessionWithPermissions:permissions
//                                          allowLoginUI:allowLoginUI completionHandler:^(FBSession *session1, FBSessionState state, NSError *error)
//            {
//               //[FBSession setActiveSession:session1];
//                [self sessionStateChanged:session1 state:state error:error];
//            }];
    self.session = [[FBSession alloc] initWithPermissions:permissions];
    
    [self.session openWithCompletionHandler:^(FBSession *session,
                                              FBSessionState status,
                                              NSError *error) {
        // we recurse here, in order to update buttons and labels
        //[self updateView];
        [FBSession setActiveSession:self.session];
        NSLog(@"%@",self.session);
        [self sessionStateChanged:session state:status error:error];
    }];
    return YES;
}


#pragma mark - Custom Method -

-(DQAlertView *)showCustomPopups :(AchievementsObjects *)objAchieve
{
  //  NSLog(@"%@",objAchieve.strIconImage);
    DQAlertView * alertView = [[DQAlertView alloc] initWithTitle:@"Congrats..!" message:[NSString stringWithFormat:@"You have completed %@ achievement",objAchieve.strTitle] cancelButtonTitle:@"Got it!" otherButtonTitle:nil image:nil];
    UIImage * image = [UIImage imageNamed:@"PopAlertBG.png"];
    alertView.backgroundImage = image;
    alertView.hideSeperator = YES;
    alertView.viewFulll.image = [UIImage imageNamed:objAchieve.strIconImage];
    alertView.customFrame = CGRectMake((self.window.frame.size.width - image.size.width)/2, (self.window.frame.size.height - image.size.height)/2, image.size.width, image.size.height);
    return alertView;
}
/*#pragma mark - AdMob delegate
- (GADRequest *)createRequest
{
    GADRequest *request = [GADRequest request];
    return request;
}
- (BOOL)shouldPresentInterstitialAd
{
    return YES;
}
- (void)bannerView:(GADBannerView *)banner didFailToReceiveAdWithError:(NSError*)error
{
    // iAd is not available, so we are going to hide it to get rid of ugly white rectangle
    [self.adBanner setHidden:YES];
    // Here you can add your logic to show your other ads
}
#pragma mark GADBannerViewDelegate impl
// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
   // [self.adBanner addSubview:btnRemoveAd];
}
- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}
*/
#pragma mark - iAd Delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!isbannerIsVisible)
    {
        // If banner isn't part of view hierarchy, add it
//        if (adBanner.superview == nil)
//        {
//            [appDelegate.window addSubview:adBanner];
//        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        isbannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");
    
    if (isbannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        isbannerIsVisible = NO;
    }
}


#pragma mark - Blur Image
-(UIImage *) screenshot : (UIView *)selfView
{
    CGRect rect;
    rect=CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [selfView.layer renderInContext:context];
    
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

#pragma mark - Activity methods
-(void)ShowActivity:(NSString*)str
{
    [SVProgressHUD showWithStatus:str];
}

-(void)HideActivity
{
    [SVProgressHUD dismissWithSuccess:@""];
}

/*-(void)LoadAllWorkoutsData
{
    WorkoutsObjects *wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"jumping jacks.png";
    wo.strTitle = @"JUMPING JACKS";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1. Stand with your feet together, knees slightly bent, and arms to your sides.\n\n STEP 2. While jumping, raise your arms and separate your legs to your sides. Land on your forefoot with your legs apart and arms overhead. \n\n STEP 3. Jump again to lower your arms and legs back to the starting midline position. Both jumps should be fluid and connected motions.";
    
    [arrAllWorkOuts addObject:wo];
    wo = nil;
    
    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"wall sit.png";
    wo.strTitle = @"WALL SIT";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1. Lean against a wall while standing straight.\n\nSTEP 2. Slide down until your knees form 90 degree angles. Hold this position while keeping your abs contracted.";
    [arrAllWorkOuts addObject:wo];
    wo = nil;

    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"push-ups.png";
    wo.strTitle = @"PUSH-UPS";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1. Lie prone on the floor with your hands slightly wider than shoulder-width. Raise your body up off the floor by extending your arms, while keeping your body straight.\n\n STEP 2. Once your arms are fully straight, lower your body to the floor by bending your arms. Repeat.";
    [arrAllWorkOuts addObject:wo];
    wo = nil;
   
    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"abdominal crunch.png";
    wo.strTitle = @"ABDOMINAL CRUNCH";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1. Lie down on the floor with your knees bent. Keep your hands extended straight out in front.\n\nSTEP 2. While contracting your abdominal muscles, slowly lift your shoulder off the floor while keeping your neck in alignment with your torso (i.e., do not bend your neck or head).\n\nSTEP 3. At the top of the movement, contract your stomach, hold for a second, then slowly lower back down to the floor. Repeat.";
    [arrAllWorkOuts addObject:wo];
    wo = nil;
    
    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"chair step-ups.png";
    wo.strTitle = @"CHAIR STEP-UPS";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1. Stand facing a chair.\n\n STEP 2. Place the foot of one leg on the chair. Extend your hip and knee of that leg to stand up on the chair with both legs. Once standing, step down with the opposing leg leading the way.\n\nSTEP 3. Repeat the motion but with legs reversed.";
    [arrAllWorkOuts addObject:wo];
    wo = nil;
    
    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"squatsf.png";
    wo.strTitle = @"SQUATS";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"squats" withExtension:@"gif"];
    wo.strSteps = @"STEP 1: Stand with your arms extended forward.\n\nSTEP 2: Squat down by bending your knees forward while allowing your hips to bend back behind. Keep your back straight throughout the movement and pointed in the same direction as your feet.\n\nSTEP 3: Descend down until your thighs are just past parallel to the floor, then referse the motion by extending your knees and hips until your legs are straight. Repeat.";
    [arrAllWorkOuts addObject:wo];
    wo = nil;

    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"chair triceps dips.png";
    wo.strTitle = @"CHAIR TRICEPS DIPS";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1. Sit on a chair and place your hands on the edge of the chair. Position your feet away from the chair. Straighten your arms, and slide your rear end off of the edge of the chair. Rest your heels on the floor with your legs extended straight.\n\nSTEP 2. Lower your body by bending your arms until you feel a slight stretch in the chest or shoulder. Raise your body and repeat.";
    [arrAllWorkOuts addObject:wo];
    wo = nil;
    
    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"plank.png";
    wo.strTitle = @"PLANK";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1. Lie prone with your forearms flat on the floor. Your elbows should be positioned under your shoulders. Place your legs together with your forefeet on the floor.\n\nSTEP 2. Raise your body upward by straightening your body in a straight line. Hold this position with your abdominal core muscles.";
    [arrAllWorkOuts addObject:wo];
    wo = nil;
    
    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"high knees running in place.png";
    wo.strTitle = @"HIGH KNEES RUNNING IN PLACE";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1. Run in place with your arms pumping by your sides.\n\nSTEP 2. Ensure that you are raising your knees as high up as you can during the running motion.";
    [arrAllWorkOuts addObject:wo];
    wo = nil;
    
    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"lungesf.png";
    wo.strTitle = @"LUNGES";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"lunges" withExtension:@"gif"];
    wo.strSteps = @"STEP 1: Stand with your hands on your hips.\n\nSTEP 2: Lunge forward with your first leg. Lower your body by flexing your knee and hip in front of the front leg until the knee of your rear leg is almost in contact with the floor.\n\nSTEP 3: Return to the original standing position by forcibly extending your hip and knee of the forward leg. Repeat the lunge with the opposite leg.";
    
    [arrAllWorkOuts addObject:wo];
    wo = nil;
    
    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"push-ups with rotation.png";
    wo.strTitle = @"PUSH-UPS WITH ROTATION";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1. Perform a push-up by lowering your body to the floor and extending your self back up off the floor.\n\nSTEP 2. At the end of the pushup, rotate your body to the right by lifting your right arm off the mat and pointing it at the ceiling.\n\nSTEP 3. Return your right hand to the floor, perform another pushup, and repeat with the left arm.";
    [arrAllWorkOuts addObject:wo];
    wo = nil;
    
    wo = [[WorkoutsObjects alloc] init];
    wo.strImageName = @"side planksf.png";
    wo.strTitle = @"SIDE PLANKS";
    wo.GIFUrl = [[NSBundle mainBundle] URLForResource:@"side planks" withExtension:@"gif"];
    wo.strSteps = @"STEP 1: Lie on your side with your forearm under your shoulder, perpendicular to your body. Your upper leg should be stacked on top of the lower leg and your knees and hips should be straight.\n\nSTEP 2: Rise your body upward by straightening your waist so that your body is ridged. Hold this position and then repeat with the other side.";
    
    [arrAllWorkOuts addObject:wo];
    wo = nil;
}*/

-(void)alertMessage: (NSString *)strMessage
{
    UIAlertView *alertGlobal = [[UIAlertView alloc]initWithTitle:appTitle message:strMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertGlobal show];
}

@end
