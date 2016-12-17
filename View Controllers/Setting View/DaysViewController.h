//
//  DaysViewController.h
//  SexyShape
//
//  Created by Mitesh Panchal on 22/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaysViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrayDays;
}

@property id deleg;

@end
