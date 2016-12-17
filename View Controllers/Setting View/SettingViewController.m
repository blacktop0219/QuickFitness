//
//  SettingViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "DBController.h"
NSString *const KeyForDateOfBackUp=@"DateBackUp";

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize isFeedBack;

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
    
    self.title = @"Settings";
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 35);
    [btnBack setImage:[UIImage imageNamed:@"Back_Btn.png"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(BackBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItme = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItme;
    
    objUserController = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    
    arrSectionOne = [[NSMutableArray alloc] initWithObjects:@"Voice-over",@"Voice-over Type",@"Model Type",@"Countdown",@"Volume level",@"iCloud Sync", nil];
    arrSectionTwo = [[NSMutableArray alloc] initWithObjects:@"Tell A Friend",@"Contact Us",@"Notifications",@"Randomize order",@"Rest duration",@"Excercise duration",@"Rest between cycles",@"RATE US", nil];
    
    tblVw.backgroundColor = [UIColor clearColor];
    
    // ====== Setup iCloud ========///
    
    iCloud *cloud = [iCloud sharedCloud]; // This will help to begin the sync process and register for document updates
    [cloud setDelegate:self]; // Set this if you plan to use the delegate
    [cloud setVerboseLogging:YES]; // We want detailed feedback about what's going on with iCloud, this is OFF by default
    kvoStore = [NSUbiquitousKeyValueStore defaultStore];
   // NSString *str = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:KeyForDateOfBackUp];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(ubiquitousKeyValueStoreDidChange:)
                                                 name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:kvoStore];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(updateKVStoreItems:)
                                                 name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:kvoStore];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ubiquitousKeyValueStoreDidChange:) name:NSUbiquitousKeyValueStoreChangeReasonKey object:kvoStore];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCloudListAfterSetup) name:@"iCloud Ready" object:nil];
    [kvoStore synchronize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = FALSE;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:appDelegate.adBanner];
    [self.view addSubview:appDelegate.btnHideAd];
    [self.view addSubview:appDelegate.btnRemoveAd];
    
    appDelegate.CurrentSwitchName = @"Switch_Man_Woman.png";
    
    if(appDelegate.isIphone5){
    if([appDelegate.adBanner isHidden]){
        tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width, 502);
    }else{
        tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width, 458);
    }
    }else{
        if([appDelegate.adBanner isHidden]){
            tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width, 414);
        }else{
            tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width, 370);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Events

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return arrSectionOne.count;
    }
    else{
        return arrSectionTwo.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section ==0){
        return 0.0;
    }
    else{
        return 40.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(67, 0, 240, 40)];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize18];
    lblTitle.text = @"Workout Setting";
    [view addSubview:lblTitle];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SettingViewCell";
    
    SettingViewCell *cell = (SettingViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        
        cell.lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize18];
        cell.lblDetails.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize13];
        
        [cell.sliderVolume addTarget:self action:@selector(SliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [cell.SwitchOnOff addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
        [cell.genderSwitch addTarget:self action:@selector(genderChange:) forControlEvents:UIControlEventValueChanged];
//        cell.genderSwitch.layer.masksToBounds = true;
        cell.genderSwitch.layer.cornerRadius = 8.0;
        
        cell.SwitchOnOff.backgroundColor = [UIColor redColor];
        cell.SwitchOnOff.layer.cornerRadius = 16.0;

        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//  BOOL AppLoad = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoadAppSecondTime"];
    }
    
    NSString * strIndex = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    
    cell.contentView.tag = [strIndex integerValue];
    cell.sliderVolume.tag = [strIndex integerValue];
    cell.SwitchOnOff.tag = [strIndex integerValue];
    cell.genderSwitch.tag = [strIndex integerValue];
    
    cell.SwitchOnOff.hidden = TRUE;
    cell.genderSwitch.hidden = TRUE;
    cell.sliderVolume.hidden = TRUE;
    cell.lblDetails.hidden = TRUE;
    cell.lblTitle.hidden = FALSE;
    cell.imgIcon.hidden = FALSE;
    
    if(indexPath.section == 0){
        cell.lblTitle.text = [arrSectionOne objectAtIndex:indexPath.row];
    }
    else{
        cell.lblTitle.text = [arrSectionTwo objectAtIndex:indexPath.row];
    }
    cell.imgIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"S_%ld%ld", (long)indexPath.section, (long)indexPath.row]];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.SwitchOnOff.hidden = FALSE;
            cell.SwitchOnOff.on = [[NSUserDefaults standardUserDefaults]boolForKey:@"VoiceOver"];
        }else if (indexPath.row == 1){
            cell.genderSwitch.hidden = FALSE;
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"SoundType"]isEqualToString:@"WomenSound"])
            {
                [cell.genderSwitch setOn:TRUE];
            }else{
                [cell.genderSwitch setOn:FALSE];
            }
           
        }else if (indexPath.row == 2){
            cell.genderSwitch.hidden = FALSE;
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"ModelType"]isEqualToString:@"WomenModel"])
            {
                [cell.genderSwitch setOn:TRUE];
            }else{
                [cell.genderSwitch setOn:FALSE];
            }
        }
        else if (indexPath.row == 3){
            cell.SwitchOnOff.hidden = FALSE;
            cell.SwitchOnOff.on = [[NSUserDefaults standardUserDefaults]boolForKey:@"CountDown"];
            
        }else if(indexPath.row == 4){
            cell.sliderVolume.hidden = FALSE;
            cell.sliderVolume.value = [[MPMusicPlayerController applicationMusicPlayer] volume]*60;
        }
        else if (indexPath.row == 5){
            //cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            cell.SwitchOnOff.on = [[NSUserDefaults standardUserDefaults]boolForKey:@"iCloud"];
        }
        
    }
    else{
        if(indexPath.row==2){
            cell.SwitchOnOff.hidden = TRUE;
             cell.lblDetails.hidden = TRUE;
            cell.sliderVolume.hidden = TRUE;
            cell.genderSwitch.hidden = TRUE;
        }
       else if(indexPath.row == 3){
            cell.SwitchOnOff.hidden = FALSE;
            cell.SwitchOnOff.on = [[NSUserDefaults standardUserDefaults]boolForKey:@"Randomize"];
            cell.lblDetails.hidden = TRUE;
            cell.genderSwitch.hidden = TRUE;
        }else if (indexPath.row == 0 || indexPath.row == 7)
        {
            cell.SwitchOnOff.hidden = TRUE;
            cell.lblDetails.hidden = TRUE;
             cell.lblTitle.textColor = [UIColor redColor];
            cell.lblTitle.font = [UIFont fontWithName:kHelveticaBold size:kFontSize18];
            cell.genderSwitch.hidden = TRUE;
        }else if (indexPath.row == 1){
            cell.SwitchOnOff.hidden = TRUE;
            cell.lblDetails.hidden = TRUE;
            cell.sliderVolume.hidden = TRUE;
            cell.genderSwitch.hidden = TRUE;
           
        }
        else{
            cell.SwitchOnOff.hidden = TRUE;
            cell.lblDetails.hidden = FALSE;
            cell.genderSwitch.hidden = TRUE;
            
            if(indexPath.row == 4){
                cell.lblDetails.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"RestDuration"];
                cell.sliderVolume.hidden = TRUE;
                NSString *strValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"RestDuration"];
                strValue = [strValue stringByReplacingOccurrencesOfString:@"S" withString:@""];
                cell.sliderVolume.value = [strValue integerValue];
            }
            else if(indexPath.row == 5){
                cell.lblDetails.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExcerciseDuration"];
                cell.sliderVolume.hidden = TRUE;
                NSString *strValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExcerciseDuration"];
                strValue = [strValue stringByReplacingOccurrencesOfString:@"S" withString:@""];
                cell.sliderVolume.value = [strValue integerValue];
            }
            else if (indexPath.row == 6){
                cell.lblDetails.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"RestBetweenCycle"];
                cell.sliderVolume.hidden = TRUE;
                NSString *strValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"RestBetweenCycle"];
                strValue = [strValue stringByReplacingOccurrencesOfString:@"S" withString:@""];
                cell.sliderVolume.value = [strValue integerValue];

            }
        }
    }
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString * strIndex = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
        selectedIndex = [strIndex integerValue];

        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        break;
                    case 1:
                        break;
                    case 2:
                        break;
                    case 5:
                    {
                        id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
                        if(currentiCloudToken){
                            UIActionSheet *actionCloud = [[UIActionSheet alloc]initWithTitle:appTitle delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Back Up",@"Restore", nil];
                            actionCloud.tag = 524;
                            [actionCloud showInView:self.view];
                        }else{
                            [appDelegate alertMessage:@"iCloud is not configured on this device"];
                        }
                      
                    }
                    default:
                        break;
                }
                break;
                
            case 1:
                switch (indexPath.row) {
                    case 2:
                    {
                        NotificationViewController *objNotificationController =[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
                        [self.navigationController pushViewController:objNotificationController animated:YES];
                    }
                        break;
                    case 4:
                    {
                        UIActionSheet *aciton = [[UIActionSheet alloc]initWithTitle:@"Rest Duration" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"5 Seconds", @"10 Seconds",@"15 Seconds",@"30 Seconds",@"45 Seconds",@"60 Seconds",@"90 Seconds", nil];
                        aciton.tag = 525;
                        [aciton showInView:self.view];
                    }
                        break;
                        
                    case 5:
                    {
                        UIActionSheet *aciton = [[UIActionSheet alloc]initWithTitle:@"Excercise Duration" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"15 Seconds",@"30 Seconds",@"45 Seconds",@"60 Seconds",@"90 Seconds", nil];
                        aciton.tag = 526;
                        [aciton showInView:self.view];
                    }
                        break;
                        
                    case 6:
                    {
                        UIActionSheet *aciton = [[UIActionSheet alloc]initWithTitle:@"Rest Between Cycles" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"10 Seconds",@"15 Seconds",@"30 Seconds",@"45 Seconds",@"60 Seconds",@"90 Seconds", nil];
                        aciton.tag = 527;
                        [aciton showInView:self.view];
                    }
                        break;
                    case 0:
                    {
                        UIActionSheet *aciton = [[UIActionSheet alloc]initWithTitle:@"Tell A Friend" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Share on Twitter",@"Share on Email", nil];
                        
                        [aciton showInView:self.view];
                    }
                        break;
                    case 1:
                    {
                       // [[ATConnect sharedConnection]presentMessageCenterFromViewController:self];
                        isFeedBack = true;
                        [self shareOnEmail];
                    }
                        break;
                    case 7:
                    {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appstoreUrl]];
                    }
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
}

