//
//  AchievementsViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "AchievementsViewController.h"
#import "AchievementsCell.h"
#import "AchievementsObjects.h"

@interface AchievementsViewController ()

@end

@implementation AchievementsViewController

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
    self.title = @"Achievements";
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 35);
    [btnBack setImage:[UIImage imageNamed:@"Back_Btn.png"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(BackBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItme = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItme;
    
    arrLockedData = [DBController getAchievementTrueObject:appDelegate.UserId];
    arrUnLockedData = [DBController getAchievementFalseObject:appDelegate.UserId];
//    [self LoadLockObjects];
    
    tblVw.backgroundColor = [UIColor clearColor];
    [self setFont];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = FALSE;
    isLock = TRUE;
     [tblVw reloadData];
    
    [self.view addSubview:appDelegate.btnHideAd];
    [self.view addSubview:appDelegate.btnRemoveAd];
    [self.view addSubview:appDelegate.adBanner];
    
    if(appDelegate.isIphone5){
    if([appDelegate.adBanner isHidden]){
        tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width,444);
    }else{
        tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width,400);
    }
    }else{
        if([appDelegate.adBanner isHidden]){
            tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width,356);
        }else{
            tblVw.frame = CGRectMake(tblVw.frame.origin.x, tblVw.frame.origin.y, tblVw.frame.size.width,312);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadLockObjects
{
    AchievementsObjects *ao = [AchievementsObjects new];
    ao.strTitle = @"Full House";
    ao.strDetails = @"Complete all exercises in any exercise routine";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Tell a Friend";
    ao.strDetails = @"Share your workout results on your social media";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Weigh-In";
    ao.strDetails = @"Enter your weight after your first workout";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Weigh-In Master";
    ao.strDetails = @"Enter weigh in yourself after 4 weeks";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"8 weeks Fit Challenge";
    ao.strDetails = @"Complete 8 weeks";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"3 months Thin";
    ao.strDetails = @"Complete 12 weeks";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Persistence";
    ao.strDetails = @"4 days in a row";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Good Start";
    ao.strDetails = @"6 days in a row";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Commitment";
    ao.strDetails = @"2 weeks in a row";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Intense Week";
    ao.strDetails = @"7 days of workout";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"First Spark";
    ao.strDetails = @"3 days in a row";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"On Fire";
    ao.strDetails = @"6 months completion";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"1 Year champion";
    ao.strDetails = @"One year of completion";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Ultimate Challenger";
    ao.strDetails = @"Complete fitness at most difficulty level";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Rise and shine";
    ao.strDetails = @"Working out between 4 and 10 am";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"First timer";
    ao.strDetails = @"Completing a workout session the first time";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Double Trouble";
    ao.strDetails = @"Completing a workout twice in a single day";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
    
    ao = [AchievementsObjects new];
    ao.strTitle = @"Triple Threat";
    ao.strDetails = @"Completing a workout three times in a single day";
    ao.strIconImage = @"A_cell2";
    [arrLockedData addObject:ao];
    ao = nil;
}

-(void)BackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction Events -

-(IBAction)lockUnlockBtn_click:(id)sender
{
    btnLock.selected = FALSE;
    btnUnlock.selected = FALSE;
    
    UIButton *btnTemp = sender;
    btnTemp.selected = TRUE;
    
    switch (btnTemp.tag) {
        case 101:
            isLock = FALSE;
            break;

        case 102:
            isLock = TRUE;
            break;

        default:
            break;
    }
    
    [tblVw reloadData];
}

#pragma mark - TableView Events
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(isLock){
        return arrLockedData.count;
    }
    else{
        return arrUnLockedData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AchievementsCell";
    
    AchievementsCell *cell = (AchievementsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        
        cell.lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize18];
        cell.lblDetails.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
        cell.lblDate.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize15];
        cell.lblImgBottom.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(isLock){
        AchievementsObjects *ao = [arrLockedData objectAtIndex:indexPath.row];
        
        cell.imgIcon.image = [UIImage imageNamed:@"A_cell2"];
        cell.lblDate.hidden = TRUE;
        cell.lblImgBottom.hidden = TRUE;
        cell.lblTitle.text = ao.strTitle;
        cell.lblDetails.text = ao.strDetails;
    }
    else{
        AchievementsObjects *ao = [arrUnLockedData objectAtIndex:indexPath.row];
        
        cell.imgIcon.image = [UIImage imageNamed:ao.strIconImage];
        cell.lblDate.hidden = TRUE;
        cell.lblImgBottom.hidden = TRUE;
        cell.lblTitle.text = ao.strTitle;
        cell.lblDetails.text = ao.strDetails;
        
       /* cell.imgIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"A_cell%ld", (long)indexPath.row]];
        cell.lblDate.hidden = FALSE;
        cell.lblImgBottom.hidden = FALSE;
        
        switch (indexPath.row) {
            case 0:
                cell.lblTitle.text = @"First Time";
                cell.lblDetails.text = @"1st time ''7 Minute Workout'' perfomed";
                cell.lblDate.text = @"4 Feb,2013";
                cell.lblImgBottom.text = @"1X";
                break;
                
            case 1:
                cell.lblTitle.text = @"Stamina Master";
                cell.lblDetails.text = @"Longest duration workout";
                cell.lblDate.text = @"7 Feb,2013";
                cell.lblImgBottom.text = @"3X";
                break;
                
            default:
                break;
        }*/
    }

    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Custom Method -

-(void)setFont
{
    btnLock.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
    btnUnlock.titleLabel.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
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
