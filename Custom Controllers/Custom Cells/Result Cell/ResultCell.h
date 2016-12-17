//
//  ResultCell.h
//  QuickFitness
//
//  Created by Ashish Sudra on 09/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgIcon;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDight;
@property (nonatomic, strong) IBOutlet UILabel *lblBMI;

@end
