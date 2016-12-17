//
//  Goal.h
//  QuickFitness
//
//  Created by Mitesh Panchal on 16/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goal : NSObject

@property int nID, nUserId;
@property (nonatomic ,strong) NSString *strWeight;
@property (nonatomic ,strong) NSString *strBMI;
@property (nonatomic ,strong) NSString *strDate;
@property (nonatomic ,strong) NSString *strMonth;
@property (nonatomic, strong) NSString *strWeekStartDate;
@property (nonatomic, strong) NSString *strWeekEndDate;
@property (nonatomic, strong) NSString *strWeekDate;
@property (nonatomic, strong) NSString *strWeightType;

@end
