//
//  UserViewController.h
//  SexyShape
//
//  Created by Mitesh Panchal on 26/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ProfileViewController;
@class HomeViewController;

@interface UserViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrUsers;
    IBOutlet UIButton *btnNewUser;
    IBOutlet UIScrollView *scrView;
    int nId, nDeleteId;
}
@property int nId;

-(IBAction)btnNewUserClick:(id)sender;
@end
