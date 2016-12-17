//
//  NotificationViewController.h
//  SexyShape
//
//  Created by Mitesh Panchal on 22/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaysViewController.h"

@interface NotificationViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrDays;
    DaysViewController *objDaysController;
    UILocalNotification *localNotify;
    NSDate *fireDate;
    IBOutlet UIPickerView *timePicker;
    NSMutableArray *arrHours, *arrMins, *arrTypes;
    
    int nHour ,nMin;
    NSString *strAmPm;
}
@property (nonatomic,strong) NSMutableDictionary *tDictDaysReminder;
@property (nonatomic,strong) NSMutableArray *currentSelectedReminders;

@end
