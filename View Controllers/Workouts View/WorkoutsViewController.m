//
//  WorkoutsViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 04/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "WorkoutsViewController.h"
#import "GeneralWorkoutsViewController.h"
#import "InAppRageIAPHelper.h"

@interface WorkoutsViewController ()

@end

@implementation WorkoutsViewController

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
    
    self.title = @"Workouts";
    
    UIButton *btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMenu.frame = CGRectMake(0, 0, 27, 20);
    [btnMenu setImage:[UIImage imageNamed:@"H_menu.png"] forState:UIControlStateNormal];
    
    [btnMenu addTarget:self action:@selector(MenuBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItme = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    self.navigationItem.rightBarButtonItem = rightItme;
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 27, 23);
    [btnBack setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    UIBarButtonItem *leftItme = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItme;
    
    if(appDelegate.isIphone5){
        scrMain.contentSize = CGSizeMake(scrMain.frame.size.width, 550);
    }
    else{
        scrMain.contentSize = CGSizeMake(scrMain.frame.size.width, 650);
    }
    
    //========= Check InApp Purchase
    BOOL isPurchase = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseAdvanceWorkout"]boolValue];
    if(isPurchase){
        imgAdvancedLock.hidden = TRUE;
        [btnAdvance setImage:[UIImage imageNamed:@"Advancelocked_i5.png"] forState:UIControlStateNormal];
    }
    else{
        imgAdvancedLock.hidden = FALSE;
        [btnAdvance setImage:[UIImage imageNamed:@"Advancelocked_i5.png"] forState:UIControlStateNormal];
    }

    isPurchase = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseExpertsWorkout"]boolValue];
    
    if(isPurchase){
        imgExpertsLock.hidden = TRUE;
        [btnExpert setImage:[UIImage imageNamed:@"ExpertLocked_i5.png"] forState:UIControlStateNormal];
    }
    else{
        imgExpertsLock.hidden = FALSE;
        [btnExpert setImage:[UIImage imageNamed:@"ExpertLocked_i5.png"] forState:UIControlStateNormal];
    }
    
    isPurchase = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseButtWorkout"]boolValue];
    
    if(isPurchase){
        imgButtLock.hidden = TRUE;
        [btnButt setImage:[UIImage imageNamed:@"ButtLocked_i5.png"] forState:UIControlStateNormal];
    }
    else{
        imgButtLock.hidden = FALSE;
        [btnButt setImage:[UIImage imageNamed:@"ButtLocked_i5.png"] forState:UIControlStateNormal];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = FALSE;
    [self setCustomObservers];//InApp
   // [[UIApplication sharedApplication]setStatusBarHidden:TRUE];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [appDelegate HideActivity];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductRestoreFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedforAdvancedWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedFailedforAdvancedWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedforExpertsWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedFailedforExpertsWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedforButtWorkout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedFailedforButtWorkout object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Set Observers
-(void)setCustomObservers
{
//    if ([InAppRageIAPHelper sharedHelper].products == nil)
//    {
//        [[InAppRageIAPHelper sharedHelper] requestProducts];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreFailed:) name:kProductRestoreFailed object:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasedSuccessForAdvanceWorkouts:) name:kProductPurchasedforAdvancedWorkout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasedFailedForAdvanceWorkouts:) name:kProductPurchasedFailedforAdvancedWorkout object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccesforExpertsWorkouts:) name:kProductPurchasedforExpertsWorkout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasedFailedforExpertsWorkouts:) name:kProductPurchasedFailedforExpertsWorkout object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseSuccesforButtWorkouts:) name:kProductPurchasedforButtWorkout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchasedFailedforButtWorkouts:) name:kProductPurchasedFailedforButtWorkout object:nil];
    
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

-(void)purchasedSuccessForAdvanceWorkouts:(NSNotification *)notify
{
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:isPurchased])
//    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isPurchased];
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseAdvanceWorkout"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([InAppRageIAPHelper sharedHelper].isRestored)
        {
            [self showAlert:@"Restored Successfully."];
        }
        else
        {
            [self showAlert:@"Purchased Successfully."];
        }
        imgAdvancedLock.hidden = TRUE;
        [appDelegate HideActivity];
   // }
    [appDelegate HideActivity];
}

-(void)purchasedFailedForAdvanceWorkouts:(NSNotification *)notify
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notify.object;
    if (transaction.error.code != SKErrorPaymentCancelled){
        [self showAlert:@"Purchased Failed!!!"];
    }
    [appDelegate HideActivity];
}

-(void)purchaseSuccesforExpertsWorkouts:(NSNotification *)notify
{
    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:isPurchased])
//    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        //[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isPurchased];
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseExpertsWorkout"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([InAppRageIAPHelper sharedHelper].isRestored)
        {
            [self showAlert:@"Restored Successfully."];
        }
        else
        {
            [self showAlert:@"Purchased Successfully."];
        }
        imgExpertsLock.hidden = TRUE;
        [appDelegate HideActivity];
        //        [self reloadView];
  //  }
    [appDelegate HideActivity];
}

