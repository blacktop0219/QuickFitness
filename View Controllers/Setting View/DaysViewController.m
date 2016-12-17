//
//  DaysViewController.m
//  SexyShape
//
//  Created by Mitesh Panchal on 22/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import "DaysViewController.h"
#import "NotificationViewController.h"

@interface DaysViewController ()

@end

@implementation DaysViewController
@synthesize deleg;

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
    
    self.title = @"Days";
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 35);
    [btnBack setImage:[UIImage imageNamed:@"Back_Btn.png"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(BackBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItme = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItme;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 27, 23);
    [btnRight setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    
    [btnRight addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItme = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightItme;

    arrayDays = [[NSMutableArray alloc]initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
}
-(void)viewWillAppear:(BOOL)animated
{
      NotificationViewController *obj = (NotificationViewController *)deleg;
        obj.tDictDaysReminder= [[NSMutableDictionary alloc]init];
}

#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayDays.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CELl";
    UILabel *lblText;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblText =[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 160, 40)];
        lblText.textColor = [UIColor whiteColor];
        lblText.font = [UIFont fontWithName:kHelveticaNeueThin size:22];
        [cell.contentView addSubview:lblText];
    }
    lblText = (UILabel *)[cell.contentView.subviews objectAtIndex:0];
    lblText.text =[arrayDays objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [arrSelectedTime addObject:[arrItems objectAtIndex:indexPath.row]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NotificationViewController *obj = (NotificationViewController *)deleg;
   
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [obj.tDictDaysReminder removeObjectForKey:[arrayDays objectAtIndex:indexPath.row]];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
         [obj.tDictDaysReminder setObject:[NSString stringWithFormat:@"%d",indexPath.row+1] forKey:[arrayDays objectAtIndex:indexPath.row]];
    }
}
-(void)BackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtn
{
    [self.navigationController popViewControllerAnimated:YES];
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
