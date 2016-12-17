//
//  ProfileViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 01/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSAdvancedPicker.h"
#import <QuartzCore/QuartzCore.h>

#import "DGSwitch.h"
#import "UserInfo.h"
#import "DBController.h"

@interface UpdateProfileViewController : UIViewController <KSAdvancedPickerDataSource, KSAdvancedPickerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    KSAdvancedPicker *ap;
    KSAdvancedPicker *ap1;
    KSAdvancedPicker *ap2;
    KSAdvancedPicker *ap3;
    
    IBOutlet UIImageView *imgStick, *imgLevel;
    IBOutlet UITextField *txtName;
    IBOutlet UILabel *lblGender;
    IBOutlet UILabel *lblBMI;
    IBOutlet UILabel *BMIDigit;
    IBOutlet UILabel *BMILevel;
    
    IBOutlet UILabel *lblAgeTitle;
    IBOutlet UILabel *lblHeightTitle;
    IBOutlet UILabel *lblWeightTitle;
     IBOutlet UILabel *lblGoalweightTitle;
    IBOutlet UILabel *lblTakePhotoTitle;
    
    
    IBOutlet UIView *pickerVw;
    IBOutlet UIView *HeightPickerVw;
    IBOutlet UIView *WeightPickerVw;
    IBOutlet UIView *goalWeightPickerVw;
    IBOutlet UIView *topView;
    
    NSMutableArray *arrAge;
    NSMutableArray *arrHeight;
    NSMutableArray *arrWeight;
    NSMutableArray *arrGoalweight;
    NSMutableArray *arrFixedHeightInch;
    NSMutableArray *arrHeightInch;

    
    NSMutableArray *arrLoadData ,*arrFixedHeight, *arrFixedWeight, *arrFixedGoalWeight;
    
    IBOutlet UIScrollView *scrollMain, *scrGlobal;
    IBOutlet UIImageView *imgUserPhoto;
    IBOutlet UIPageControl *pageController;
    
    IBOutlet UISwitch *switchMF;
    
    BOOL isBtnKGClicked;
    BOOL isBtnCMClicked;
    BOOL isBtnGoalKGClicked;
    
    IBOutlet UIButton *btnKG;
    IBOutlet UIButton *btnCM;
    IBOutlet UIButton *btnGoalKG;
    
    NSString *strAge, *strWeight, *strHeight, *strImagePath;
    NSString *strMaleFemale;
    UIImagePickerController *imgPicker;
    
    int BMI;
    
    BOOL isfirst;
    BOOL isfirst1;
}

@property (nonatomic, strong) IBOutlet DGSwitch *mySwitch;
@property (nonatomic,strong) UserInfo *objUserInfo;

-(IBAction)takePhotoBtn_click:(id)sender;
-(IBAction) onChange:(DGSwitch *)theSwitch;

-(IBAction)weightBtn_click:(id)sender;
-(IBAction)heightBtn_click:(id)sender;
-(IBAction)goalWeightBtn_click:(id)sender;

-(IBAction)btnBack:(id)sender;
-(IBAction)btnDone:(id)sender;
- (IBAction)pageCtrlChanged:(id)sender;

@end
