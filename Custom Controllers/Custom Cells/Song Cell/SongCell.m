//
//  SongCell.m
//  Nightlight
//
//  Created by Sandeep on 13/08/13.
//  Copyright (c) 2013 SajidIsrar. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell

@synthesize lblTitle, imgIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
