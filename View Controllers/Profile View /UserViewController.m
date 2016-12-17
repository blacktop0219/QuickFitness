//
//  UserViewController.m
//  SexyShape
//
//  Created by Mitesh Panchal on 26/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import "UserViewController.h"
#import "ProfileViewController.h"
#import "HomeViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController
@synthesize nId;

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
    // Do any additional setup after loading the view from its nib.
     self.title = @"Users";
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 35);
    [btnBack setImage:[UIImage imageNamed:@"Back_Btn.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItme = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItme;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 45, 35);
    [btnRight setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    
    [btnRight addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItme = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightItme;
}
-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBarHidden = FALSE;
    arrUsers  = [DBController getUsers];
    nId = appDelegate.UserId;
    [self reloadViews];
    [self.view addSubview:appDelegate.adBanner];
    [self.view addSubview:appDelegate.btnHideAd];
    [self.view addSubview:appDelegate.btnRemoveAd];
}
-(void)reloadViews
{
    [[scrView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i=0;i<arrUsers.count;i++){
        UIImageView *imgUserBg = [[UIImageView alloc]initWithFrame:CGRectMake((i*110)+10, 5, 80, 80)];
        imgUserBg.image = [UIImage imageNamed:@"AddUser.png"];
        
        UIImageView *imgUser =[[UIImageView alloc]initWithFrame:CGRectMake((i*110)+19, 14, 62, 62)];
        imgUser.backgroundColor  =[UIColor grayColor];
        
        imgUser.layer.masksToBounds = YES;
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2;
        [scrView addSubview:btnNewUser];
        [btnNewUser setFrame:CGRectMake(((i+1)*110)+10, 5, 80, 80)];
        
        UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(i*110+15, 72, 75, 65)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.numberOfLines = 2;
        lblName.textColor = [UIColor blackColor];
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.font = [UIFont fontWithName:kHelveticaNeueThin size:17];
        
        UIButton *btnSelected = [[UIButton alloc]initWithFrame:CGRectMake(i*108+68, 11, 22, 22)];
        btnSelected.backgroundColor = [UIColor clearColor];
        btnSelected.tag = 401+i;
        [btnSelected setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btnSelected setBackgroundImage:[UIImage imageNamed:@"selectedUser.png"] forState:UIControlStateSelected];
        if(i+1 == appDelegate.UserId)
            [btnSelected setSelected:TRUE];
        else
            [btnSelected setSelected:FALSE];
        
        UIButton *btnUser = [[UIButton alloc]initWithFrame:imgUser.frame];
        btnUser.tag = 601+i;
        [btnUser addTarget:self action:@selector(selectUser:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 1.0;
        [btnUser addGestureRecognizer:longPress];
        
        UserInfo *obj = [arrUsers objectAtIndex:i];
        lblName.text = obj.strName;
         NSString *ImageURL = [ProfilePath stringByAppendingPathComponent:obj.strImageUrl];
        imgUser.image =[UIImage imageWithContentsOfFile:ImageURL];
        
        [scrView addSubview:imgUserBg];
        [scrView addSubview:imgUser];
        [scrView addSubview:lblName];
        [scrView addSubview:btnSelected];
        [scrView addSubview:btnUser];
    }
}
#pragma mark - Action Event Clicked

-(IBAction)back_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtn
{
    UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Change User" message:@"Are you sure want to active this user?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert show];
}
#pragma mark - AlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 701){
        if(buttonIndex == alertView.cancelButtonIndex){
            
        }else{
            if(nDeleteId+1 == appDelegate.UserId)
            {
                [appDelegate alertMessage:@"You can't delete current user"];
            }else{
            UserInfo *cdo = [arrUsers objectAtIndex:nDeleteId];
            [DBController deleteUserForId:cdo.nId];
            [arrUsers removeObjectAtIndex:nDeleteId];
            { ///====Update UserId
                NSString *strUpdateQuery = [NSString stringWithFormat:@"update UserDetails set id=id-1 where id>%d",cdo.nId];
                [db executeUpdate:strUpdateQuery];
                arrUsers = [DBController getUsers];
                if(appDelegate.UserId>cdo.nId){
                    appDelegate.UserId = appDelegate.UserId-1;
                    nId = appDelegate.UserId;
                    [[NSUserDefaults standardUserDefaults]setInteger:appDelegate.UserId forKey:@"USERID"];
                }
            }
                [self reloadViews];
            }
        }
    }else{
        if(buttonIndex==1){
            
            [[NSUserDefaults standardUserDefaults]setInteger:nId forKey:@"USERID"];
            appDelegate.UserId = nId;
           /* HomeViewController *objProfile;
            if(appDelegate.isIphone5){
                objProfile  = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            }else{
                objProfile  = [[HomeViewController alloc]initWithNibName:@"HomeViewController_i4" bundle:nil];
            }
            [self.navigationController pushViewController:objProfile animated:YES];*/
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(IBAction)btnNewUserClick:(id)sender
{
    ProfileViewController *objProfile;
    if(appDelegate.isIphone5){
       objProfile  = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    }else{
        objProfile  = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController_i4" bundle:nil];
    }
    [self.navigationController pushViewController:objProfile animated:YES];
}

-(void)selectUser:(UIButton *)btn
{
     nId = btn.tag-600;
    
    for(int tag=401;tag<404;tag++)
    {
        UIButton *myButton = (UIButton *)[self.view viewWithTag:tag];
        [myButton setSelected:FALSE];
    }
    UIButton *btnSelectUser = (UIButton *)[self.view viewWithTag:btn.tag-200];
    [btnSelectUser setSelected:TRUE];
}
#pragma mark - Gesture Recognizer
- (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    
    nDeleteId = [[sender view]tag]-601;
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long press Ended");
       
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press detected.");
        UIAlertView *alertDelete  = [[UIAlertView alloc]initWithTitle:appTitle message:@"Are you sure want to delete this User" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"yes", nil];
        alertDelete.tag = 701;
        [alertDelete show];
    }
}

#pragma mark - TableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return arrUsers.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(arrUsers.count<3)
        return btnNewUser;
    else
        return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CELl";
    UILabel *lblText; UIImageView *imgView;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = imgView.frame.size.width/2;
        [cell.contentView addSubview:imgView];
        
        lblText =[[UILabel alloc]initWithFrame:CGRectMake(65, 10, 180, 40)];
        lblText.textColor = [UIColor whiteColor];
        lblText.textAlignment = NSTextAlignmentLeft;
        lblText.font = [UIFont fontWithName:kHelveticaNeueThin size:25];
        [cell.contentView addSubview:lblText];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row+1 == appDelegate.UserId){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        nId = appDelegate.UserId;
    }
    imgView = (UIImageView *)[cell.contentView.subviews objectAtIndex:0];
    lblText = (UILabel *)[cell.contentView.subviews objectAtIndex:1];
    UserInfo *obj = [arrUsers objectAtIndex:indexPath.row];
    lblText.text = obj.strName;
    NSString *ImageURL = [ProfilePath stringByAppendingPathComponent:obj.strImageUrl];
    imgView.image =[UIImage imageWithContentsOfFile:ImageURL];
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
    nId = indexPath.row+1;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tv didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:nId-1 inSection:0];
        [tv selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        NSLog(@"didEndEditingRowAtIndexPath");
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row+1 != appDelegate.UserId){
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        UserInfo *cdo = [arrUsers objectAtIndex:indexPath.row];
        [DBController deleteUserForId:cdo.nId];
        [arrUsers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        { ///====Update UserId
            NSString *strUpdateQuery = [NSString stringWithFormat:@"update UserDetails set id=id-1 where id>%d",cdo.nId];
            [db executeUpdate:strUpdateQuery];
            arrUsers = [DBController getUsers];
            if(appDelegate.UserId>cdo.nId){
              appDelegate.UserId = appDelegate.UserId-1;
                nId = appDelegate.UserId;
                [[NSUserDefaults standardUserDefaults]setInteger:appDelegate.UserId forKey:@"USERID"];
            }
        }
    }
    }else {
        [appDelegate alertMessage:@"You can't delete current user"];
    }
}
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
