//
//  SongCell.h
//  Nightlight
//
//  Created by Sandeep on 13/08/13.
//  Copyright (c) 2013 SajidIsrar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imgIcon;

@end
