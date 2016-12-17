//
//  PhotoViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UIImageView *imgVw1;
    IBOutlet UIImageView *imgVw2;
    
    IBOutlet UILabel *lblDate1;
    IBOutlet UILabel *lblDate2;
    
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    
    NSInteger selectedIndexfordate1, selectedIndexfordate2;
    
    IBOutlet UIView *TopVw;
    IBOutlet UILabel *lblMessage;
}

-(IBAction)addPhotoBtn_click:(id)sender;

-(IBAction)nextBtnForDate1:(id)sender;
-(IBAction)previousBtnForDate1:(id)sender;
-(IBAction)nextBtnForDate2:(id)sender;
-(IBAction)previousBtnForDate2:(id)sender;
@end
