//
//  UserInfo.h
//  QuickFitness
//
//  Created by Mitesh Panchal on 14/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property int nId;
@property (nonatomic,strong) NSString *strName;
@property (nonatomic,strong) NSString *strSex;
@property (nonatomic,strong) NSString *strAge;
@property (nonatomic,strong) NSString *strHeight;
@property (nonatomic,strong) NSString *strWeight;
@property (nonatomic,strong) NSString *strImageUrl;
@property (nonatomic,strong) NSString *strGoalWeight;
@property (nonatomic,strong) NSString *strWeightType;
@property (nonatomic,strong) NSString *strheightType;
@property (nonatomic,strong) NSString *strModelType;
@property (nonatomic,strong) NSString *strVoiceType;



@end
