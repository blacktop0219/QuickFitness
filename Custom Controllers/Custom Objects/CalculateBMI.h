//
//  CalculateBMI.h
//  QuickFitness
//
//  Created by Mitesh Panchal on 14/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateBMI : NSObject

@property int nID;
@property (nonatomic,strong) NSString *strTodayBMI;
@property (nonatomic,strong) NSString *strMonthlyBMI;
@property (nonatomic,strong) NSString *strTodayWeight ,*strTodayWeightBurn;
@property (nonatomic,strong) NSString *strMonthlyweight, *strMonthlyweightBurn;
@property (nonatomic,strong) NSString *strTodayCalorie, *strTodayCalorieBurn;
@property (nonatomic,strong) NSString *strMonthlyCalorie, *strMonthlyCalorieBurn;
@property (nonatomic,strong) NSString *strDate, *strMonth;


@end
