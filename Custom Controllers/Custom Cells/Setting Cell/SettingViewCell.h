//
//  SettingViewCell.h
//  QuickFitness
//
//  Created by Ashish Sudra on 07/04/14.
//  Copyright (c) 2014 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGSwitch.h"

@interface SettingViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgIcon;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDetails;
@property (nonatomic, strong) IBOutlet UISwitch *SwitchOnOff;
@property (nonatomic, strong) IBOutlet UISlider *sliderVolume;
@property (nonatomic, strong) IBOutlet DGSwitch *genderSwitch;

@end
