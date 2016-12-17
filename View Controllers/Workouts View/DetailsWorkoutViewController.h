//
//  DetailsWorkoutViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 04/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DetailsWorkoutViewController : UIViewController
{
    IBOutlet UIView *WorkoutVw;
    IBOutlet UIButton *btnImage;
    IBOutlet UIButton *btnVideo;
    IBOutlet UIButton *btnDetails;
    IBOutlet UIImageView *imgSeparator;
    
    IBOutlet UIImageView *ImgWorkout;
    IBOutlet UITextView *txtSteps;
    
    NSString *strDesplayStrings;
    AVPlayer* player;
    BOOL selected_BtnTag;
    UIView *view_Av;
}

@property (nonatomic) NSInteger SelectedIndex;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;

-(IBAction)closeBtn_click:(id)sender;
-(IBAction)Btn_click:(id)sender;

-(IBAction)previousBtn_click:(id)sender;
-(IBAction)nextBtn_click:(id)sender;

@end
