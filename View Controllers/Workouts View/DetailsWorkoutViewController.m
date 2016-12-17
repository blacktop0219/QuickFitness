//
//  DetailsWorkoutViewController.m
//  QuickFitness
//
//  Created by Ashish Sudra on 04/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import "DetailsWorkoutViewController.h"
#import "UIImage+animatedGIF.h"
#import "WorkoutsObjects.h"

@interface DetailsWorkoutViewController ()

@end

@implementation DetailsWorkoutViewController

@synthesize lblTitle, SelectedIndex;

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
}

-(void)viewWillAppear:(BOOL)animated
{
     view_Av=[[UIView alloc]initWithFrame:WorkoutVw.frame];
    view_Av.backgroundColor=[UIColor whiteColor];
    selected_BtnTag=101;
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = TRUE;
    [self setfont];
    [self Btn_click:btnImage];
    //[self SelectImage];
    [self SetStepsRelatedIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Events -

-(IBAction)closeBtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)Btn_click:(id)sender
{
    btnImage.selected = FALSE;
    btnVideo.selected = FALSE;
    btnDetails.selected = FALSE;
    
    UIButton *btn = sender;
    btn.selected = TRUE;
    txtSteps.hidden = TRUE;
    NSLog(@"btn.tag is%d",btn.tag);
    switch (btn.tag) {
        case 101:
        {
            view_Av.hidden=TRUE;
            selected_BtnTag=101;
            [btnImage setImage:[UIImage imageNamed:@"WD_Image_sel.png"] forState:UIControlStateNormal];
            [btnVideo setImage:[UIImage imageNamed:@"WD_Video.png"] forState:UIControlStateNormal];
            [btnDetails setImage:[UIImage imageNamed:@"WD_Detail.png"] forState:UIControlStateNormal];
            imgSeparator.hidden = FALSE;
            imgSeparator.frame = CGRectMake(imgSeparator.frame.origin.x, 317, imgSeparator.frame.size.width, imgSeparator.frame.size.height);
            
            [self SelectImage];
        }
            break;

        case 102:
        {
            view_Av.hidden=FALSE;
            selected_BtnTag=102;
            [btnImage setImage:[UIImage imageNamed:@"WD_Image.png"] forState:UIControlStateNormal];
            [btnVideo setImage:[UIImage imageNamed:@"WD_Video_sel.png"] forState:UIControlStateNormal];
            [btnDetails setImage:[UIImage imageNamed:@"WD_Detail.png"] forState:UIControlStateNormal];

            imgSeparator.hidden = TRUE;
            [self selectVideo];
        }
            break;

        case 103:
        {
            view_Av.hidden=TRUE;
            selected_BtnTag=103;
            [btnImage setImage:[UIImage imageNamed:@"WD_Image.png"] forState:UIControlStateNormal];
            [btnVideo setImage:[UIImage imageNamed:@"WD_Video.png"] forState:UIControlStateNormal];
            [btnDetails setImage:[UIImage imageNamed:@"WD_Detail_sel.png"] forState:UIControlStateNormal];

            imgSeparator.hidden = FALSE;
            imgSeparator.frame = CGRectMake(imgSeparator.frame.origin.x, 251, imgSeparator.frame.size.width, imgSeparator.frame.size.height);
            ImgWorkout.image = [UIImage imageNamed:@"a.png"];
            txtSteps.hidden = FALSE;
            [self SetStepsRelatedIndex];
            txtSteps.text = strDesplayStrings;
        }
            break;

        default:
            break;
    }
}

-(IBAction)previousBtn_click:(id)sender
{
    
    
    if(appDelegate.SelectedBtnType==71)
    {
        
    }
    else if(appDelegate.SelectedBtnType==72)
    {
        
    }
    else if(appDelegate.SelectedBtnType==73)
    {
        
    }
    else if(appDelegate.SelectedBtnType==74)
    {
        
    }

    if(SelectedIndex > 1)
    {
        SelectedIndex--;
        if(selected_BtnTag==101)
        {
            [self Btn_click:btnImage];
        }
        else if(selected_BtnTag==102)
        {
            if(player)
            {
//                [player pause];
                //[player removeAllItems];
//                player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
//                player = nil;
            }

            [self Btn_click:btnVideo];
        }
        else if(selected_BtnTag==103)
        {
            [self Btn_click:btnDetails];
        }

    }
}

-(IBAction)nextBtn_click:(id)sender
{
    if(appDelegate.SelectedBtnType==71)
    {
        if(SelectedIndex < appDelegate.arrAllWorkOuts.count)
        {
            SelectedIndex++;
            if(selected_BtnTag==101)
            {
                [self Btn_click:btnImage];
            }
            else if(selected_BtnTag==102)
            {
                if(player)
                {
//                    [player pause];
                    //[player removeAllItems];
//                    player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
                    player = nil;
                    
                }
                
                [self Btn_click:btnVideo];
            }
            else if(selected_BtnTag==103)
            {
                [self Btn_click:btnDetails];
            }
            
            
        }

    }
    else if(appDelegate.SelectedBtnType==72)
    {
        if(SelectedIndex < appDelegate.arrIntermidiateWorkOuts.count)
        {
            SelectedIndex++;
            if(selected_BtnTag==101)
            {
                [self Btn_click:btnImage];
            }
            else if(selected_BtnTag==102)
            {
                if(player)
                {
                    [player pause];
                    //[player removeAllItems];
                    player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
                    player = nil;
                }
                
                [self Btn_click:btnVideo];
            }
            else if(selected_BtnTag==103)
            {
                [self Btn_click:btnDetails];
            }
            
            
        }

    }
    else if(appDelegate.SelectedBtnType==73)
    {
        if(SelectedIndex < appDelegate.arrExpertSeriesWorkOuts.count)
        {
            SelectedIndex++;
            if(selected_BtnTag==101)
            {
                [self Btn_click:btnImage];
            }
            else if(selected_BtnTag==102)
            {
                if(player)
                {
                    [player pause];
                    //[player removeAllItems];
                    player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
                    player = nil;
                }
                
                [self Btn_click:btnVideo];
            }
            else if(selected_BtnTag==103)
            {
                [self Btn_click:btnDetails];
            }
            
            
        }

    }
    else if(appDelegate.SelectedBtnType==74)
    {
        if(SelectedIndex < appDelegate.arrButtWorkOuts.count)
        {
            SelectedIndex++;
            if(selected_BtnTag==101)
            {
                [self Btn_click:btnImage];
            }
            else if(selected_BtnTag==102)
            {
                if(player)
                {
                    [player pause];
                    //[player removeAllItems];
                    player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
                    player = nil;
                }
                
                [self Btn_click:btnVideo];
            }
            else if(selected_BtnTag==103)
            {
                [self Btn_click:btnDetails];
            }
            
            
        }

    }

   }

#pragma mark - Custom Events -
-(void)setfont
{

    lblTitle.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize22];
    txtSteps.font = [UIFont fontWithName:kHelveticaNeueThin size:kFontSize17];
}

