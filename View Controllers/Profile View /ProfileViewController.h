//
//  ProfileViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 01/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSAdvancedPicker.h"

#import "DGSwitch.h"
#import "UserInfo.h"

@class HomeViewController;

@interface ProfileViewController : UIViewController <KSAdvancedPickerDataSource,KSAdvancedPickerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate>
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
    
    NSMutableArray *arrAge;
    NSMutableArray *arrHeight;
    NSMutableArray *arrHeightInch;
    NSMutableArray *arrWeight;
    NSMutableArray *arrGoalweight;
    NSMutableArray *arrFixedHeightInch;
    
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
    HomeViewController *objHomeViewController;
    UIImagePickerController *imgPicker;
    
    int BMI;
    
    int heightCount;
    
    int previousHeightIndex;
    
    BOOL isfirst;
    BOOL isfirst1;
}

@property (nonatomic, strong) IBOutlet DGSwitch *mySwitch;
@property (nonatomic,strong) UserInfo *objUserInfo;

-(IBAction)takePhotoBtn_click:(id)sender;
-(IBAction) onChange:(DGSwitch *)theSwitch;

-(IBAction)goalWeightBtn_click:(id)sender;
-(IBAction)weightBtn_click:(id)sender;
-(IBAction)heightBtn_click:(id)sender;
- (IBAction)pageChanged:(id)sender;

@end
