//
//  SettingViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Social/Social.h"
#import <MessageUI/MessageUI.h>
#import "NotificationViewController.h"
#import "UserViewController.h"
#import "DGSwitch.h"

//===== ICloud
#import "iCloud.h"
#import "MKiCloudSync.h"
#import "Note.h"
#import "ZipKit.h"


@interface SettingViewController : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,iCloudDelegate>
{
    NSMutableArray *arrSectionOne;
    NSMutableArray *arrSectionTwo;
    
    IBOutlet UITableView *tblVw;
        
    SLComposeViewController *slComposeController;
    NSInteger selectedIndex;
    BOOL isFromDurationView, isTellFriend;
    UserViewController *objUserController;
    NSUbiquitousKeyValueStore *kvoStore;
}
@property (strong) NSMetadataQuery *query;
@property BOOL isFeedBack;
-(void)sharingWithFBForSavedImages;

@end