-(void)SelectImage
{
    if(player)
    {
        [player pause];
        //[player removeAllItems];
        player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
        player = nil;
    }
     [WorkoutVw bringSubviewToFront:ImgWorkout];
    WorkoutsObjects *wo;
    if(appDelegate.SelectedBtnType==71)
    {
        wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex-1];
    }
    else if(appDelegate.SelectedBtnType==72)
    {
        wo = [appDelegate.arrIntermidiateWorkOuts objectAtIndex:SelectedIndex-1];
    }
    else if(appDelegate.SelectedBtnType==73)
    {
        wo = [appDelegate.arrExpertSeriesWorkOuts objectAtIndex:SelectedIndex-1];
    }
    else if(appDelegate.SelectedBtnType==74)
    {
        wo = [appDelegate.arrButtWorkOuts objectAtIndex:SelectedIndex-1];
    }
    ImgWorkout.image = [UIImage imageNamed:wo.strImageUrl];
    lblTitle.text = wo.strTitle;
}

-(void)selectVideo
{
//    WorkoutsObjects *wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex];
//     NSURL *GifUrl = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@",wo.strVideoUrl] withExtension:@"gif"];
//    ImgWorkout.image = [UIImage animatedImageWithAnimatedGIFURL:GifUrl];
    [self playVideoRepeat];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification
{
    // Will be called when AVPlayer finishes playing playerItem
    if(selected_BtnTag==102)
    {
       // [view_Av.layer removeFromSuperlayer];
        //[view_Av removeFromSuperview];
        [self playVideoRepeat];
       // [self performSelector:@selector(playVideoRepeat) withObject:nil afterDelay:0.01];
    }
}

-(void)playVideoRepeat
{
    WorkoutsObjects *wo;
    if(appDelegate.SelectedBtnType==71)
    {
        wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex-1];
    }
    else if(appDelegate.SelectedBtnType==72)
    {
        wo = [appDelegate.arrIntermidiateWorkOuts objectAtIndex:SelectedIndex-1];
    }
    else if(appDelegate.SelectedBtnType==73)
    {
        wo = [appDelegate.arrExpertSeriesWorkOuts objectAtIndex:SelectedIndex-1];
    }
    else if(appDelegate.SelectedBtnType==74)
    {
        wo = [appDelegate.arrButtWorkOuts objectAtIndex:SelectedIndex-1];
    }

    
    lblTitle.text = wo.strTitle;
    NSString *strVideo = wo.strVideoUrl;
    NSLog(@"strVideo is %@",strVideo);
    NSURL * VideoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:strVideo ofType:@"mov"]];
    
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:VideoURL];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    if(player)
    {
        player = nil;
    }
   /*
    player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    AVPlayerLayer *layer = [AVPlayerLayer layer];
    */
    
    player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
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
    
    [player play];
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
        player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];

        player = nil;
    }
    [WorkoutVw bringSubviewToFront:ImgWorkout];
    [WorkoutVw bringSubviewToFront:txtSteps];

    WorkoutsObjects *wo;
    if(appDelegate.SelectedBtnType==71)
    {
        wo = [appDelegate.arrAllWorkOuts objectAtIndex:SelectedIndex-1];
    }
    else if(appDelegate.SelectedBtnType==72)
    {
        wo = [appDelegate.arrIntermidiateWorkOuts objectAtIndex:SelectedIndex-1];
    }
    else if(appDelegate.SelectedBtnType==73)
    {
        wo = [appDelegate.arrExpertSeriesWorkOuts objectAtIndex:SelectedIndex-1];
    }
    else if(appDelegate.SelectedBtnType==74)
    {
        wo = [appDelegate.arrButtWorkOuts objectAtIndex:SelectedIndex-1];
    }
    strDesplayStrings = wo.strSteps;
    lblTitle.text = wo.strTitle;
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
