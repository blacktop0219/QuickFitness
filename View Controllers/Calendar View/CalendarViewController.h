//
//  CalendarViewController.h
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"

@interface CalendarViewController : UIViewController <VRGCalendarViewDelegate>
{
    IBOutlet UITableView *tblVw;
    NSMutableArray *arrCalendar;
    IBOutlet UILabel *lblMessage;
    NSInteger SelectedIndexforDelete;
}

@end
