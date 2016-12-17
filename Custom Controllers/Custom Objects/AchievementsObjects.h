//
//  AchievementsObjects.h
//  QuickFitness
//
//  Created by Brijesh on 20/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AchievementsObjects : NSObject

@property int nID,nUserId;
@property(nonatomic, strong) NSString *strIconImage;
@property(nonatomic, strong) NSString *strTitle;
@property(nonatomic, strong) NSString *strDetails;
@property(nonatomic, strong) NSString *strDate;
@property(nonatomic, strong) NSString *strImgBottomtext;
@property (nonatomic,readwrite) BOOL isLocked;

@end