#pragma mark - Sharing
-(void)shareOnFacebook
{
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
        UIAlertView *alertFacebook = [[UIAlertView alloc]initWithTitle:appTitle message:@"Facebook is Unavailable on your device" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertFacebook show];
    } */
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
  //  NSString *strMsg = [NSString stringWithFormat:@"Hey guys, i've just completed my workout with SimpleShape Challenge.Check it out app url: %@",appstoreUrl];
      NSString *strMsg = [NSString stringWithFormat:@"This is how I workout, Download SimpleShape \n %@ \n #SimpleShapeApp",appstoreUrl];
    
    // NOTES: ---- publish_actions Permission not required in feed Post methods ---------//
 //  NSString *strMsg = [NSString stringWithFormat:@"Publish_Action Test"];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:strMsg,@"message", nil];
    [appDelegate ShowActivity:@""];
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:dictionary HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Success", nil)] message:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Sharing on Facebook is Successful.", nil)] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
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
            //[appDelegate hideActivity];
            [appDelegate HideActivity];
            [appDelegate alertMessage:error.localizedDescription];
            NSLog(@"Error: %@ %@",error.localizedDescription, [error userInfo]);
        }
    }];
}

-(void)shareOnEmail
{
    if([MFMailComposeViewController canSendMail])
    {
        if(isFeedBack){
            MFMailComposeViewController *picker;
            @autoreleasepool {
                picker = [[MFMailComposeViewController alloc] init];
            }
            
            picker.mailComposeDelegate = self;
            [picker setSubject:appTitle];
            [picker setToRecipients:[NSArray arrayWithObject:@"SimpleShapeChallenge@gmail.com"]];
            
            UIDevice *myDevice = [UIDevice currentDevice];
            NSString *strDeviceDetails = [NSString stringWithFormat:@"\n\n\nSystem Name: %@\nSystem Version: %@\nModel: %@",myDevice.systemName,myDevice.systemVersion,myDevice.model];
            [picker setMessageBody:strDeviceDetails isHTML:NO];
            
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            MFMailComposeViewController *picker;
            @autoreleasepool {
                picker = [[MFMailComposeViewController alloc] init];
            }
            
            picker.mailComposeDelegate = self;
            [picker setSubject:appTitle];
            [picker setToRecipients:nil];
            UIDevice *myDevice = [UIDevice currentDevice];
            NSString *strDeviceDetails = [NSString stringWithFormat:@"\n\n\nSystem Name: %@\nSystem Version: %@\nModel: %@",myDevice.systemName,myDevice.systemVersion,myDevice.model];
            //  [picker setMessageBody:strDeviceDetails isHTML:NO];
            
            [picker setMessageBody:[NSString stringWithFormat:@"Get in shape with SimpleShape, Download on the AppStore now  \n %@ \n #SimpleShapeApp \n\n %@",appstoreUrl,strDeviceDetails]isHTML:NO];
            [self presentViewController:picker animated:YES completion:nil];
        }
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
            if(isFeedBack)
                isFeedBack = false;
            break;
        case MFMailComposeResultSaved:
            //  message.text = @"Result: saved";
            if(isFeedBack)
                isFeedBack = false;
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
        {
            //message.text = @"Result: sent";
            if(!isFeedBack)
            {
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
            }else{
                isFeedBack = false;
            }
        }
            break;
        case MFMailComposeResultFailed:
            //message.text = @"Result: failed";
            if(isFeedBack)
                isFeedBack = false;
            NSLog(@"Result: failed");
            break;
        default:
            //message.text = @"Result: not sent";
            if(isFeedBack)
                isFeedBack = false;
            NSLog(@"Result: sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
            } else
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
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else{
        [appDelegate alertMessage:@"Twitter is Unavailable on your device"];
    }
}

#pragma mark - Custom Events -
-(void)BackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SliderValueChange:(id)sender
{
    UISlider *slider = sender;
    NSInteger value = slider.value;
    NSString *strDuration;
    UITableViewCell *cell;
    
    switch (slider.tag) {
        case 04:
              [[MPMusicPlayerController applicationMusicPlayer] setVolume:(float)(slider.value/60)];
            break;
            
        case 11:
            
            strDuration = [NSString stringWithFormat:@"%ldS", (long)value];
            cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            ((SettingViewCell*) cell).lblDetails.text = strDuration;
            [[NSUserDefaults standardUserDefaults] setObject:strDuration forKey:@"RestDuration"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        case 12:
            strDuration = [NSString stringWithFormat:@"%ldS", (long)value];
            cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
            ((SettingViewCell*) cell).lblDetails.text = strDuration;
            [[NSUserDefaults standardUserDefaults] setObject:strDuration forKey:@"ExcerciseDuration"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        case 13:
            strDuration = [NSString stringWithFormat:@"%ldS", (long)value];
            cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
            ((SettingViewCell*) cell).lblDetails.text = strDuration;
            [[NSUserDefaults standardUserDefaults] setObject:strDuration forKey:@"RestBetweenCycle"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        default:
            break;
    }
}
-(void)restTimeChanged :(int)nValue :(int)actionSheetTag
{
     NSString *strDuration;  UITableViewCell *cell;
    if(actionSheetTag==525){
        
        strDuration = [NSString stringWithFormat:@"%ldS", (long)nValue];
        cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        ((SettingViewCell*) cell).lblDetails.text = strDuration;
        [[NSUserDefaults standardUserDefaults] setObject:strDuration forKey:@"RestDuration"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else if (actionSheetTag == 526){
        
        strDuration = [NSString stringWithFormat:@"%ldS", (long)nValue];
        cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
        ((SettingViewCell*) cell).lblDetails.text = strDuration;
        [[NSUserDefaults standardUserDefaults] setObject:strDuration forKey:@"ExcerciseDuration"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else if (actionSheetTag == 527){
        
        strDuration = [NSString stringWithFormat:@"%ldS", (long)nValue];
        cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
        ((SettingViewCell*) cell).lblDetails.text = strDuration;
        [[NSUserDefaults standardUserDefaults] setObject:strDuration forKey:@"RestBetweenCycle"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self RefreshTableView];
}
-(void)flip:(UISwitch *)switc
{
    BOOL switchStatus  =FALSE;
    if(switc.on)
        switchStatus = TRUE;
    else
        switchStatus = FALSE;
    
    UITableViewCell *cell;
    switch (switc.tag) {
        case 00:
        {
            cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
           /* if(switchStatus){
                UIAlertView *alertSound = [[UIAlertView alloc]initWithTitle:appTitle message:@"which type of sound do you want to play?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Men Sound",@"Women Sound", nil];
                alertSound.tag = 622;
                [alertSound show];
            }*/
            
            [[NSUserDefaults standardUserDefaults] setBool:switchStatus forKey:@"VoiceOver"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            appDelegate.isVoiceEnable = switchStatus;
        }
            break;
            
        case 03:
        {
            cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [[NSUserDefaults standardUserDefaults] setBool:switchStatus forKey:@"CountDown"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            appDelegate.isCountDownEnable = switchStatus;
        }
            break;
        /*case 01:
        {
            cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [[NSUserDefaults standardUserDefaults] setBool:switchStatus forKey:@"iCloud"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            appDelegate.isCloudEnable = switchStatus;
            if(switchStatus==TRUE){
              //  [self getiCloudBackup];
               // [self getIcloudData];
                 id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
                if(currentiCloudToken){
                UIAlertView *alertCloud = [[UIAlertView alloc]initWithTitle:appTitle message:@"You want to BackUp OR Restore?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"BackUp",@"Restore", nil];
                    alertCloud.tag = 525;
                [alertCloud show];
                }else{
                    [appDelegate alertMessage:@"iCloud is not configured on this device"];
                }
            }
        }
            break;*/
       
        case 13:
        {
            cell = (SettingViewCell*)[tblVw cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            [[NSUserDefaults standardUserDefaults] setBool:switchStatus forKey:@"Randomize"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            appDelegate.isRandomizedOrder = switchStatus;
        }
            break;
            
        default:
            break;
    }
}

-(void)genderChange :(DGSwitch *)swt
{
    switch (swt.tag) {
        case 01:
        {
            if(swt.on){
                [[NSUserDefaults standardUserDefaults]setObject:@"WomenSound" forKey:@"SoundType"];
                [DBController updateVoiceType:appDelegate.UserId :@"Female"];
            }
            else{
                [[NSUserDefaults standardUserDefaults]setObject:@"MenSound" forKey:@"SoundType"];
                [DBController updateVoiceType:appDelegate.UserId :@"Male"];
            }
            
        }
            break;
        case 02:
        {
            if(swt.on){
                [[NSUserDefaults standardUserDefaults]setObject:@"WomenModel" forKey:@"ModelType"];
                [DBController updateModelType:appDelegate.UserId :@"Female"];
            }
            else{
                [[NSUserDefaults standardUserDefaults]setObject:@"MenModel" forKey:@"ModelType"];
                [DBController updateModelType:appDelegate.UserId :@"Male"];
            }
            
        }
            break;
            
        default:
            break;
    }
   
}
-(void)RefreshTableView
{
    [tblVw reloadData];
}
-(NSString *)getCurrentDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"dd/MM/yyyy"];
    
    NSString *Date=[df stringFromDate:[NSDate date]];
    return Date;
}
#pragma mark- Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 621)
    {
        if(buttonIndex == 0)
        {
            [self getIcloudData];
        }
    }
    else if(alertView.tag == 525)
    {
        if(buttonIndex == alertView.cancelButtonIndex){
        
        }else if (buttonIndex==1){
            [self getiCloudBackup];
        }else if (buttonIndex==2){
            [self getIcloudData];
        }
    }
    
    /*else if (alertView.tag == 622)
    {
        if(buttonIndex == 0){
            
            [[NSUserDefaults standardUserDefaults]setObject:@"MenSound" forKey:@"SoundType"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else if (buttonIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"WomenSound" forKey:@"SoundType"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }*/
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 524)
    {
        if(buttonIndex == actionSheet.cancelButtonIndex){
            
        }else if (buttonIndex == 0){
            [self getiCloudBackup];
            
        }else if (buttonIndex == 1){
            NSString *strDate = [kvoStore stringForKey:KeyForDateOfBackUp];
            NSString *strMessage = [NSString stringWithFormat:@"Are you sure want to restore back up taken of %@?",strDate];
            UIAlertView *alertRestore = [[UIAlertView alloc]initWithTitle:appTitle message:strMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
            alertRestore.tag = 621;
            [alertRestore show];
        }
    }
    else if(actionSheet.tag == 525)
    {
        if(buttonIndex== actionSheet.cancelButtonIndex){
            
        }else{
            switch (buttonIndex) {
                case 0:
                    [self restTimeChanged:5 :525];
                    break;
                case 1:
                    [self restTimeChanged:10 :525];
                    break;
                case 2:
                    [self restTimeChanged:15 :525];
                    break;
                case 3:
                    [self restTimeChanged:30 :525];
                    break;
                case 4:
                    [self restTimeChanged:45 :525];
                    break;
                case 5:
                    [self restTimeChanged:60 :525];
                    break;
                case 6:
                    [self restTimeChanged:90 :525];
                    break;
                    
                default:
                    break;
            }
        }
    }else if(actionSheet.tag == 526)
    {
        if(buttonIndex==actionSheet.cancelButtonIndex){
            
        }else{
            switch (buttonIndex) {
                case 0:
                    [self restTimeChanged:15 :526];
                    break;
                case 1:
                    [self restTimeChanged:30 :526];
                    break;
                case 2:
                    [self restTimeChanged:45 :526];
                    break;
                case 3:
                    [self restTimeChanged:60 :526];
                    break;
                case 4:
                    [self restTimeChanged:90 :526];
                    break;
                    
                default:
                    break;
            }
        }
        
    }else if (actionSheet.tag == 527){
        if(buttonIndex== actionSheet.cancelButtonIndex){
            
        }else{
            switch (buttonIndex) {
                case 0:
                    [self restTimeChanged:10 :527];
                    break;
                case 1:
                    [self restTimeChanged:15 :527];
                    break;
                case 2:
                    [self restTimeChanged:30 :527];
                    break;
                case 3:
                    [self restTimeChanged:45 :527];
                    break;
                case 4:
                    [self restTimeChanged:60 :527];
                    break;
                case 5:
                    [self restTimeChanged:90 :527];
                    break;
                    
                default:
                    break;
            }
        }
    }
    else{
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
    }
}

#pragma mark - iCloud BackupData
-(void)getiCloudBackup
{
    [appDelegate ShowActivity:@""];
    [self createZipFolder];
    [self getBackUP];
}
-(void)createZipFolder
{
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir1 = [paths1 objectAtIndex:0];
    NSString *zipProfilePath = [documentsDir1 stringByAppendingPathComponent:@"ProfileZip.zip"];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    [fileManager removeItemAtPath:zipProfilePath error:nil];
    ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:zipProfilePath];
    NSInteger result = [archive deflateDirectory:ProfilePath relativeToPath:LibraryPathLocal usingResourceFork:NO];
    
    NSString *ziptemPath = [documentsDir1 stringByAppendingPathComponent:@"tempZip.zip"];
    [fileManager removeItemAtPath:ziptemPath error:nil];
    ZKFileArchive *archive1 = [ZKFileArchive archiveWithArchivePath:ziptemPath];
    NSInteger result1 = [archive1 deflateDirectory:TempPath relativeToPath:LibraryPathLocal usingResourceFork:NO];
    
}
-(void)getBackUP
{
    [MKiCloudSync start:@"backup"];
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir1 = [paths1 objectAtIndex:0];
    
    NSString *docsDir = documentsDir1;
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    
    if ([NSUbiquitousKeyValueStore defaultStore])
    {
        [kvoStore setString:[self getCurrentDate] forKey:KeyForDateOfBackUp];
        [kvoStore synchronize];
        
    }
    NSDirectoryEnumerator *dirEnum =[localFileManager enumeratorAtPath:docsDir];
    NSString *file;
    NSString*filePath;
    while (file = [dirEnum nextObject])
    {
        NSArray*originalFileNameArray = [file componentsSeparatedByString:@"/"];
        NSString*originalFileName = [originalFileNameArray objectAtIndex:([originalFileNameArray count]-1)];
        if(![originalFileName isEqualToString:@"Profile"] && ![originalFileName hasSuffix:@".png"] && ![originalFileName isEqualToString:@".DS_Store"] && ![originalFileName isEqualToString:@"temp"])
        {
            NSString*backUpFileName = [NSString stringWithFormat:@"SimpleShape____%@",originalFileName];
            filePath = [docsDir stringByAppendingPathComponent:file];
            
            NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:Nil];
            NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"]
                                        URLByAppendingPathComponent:backUpFileName];
            
            Note *doc = [[Note alloc] initWithFileURL:ubiquitousPackage];
            
            NSData *DataTemp=[[NSData alloc] initWithContentsOfFile:filePath];
            doc.noteDataContent = DataTemp;
            
            [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
             {
                 if (success)
                 {
                     NSLog(@"Doc:%@ Object:%@",doc, dirEnum.allObjects);
                     [appDelegate HideActivity];
                 }
             }];
            [[NSUbiquitousKeyValueStore defaultStore] synchronize];

        }
    }
}

#pragma mark - iCloud restore Data
-(void)getIcloudData{
    
    [appDelegate ShowActivity:@""];
    [MKiCloudSync start:@"restore"];
    [[NSUbiquitousKeyValueStore defaultStore]synchronize];
    
    self.query = [[NSMetadataQuery alloc] init];
    [self.query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"%K like 'SimpleShape____*'", NSMetadataItemFSNameKey];
    [self.query setPredicate:pred];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:self.query];
    [self.query startQuery];
    
}
-(void) ubiquitousKeyValueStoreDidChange: (NSNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Change detected"
                          message:@"iCloud key-value store change detected"
                          delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil];
   // [alert show];
}
- (void)updateKVStoreItems:(NSNotification*)notification {
    // Get the list of keys that changed.
    NSDictionary* userInfo = [notification userInfo];
    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSInteger reason = -1;
    
    // If a reason could not be determined, do not update anything.
    if (!reasonForChange)
        return;
    
    // Update only for changes from the server.
    reason = [reasonForChange integerValue];
    if ((reason == NSUbiquitousKeyValueStoreServerChange) ||
        (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        // If something is changing externally, get the changes
        // and update the corresponding keys locally.
        NSArray* changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        // This loop assumes you are using the same key names in both
        // the user defaults database and the iCloud key-value store
        for (NSString* key in changedKeys) {
            id value = [store objectForKey:key];
            [userDefaults setObject:value forKey:key];
        }
    }
}
- (void)queryDidFinishGathering:(NSNotification *)notification
{
    NSMetadataQuery *query1 = [notification object];
    
    [query1 disableUpdates];
    [query1 stopQuery];
    
    [self performSelectorOnMainThread:@selector(loadData:) withObject:self.query waitUntilDone:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query1];
    
    self.query = nil;
}
- (void)loadData:(NSMetadataQuery *)query1
{
    NSLog(@"Load data started");
    BOOL isFileFound = FALSE;
    
    NSLog(@"\n totalResult = %lu",(unsigned long)[[query1 results] count]);
    if([[query1 results]count] == 0){
        [appDelegate alertMessage:@"No iCloud Back Up Found"];
        return;
    }
    
    __block int loopCount = 0;
    for (NSMetadataItem *item in [query1 results])
    {
        
        NSLog(@"\n loopCount = %d",loopCount);
        isFileFound = TRUE;
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        Note *doc = [[Note alloc] initWithFileURL:url];
        NSString*fileNameFromiCloud = [NSString stringWithFormat:@"%@",url];
        NSArray*originalFileNameArray = [fileNameFromiCloud componentsSeparatedByString:@"/"];
        
        NSString*originalFileName = [originalFileNameArray objectAtIndex:([originalFileNameArray count]-1)];
        originalFileNameArray = [originalFileName componentsSeparatedByString:@"____"];
        originalFileName = [originalFileNameArray objectAtIndex:([originalFileNameArray count]-1)];
        
        [doc openWithCompletionHandler:^(BOOL success)
         {
             if (success)
             {
                 loopCount ++;
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 NSString *documentsDir = [paths objectAtIndex:0];
                 //NSString *root = [documentsDir stringByAppendingPathComponent:@"PropertyDB.sqlite"];
                 NSString *root = [documentsDir stringByAppendingPathComponent:originalFileName];
                 
                 [doc.noteDataContent writeToFile:root atomically:YES];
                 //                 [self loadUI];
                 if([[query1 results]count]==loopCount)
                     [self RestoreData];
             }
         }];
    }
    NSLog(@"Load data ended.");
}
-(void)RestoreData
{
    NSLog(@"Load data Completed.");
    [appDelegate HideActivity];
    db = [VIDatabase databaseWithName:kDBName];
    
	if (![db open]) {
		NSLog(@"Could not open db.");
	}else {
		NSLog(@"Open db.");
	}
    appDelegate.UserId = 1;
    [[NSUserDefaults standardUserDefaults]setInteger:appDelegate.UserId forKey:@"USERID"];
    objUserController.nId = appDelegate.UserId;
    [appDelegate alertMessage:@"Restore Completed Successfully"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    //NSString *root = [documentsDir stringByAppendingPathComponent:@"PropertyDB.sqlite"];
    NSArray *arrDict = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:documentsDir error:nil];
    if(arrDict.count>1)
    {
        NSString *profilePath = [documentsDir stringByAppendingPathComponent:@"ProfileZip.zip"];
        ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:profilePath];
        NSInteger result = [archive inflateToDirectory:ProfilePath usingResourceFork:NO];
        
        NSString *tempPath = [documentsDir stringByAppendingPathComponent:@"tempZip.zip"];
        ZKFileArchive *archive1 = [ZKFileArchive archiveWithArchivePath:tempPath];
        NSInteger result1 = [archive1 inflateToDirectory:TempPath usingResourceFork:NO];
        
        [self renameDirectory];
    }
}
- (void)refreshCloudListAfterSetup {
    // Reclaim delegate and then update files
    [[iCloud sharedCloud] setDelegate:self];
    [[iCloud sharedCloud] updateFiles];
}
-(void)renameDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *strSourcePath = [LibraryPathLocal stringByAppendingPathComponent:@"Profile 2"];
    NSString *strDestinationPath = [LibraryPathLocal stringByAppendingPathComponent:@"Profile"];
    [fileManager moveItemAtPath:strSourcePath toPath:strDestinationPath error:nil];
    
    NSString *strSourcePath1 = [LibraryPathLocal stringByAppendingPathComponent:@"temp 2"];
    NSString *strDestinationPath1 = [LibraryPathLocal stringByAppendingPathComponent:@"temp"];
    [fileManager moveItemAtPath:strSourcePath1 toPath:strDestinationPath1 error:nil];
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
