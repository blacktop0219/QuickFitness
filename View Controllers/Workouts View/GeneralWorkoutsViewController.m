//
//  GeneralWorkoutsViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 04/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "GeneralWorkoutsViewController.h"
#import "DetailsWorkoutViewController.h"

@interface GeneralWorkoutsViewController ()

@end

@implementation GeneralWorkoutsViewController

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
    if(appDelegate.SelectedBtnType==71)
    {
        NSLog(@"appDelegate.arrAllWorkOuts for title is%@",[appDelegate.arrAllWorkOuts valueForKey:@"strTitle"]);

    }
    else if(appDelegate.SelectedBtnType==72)
    {
        NSLog(@"appDelegate.arrIntermidiateWorkOuts for title is%@",[appDelegate.arrIntermidiateWorkOuts valueForKey:@"strTitle"]);

    }
    else if(appDelegate.SelectedBtnType==73)
    {
        NSLog(@"appDelegate.arrExpertSeriesWorkOuts for title is%@",[appDelegate.arrExpertSeriesWorkOuts valueForKey:@"strTitle"]);
        
    }
    else if(appDelegate.SelectedBtnType==74)
    {
        NSLog(@"appDelegate.arrButtWorkOuts for title is%@",[appDelegate.arrButtWorkOuts valueForKey:@"strTitle"]);
        
    }
     [self reloadScrollview];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 40, 35);
    [btnBack setImage:[UIImage imageNamed:@"Back_Btn.png"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(BackBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItme = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItme;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = FALSE;
    [self.view addSubview:appDelegate.adBanner];
    [self.view addSubview:appDelegate.btnHideAd];
    [self.view addSubview:appDelegate.btnRemoveAd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
  
}

-(void)reloadScrollview
{
    
    if(appDelegate.SelectedBtnType==71)
    {
        int x=5;
        int y=10;
        for(int i=1;i<=[[appDelegate.arrAllWorkOuts valueForKey:@"strTitle"]count];i++)
        {
            UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(x, y, 100, 150)];
            
            
            UIButton *btnV=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            btnV.backgroundColor=[UIColor orangeColor];
            [btnV addTarget:self action:@selector(Btn_click:) forControlEvents:UIControlEventTouchUpInside];
            [btnV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Default%d.png",i]] forState:UIControlStateNormal];
            btnV.tag=7000+i;
            [view1 addSubview:btnV];
            
            
            UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 42)];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.numberOfLines=2;
            lbl.textColor=[UIColor whiteColor];
            lbl.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0];
            lbl.text= [[appDelegate.arrAllWorkOuts objectAtIndex:i-1]valueForKey:@"strTitle"];
            [view1 addSubview:lbl];
            
            [scrView addSubview:view1];
            x=x+105;
            if(i%3==0)
            {
                x=5;
                y=y+150;
            }
            
        }
        float d=[[appDelegate.arrAllWorkOuts valueForKey:@"strTitle"]count]/3;
        [scrView setContentSize:CGSizeMake(scrView.frame.size.width, (d*160)+160)];
        
        NSLog(@"%u",(([[appDelegate.arrAllWorkOuts valueForKey:@"strTitle"]count]/3)*150)+160);

    }
    else if(appDelegate.SelectedBtnType==72)
    {
        int x=5;
        int y=10;
        for(int i=1;i<=[[appDelegate.arrIntermidiateWorkOuts valueForKey:@"strTitle"]count];i++)
        {
            UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(x, y, 100, 150)];
            
            
            UIButton *btnV=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            btnV.backgroundColor=[UIColor orangeColor];
            [btnV addTarget:self action:@selector(Btn_click:) forControlEvents:UIControlEventTouchUpInside];
            [btnV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Intermediate%d.png",i]] forState:UIControlStateNormal];
            btnV.tag=7000+i;
            [view1 addSubview:btnV];
            
            
            UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 42)];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.numberOfLines=2;
            lbl.textColor=[UIColor whiteColor];
            lbl.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0];
            lbl.text= [[appDelegate.arrIntermidiateWorkOuts objectAtIndex:i-1]valueForKey:@"strTitle"];
            [view1 addSubview:lbl];
            
            [scrView addSubview:view1];
            x=x+105;
            if(i%3==0)
            {
                x=5;
                y=y+150;
            }
            
        }
        float d=[[appDelegate.arrIntermidiateWorkOuts valueForKey:@"strTitle"]count]/3;
        [scrView setContentSize:CGSizeMake(scrView.frame.size.width, (d*170))];
        
        NSLog(@"%u",(([[appDelegate.arrIntermidiateWorkOuts valueForKey:@"strTitle"]count]/3)*170));

    }
    else if(appDelegate.SelectedBtnType==73)
    {
        int x=5;
        int y=10;
        for(int i=1;i<=[[appDelegate.arrExpertSeriesWorkOuts valueForKey:@"strTitle"]count];i++)
        {
            UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(x, y, 100, 150)];
            
            
            UIButton *btnV=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            btnV.backgroundColor=[UIColor orangeColor];
            [btnV addTarget:self action:@selector(Btn_click:) forControlEvents:UIControlEventTouchUpInside];
            [btnV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Expert%d.png",i]] forState:UIControlStateNormal];
            btnV.tag=7000+i;
            [view1 addSubview:btnV];
            
            
            UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 42)];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.numberOfLines=2;
            lbl.textColor=[UIColor whiteColor];
            lbl.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0];
            lbl.text= [[appDelegate.arrExpertSeriesWorkOuts objectAtIndex:i-1]valueForKey:@"strTitle"];
            [view1 addSubview:lbl];
            
            [scrView addSubview:view1];
            x=x+105;
            if(i%3==0)
            {
                x=5;
                y=y+150;
            }
            
        }
        float d=[[appDelegate.arrExpertSeriesWorkOuts valueForKey:@"strTitle"]count]/3;
        [scrView setContentSize:CGSizeMake(scrView.frame.size.width, (d*170))];
        
        NSLog(@"%u",(([[appDelegate.arrExpertSeriesWorkOuts valueForKey:@"strTitle"]count]/3)*170));

    }
    else if(appDelegate.SelectedBtnType==74)
    {
        int x=5;
        int y=10;
        for(int i=1;i<=[[appDelegate.arrButtWorkOuts valueForKey:@"strTitle"]count];i++)
        {
            UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(x, y, 100, 150)];
            
            
            UIButton *btnV=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            btnV.backgroundColor=[UIColor orangeColor];
            [btnV addTarget:self action:@selector(Btn_click:) forControlEvents:UIControlEventTouchUpInside];
            [btnV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"butt%d.png",i]] forState:UIControlStateNormal];
            btnV.tag=7000+i;
            [view1 addSubview:btnV];
            
            
            UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 42)];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.numberOfLines=2;
            lbl.textColor=[UIColor whiteColor];
            lbl.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0];
            lbl.text= [[appDelegate.arrButtWorkOuts objectAtIndex:i-1]valueForKey:@"strTitle"];
            [view1 addSubview:lbl];
            
            [scrView addSubview:view1];
            x=x+105;
            if(i%3==0)
            {
                x=5;
                y=y+150;
            }
            
        }
        float d=[[appDelegate.arrButtWorkOuts valueForKey:@"strTitle"]count]/3;
        [scrView setContentSize:CGSizeMake(scrView.frame.size.width, (d*170))];
        
        NSLog(@"%u",(([[appDelegate.arrButtWorkOuts valueForKey:@"strTitle"]count]/3)*170));

    }
}
#pragma mark - Custom Method -

-(void)BackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction Events -

-(IBAction)Btn_click:(id)sender
{
    UIButton *btn = sender;
    DetailsWorkoutViewController *objDetailsWorkoutViewController = [[DetailsWorkoutViewController alloc] initWithNibName:@"DetailsWorkoutViewController" bundle:nil];
    
   // ADTransition *trans = [[ADGlueTransition alloc] initWithDuration:0.9f orientation:ADTransitionRightToLeft sourceRect:self.view.bounds];
    
   // objDetailsWorkoutViewController.transition = trans;
    objDetailsWorkoutViewController.SelectedIndex = btn.tag-7000;
    [self.navigationController pushViewController:objDetailsWorkoutViewController animated:YES];
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