-(void)purchasedFailedforExpertsWorkouts:(NSNotification *)notify
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notify.object;
    if (transaction.error.code != SKErrorPaymentCancelled){
        [self showAlert:@"Purchased Failed!!!"];
    }
    [appDelegate HideActivity];
}

-(void)purchaseSuccesforButtWorkouts:(NSNotification *)notify
{
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:isPurchased])
//    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
       // [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isPurchased];
        [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"isPurchaseButtWorkout"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([InAppRageIAPHelper sharedHelper].isRestored)
        {
            [self showAlert:@"Restored Successfully."];
        }
        else
        {
            [self showAlert:@"Purchased Successfully."];
        }
        imgButtLock.hidden = TRUE;
        [appDelegate HideActivity];
        //        [self reloadView];
 //   }
    [appDelegate HideActivity];
}

-(void)purchasedFailedforButtWorkouts:(NSNotification *)notify
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

#pragma mark - IBAction Event -

-(IBAction)generalBtn_click:(id)sender
{
    appDelegate.SelectedBtnType=[sender tag];
    [self nextView];
}

-(IBAction)advancesBtn_click:(id)sender
{
    BOOL isPurchase = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseAdvanceWorkout"]boolValue];
    
    if(isPurchase)
    {
        appDelegate.arrIntermidiateWorkOuts = [[NSMutableArray alloc]initWithArray:[DBController getIntermediateWorkOuts:[[NSUserDefaults standardUserDefaults]objectForKey:@"ModelType"]]];
        
        appDelegate.SelectedBtnType=[sender tag];
        NSLog(@"appDelegate.arrIntermidiateWorkOuts is %@",appDelegate.arrIntermidiateWorkOuts);
        [self nextView];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you want to buy AdvanceWorkouts?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Buy Now", @"Restore", nil];
                
        actionSheet.tag = 101;
        actionSheet.delegate = self;
        [actionSheet showInView:appDelegate.window];
    }
}

-(IBAction)expertsBtn_click:(id)sender
{
    BOOL isPurchase = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseExpertsWorkout"]boolValue];
    
    if(isPurchase)
    {
        appDelegate.arrExpertSeriesWorkOuts = [[NSMutableArray alloc]initWithArray:[DBController getExpertsSeriesWorkOuts:[[NSUserDefaults standardUserDefaults]objectForKey:@"ModelType"]]];
        
        appDelegate.SelectedBtnType=[sender tag];
        NSLog(@"appDelegate.arrExpertSeriesWorkOuts is %@",appDelegate.arrExpertSeriesWorkOuts);
        [self nextView];
    }
    else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you want to buy ExpertWorkouts?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Buy Now", @"Restore", nil];
        actionSheet.tag = 102;
        actionSheet.delegate = self;
        [actionSheet showInView:appDelegate.window];
    }
}
-(IBAction)buttBtn_click:(id)sender
{
    BOOL isPurchase = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isPurchaseButtWorkout"]boolValue];
    if(isPurchase){
        
        appDelegate.arrButtWorkOuts = [[NSMutableArray alloc]initWithArray:[DBController getButtWorkOuts:[[NSUserDefaults standardUserDefaults]objectForKey:@"ModelType"]]];
        
        appDelegate.SelectedBtnType=[sender tag];
        NSLog(@"appDelegate.arrExpertSeriesWorkOuts is %@",appDelegate.arrButtWorkOuts);
        [self nextView];
        
    }
    else{
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you want to buy ButtWorkouts?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Buy Now", @"Restore", nil];
        actionSheet.tag = 103;
        actionSheet.delegate = self;
        [actionSheet showInView:appDelegate.window];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 101){
        if(buttonIndex == 0){
            [self BuyAdvancedWorkout];
        }
        else if (buttonIndex == 1){
            [self restoreAdvancedWorkout];
        }
    }
    else if(actionSheet.tag == 102){
        if(buttonIndex == 0){
            [self BuyExpertsWorkout];
        }
        else if (buttonIndex == 1){
            [self restoreExpertsWorkout];
        }
    }else if (actionSheet.tag == 103){
        if(buttonIndex == 0){
            [self BuyButtWorkout];
        }
        else if (buttonIndex == 1){
            [self restoreButtWorkout];
        }
    }
}

#pragma mark - Custom Events -

-(void)nextView
{
    GeneralWorkoutsViewController *objGeneralWorkoutsViewController = [[GeneralWorkoutsViewController alloc] initWithNibName:@"GeneralWorkoutsViewController" bundle:nil];
    
   // ADTransition * trans = [[ADGlueTransition alloc] initWithDuration:0.9f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
   // objGeneralWorkoutsViewController.transition = trans;
    [self.navigationController pushViewController:objGeneralWorkoutsViewController animated:YES];
}

-(void)MenuBtn
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
