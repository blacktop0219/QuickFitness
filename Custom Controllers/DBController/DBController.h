//
//  DBController.h
//  QuickFitness
//
//  Created by Mitesh Panchal on 14/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "CalculateBMI.h"
#import "Goal.h"
#import "AchievementsObjects.h"
#import "VIdbConfig.h"
#import "CalendarDataObjects.h"
#import "WorkoutsObjects.h"

@interface DBController : NSObject

+ (void)addUserInfo :(UserInfo *)objInfo;
+ (void)updateUserInfo :(UserInfo *)objUserInfo;
+ (void)updateUserGoal:(NSString *)strGoal withWeightType:(NSString *)weightType withUserId:(int)UserId;
+(void)updateModelType:(int)nUID :(NSString *)gender;
+(void)updateVoiceType:(int)nUID :(NSString *)voice;

+ (UserInfo *)getHeightWeight :(int)userId;
+ (CalculateBMI *)getCalRecord;
+ (void)addCurrentBMI :(CalculateBMI *)objBMI;
+ (int)getAvgBmi :(int)userId; + (int)getAvgWeight :(int)userId; + (int)getAvgCalorie :(int)userId;
+ (NSMutableArray *)getResultArray :(int)userId;
+ (NSMutableArray *)getREsultMonthArray :(int)userId;
+ (void)addGoalBMI : (Goal *)objGoal;
+ (int)getAvgBmiMonth :(int)userId;
+ (int)getAvgWeightMonth :(int)userId;
+ (NSMutableArray *)getAchievementFalseObject :(int)userId;
+ (NSMutableArray *)getAchievementTrueObject :(int)userId;
+ (int)getCountForWorkout :(int)userId;
+ (int)getCountForGoal :(int)userId;
+ (int)getCycleCountForWorkout :(int)userId;
+ (AchievementsObjects *)getAchievementObject :(int)aID :(int)userId;
+ (BOOL) getLock : (int)aID :(int)userId;
+ (void) getAchievement :(int)aID :(int)userId;
+(void)deleteWorkOutForTime:(NSString *)tTime withUserId:(int)Id;
+(void)deleteUserForId:(int)nId;
+ (NSMutableArray *)getAchievementNextObject :(int)userId;
+ (int)getCycleCountInSingleDay :(NSString *)date :(int)userId;

+(NSMutableArray *)getWeeklyBMI :(int)userId;
+(NSMutableArray *)getWeeklyWEIGHT :(int)userId;
+(NSMutableArray *)GetweeklyXLabels :(int)userId;
+(NSMutableArray *)getUsers;
+(NSMutableArray *)getResultWorkouts :(int)userId :(NSString *)date;
+(NSMutableArray *)getDefaultWorkOuts: (NSString *)gender;
+(NSMutableArray *)getRecordsWithTime:(NSString *)time withUserId:(int)userId;



+(NSMutableArray *)getIntermediateWorkOuts:(NSString *)gender;
+(NSMutableArray *)getExpertsSeriesWorkOuts:(NSString *)gender;
+(NSMutableArray *)getButtWorkOuts:(NSString *)gender;
@end
