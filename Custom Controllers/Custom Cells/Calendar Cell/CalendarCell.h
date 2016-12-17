//
//  CalendarCell.h
//  QuickFitness
//
//  Created by Ashish Sudra on 10/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDetail;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;

@end
