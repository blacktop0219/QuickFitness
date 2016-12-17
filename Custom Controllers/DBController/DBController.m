//
//  DBController.m
//  QuickFitness
//
//  Created by Mitesh Panchal on 14/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import "DBController.h"

@implementation DBController

+ (void)updateUserInfo :(UserInfo *)objUserInfo
{
    NSString *str = [NSString stringWithFormat:@"update UserDetails set Name = '%@', Sex = '%@', Age = '%@', Height = '%@', Weight = '%@',UserPhoto = '%@',GoalWeight = '%@',WeightType = '%@','HeightType' = '%@','ModelType'='%@','VoiceType'='%@' where ID = %d;", objUserInfo.strName, objUserInfo.strSex, objUserInfo.strAge, objUserInfo.strHeight, objUserInfo.strWeight,objUserInfo.strImageUrl,objUserInfo.strGoalWeight,objUserInfo.strWeightType,objUserInfo.strheightType,objUserInfo.strModelType,objUserInfo.strVoiceType,objUserInfo.nId];
    [db executeUpdate:str];
}
+ (void)updateUserGoal:(NSString *)strGoal withWeightType:(NSString *)weightType withUserId:(int)UserId
{
    NSString *strUpdateGoal = [NSString stringWithFormat:@"update Goal set Weight='%@', WeightType='%@' where UserId=%d",strGoal,weightType,UserId];
    [db executeUpdate:strUpdateGoal];
}
+ (void)addUserInfo :(UserInfo *)objUserInfo
{
    NSString *str = [NSString stringWithFormat:@"Insert OR Replace into UserDetails ('ID','Name','Sex','Age','Height','Weight','UserPhoto','GoalWeight','WeightType','HeightType','ModelType','VoiceType') values ('%d','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", objUserInfo.nId, objUserInfo.strName, objUserInfo.strSex, objUserInfo.strAge, objUserInfo.strHeight,objUserInfo.strWeight,objUserInfo.strImageUrl,objUserInfo.strGoalWeight,objUserInfo.strWeightType,objUserInfo.strheightType,objUserInfo.strModelType,objUserInfo.strVoiceType];
    [db executeUpdate:str];
}
+(void)updateModelType:(int)nUID :(NSString *)gender
{
    NSString *strModelQuery = [NSString stringWithFormat:@"update UserDetails set ModelType='%@' where Id=%d",gender,nUID];
    [db executeUpdate:strModelQuery];
}
+(void)updateVoiceType:(int)nUID :(NSString *)voice
{
    NSString *strModelQuery = [NSString stringWithFormat:@"update UserDetails set VoiceType='%@' where Id=%d",voice,nUID];
    [db executeUpdate:strModelQuery];
}
+ (int)getAvgBmi :(int)userId
{
    rs = [db executeQuery:[NSString stringWithFormat:@"select AVG(BMI) as 'Avrage' from Goal where UserId=%d",userId]];
    [rs next];
    int nVAl = [rs intForColumn:@"Avrage"];
    return nVAl;
}
+ (int)getAvgWeight :(int)userId
{
    NSString *strQuery = [NSString stringWithFormat:@"select AVG(Weight) as 'Avrage' from Goal where UserId=%d",userId];
    rs = [db executeQuery:strQuery];
    [rs next];
    int nVAl = [rs intForColumn:@"Avrage"];
    return nVAl;
}
+ (int)getAvgCalorie :(int)userId
{
    rs = [db executeQuery:[NSString stringWithFormat:@"select AVG(MonthlyCalorieBurn) as 'Avrage' from Calculations where UserId=%d",userId]];
    [rs next];
    int nVAl = [rs intForColumn:@"Avrage"];
    return nVAl;
}

+ (int)getAvgBmiMonth :(int)userId
{
    rs = [db executeQuery:[NSString stringWithFormat:@"select AVG(BMI) as 'Avrage' from Goal where UserId=%d GROUP BY Month",userId]];
    [rs next];
    int nVAl = [rs intForColumn:@"Avrage"];
    return nVAl;
}
+ (int)getAvgWeightMonth :(int)userId
{
    rs = [db executeQuery:[NSString stringWithFormat:@"select AVG(Weight) as 'Avrage' from Goal where UserId=%d GROUP BY Month",userId]];
    [rs next];
    int nVAl = [rs intForColumn:@"Avrage"];
    return nVAl;
}

+(NSMutableArray *)getWeeklyBMI :(int)userId
{
    NSMutableArray *arrBMI = [[NSMutableArray alloc] init];
    NSString *strQuery = [NSString stringWithFormat:@"select BMI from Goal where UserID=%d group by ID",userId];
    rs = [db executeQuery:strQuery];
    while ([rs next]) {
        [arrBMI addObject:[rs stringForColumn:@"BMI"]];
    }
    return arrBMI;
}

+(NSMutableArray *)GetweeklyXLabels :(int)userId
{
    NSMutableArray *arrBMI = [[NSMutableArray alloc] init];
    NSString *strQuery = [NSString stringWithFormat:@"select WeekStartDate,WeekEndDate from Goal where UserId=%d group by ID",userId];
    rs = [db executeQuery:strQuery];
    while ([rs next]) {
        NSString *strSD = [rs stringForColumn:@"WeekStartDate"];
        NSString *strED = [rs stringForColumn:@"WeekEndDate"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *SD = [df dateFromString:strSD];
        NSDate *ED = [df dateFromString:strED];
        
        [df setDateFormat:@"M/d"];
        strSD = [df stringFromDate:SD];
        strED = [df stringFromDate:ED];
        
        [arrBMI addObject:[NSString stringWithFormat:@"%@-%@", strSD, strED]];
    }
    return arrBMI;
}

+(NSMutableArray *)getWeeklyWEIGHT :(int)userId
{
    NSMutableArray *arrBMI = [[NSMutableArray alloc] init];
    NSString *strQuery = [NSString stringWithFormat:@"select Weight,WeightType from Goal where UserId=%d group by ID",userId];
    rs = [db executeQuery:strQuery];
    while ([rs next]) {
       /* NSString *strWeightType = [rs stringForColumn:@"WeightType"];
        NSString *strWeight = [rs stringForColumn:@"Weight"];
        
        if([strWeightType isEqualToString:@"LBS"]){
            float weight = [self convertKGtoLBS:[strWeight floatValue]];
            [arrBMI addObject:[NSString stringWithFormat:@"%.0f",weight]];
        }else{
            [arrBMI addObject:strWeight];
        } */
        
        [arrBMI addObject:[rs stringForColumn:@"Weight"]];
    }
    return arrBMI;
}

+ (NSMutableArray *)getREsultMonthArray :(int)userId
{
    NSString *strGetMonthData = [NSString stringWithFormat:@"Select * From Goal where UserId=%d GROUP BY Month",userId];
    rs = [db executeQuery:strGetMonthData];
       NSMutableArray *arrResult = [[NSMutableArray alloc]init];
    while ([rs next]) {
        Goal *obj = [[Goal alloc]init];
        obj.nID = [rs intForColumn:@"ID"];
        obj.strWeight = [rs stringForColumn:@"Weight"];
        obj.strBMI = [rs stringForColumn:@"BMI"];
        obj.strDate = [rs stringForColumn:@"Date"];
        obj.strMonth = [rs stringForColumn:@"Month"];
        obj.strWeightType = [rs stringForColumn:@"WeightType"];
        [arrResult addObject:obj];
    }
    return arrResult;
}
+ (NSMutableArray *)getResultArray :(int)userId
{
    NSString *strGetData = [NSString stringWithFormat:@"select * from Goal where UserId=%d ORDER BY ID DESC",userId];
    rs = [db executeQuery:strGetData];
    
    NSMutableArray *arrResult = [[NSMutableArray alloc]init];
    while ([rs next]) {
        Goal *obj = [[Goal alloc]init];
        obj.nID = [rs intForColumn:@"ID"];
        obj.strWeight = [rs stringForColumn:@"Weight"];
        obj.strBMI = [rs stringForColumn:@"BMI"];
        NSString *tempDate = [rs stringForColumn:@"Date"];
        obj.strDate = [self dateDifference:tempDate];
        obj.strMonth = [rs stringForColumn:@"Month"];
        obj.strWeightType = [rs stringForColumn:@"WeightType"];
        
        NSString *strSD = [rs stringForColumn:@"WeekStartDate"];
        NSString *strED = [rs stringForColumn:@"WeekEndDate"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *SD = [df dateFromString:strSD];
        NSDate *ED = [df dateFromString:strED];
        
        [df setDateFormat:@"yyyy/MM/dd"];
        strSD = [df stringFromDate:SD];
        strED = [df stringFromDate:ED];
        
        obj.strWeekDate = [NSString stringWithFormat:@"%@ To %@", strSD, strED];
        
        [arrResult addObject:obj];
        
    }
    return arrResult;
}
+(NSMutableArray *)getDefaultWorkOuts:(NSString *)gender; //Load All WorkOuts
{
    NSString *strGetWorkouts = [NSString stringWithFormat:@"select * from Workouts where Type = 'DEFAULT'"];
    rs = [db executeQuery:strGetWorkouts];
    
    NSMutableArray *arrWorkouts = [[NSMutableArray alloc]init];
    while ([rs next]) {
        WorkoutsObjects *obj =[[WorkoutsObjects alloc]init];
        obj.WID = [rs intForColumn:@"WID"];
        obj.strTitle = [rs stringForColumn:@"Title"];
        if([gender isEqualToString:@"WomenModel"]){
            
            obj.strImageUrl = [NSString stringWithFormat:@"%@_F.png",[rs stringForColumn:@"ImageURL"]];
            obj.strVideoUrl = [NSString stringWithFormat:@"%@_F",[rs stringForColumn:@"VideoURL"]];
           
        }else if([gender isEqualToString:@"MenModel"]){
            
//            obj.strImageUrl = [rs stringForColumn:@"ImageURL"];
//            obj.strVideoUrl = [rs stringForColumn:@"VideoURL"];
            
            obj.strImageUrl = [NSString stringWithFormat:@"%@_M.png",[rs stringForColumn:@"ImageURL"]];
            obj.strVideoUrl = [NSString stringWithFormat:@"%@_M",[rs stringForColumn:@"VideoURL"]];
        }
        obj.strSteps = [rs stringForColumn:@"Texts"];
        obj.strType = [rs stringForColumn:@"Type"];
        
        [arrWorkouts addObject:obj];
    }
    return arrWorkouts;
}
+(NSMutableArray *)getIntermediateWorkOuts:(NSString *)gender; //Load All WorkOuts
{
    NSString *strGetWorkouts = [NSString stringWithFormat:@"select * from Workouts where Type = 'Intermediate'"];
    rs = [db executeQuery:strGetWorkouts];
    
    NSMutableArray *arrWorkouts = [[NSMutableArray alloc]init];
    while ([rs next]) {
        WorkoutsObjects *obj =[[WorkoutsObjects alloc]init];
        obj.WID = [rs intForColumn:@"WID"];
        obj.strTitle = [rs stringForColumn:@"Title"];
        if([gender isEqualToString:@"WomenModel"]){
            
            obj.strImageUrl = [NSString stringWithFormat:@"%@_F.png",[rs stringForColumn:@"ImageURL"]];
            obj.strVideoUrl = [NSString stringWithFormat:@"%@_F",[rs stringForColumn:@"VideoURL"]];
            
        }else if([gender isEqualToString:@"MenModel"]){
            
            //            obj.strImageUrl = [rs stringForColumn:@"ImageURL"];
            //            obj.strVideoUrl = [rs stringForColumn:@"VideoURL"];
            
            obj.strImageUrl = [NSString stringWithFormat:@"%@_M.png",[rs stringForColumn:@"ImageURL"]];
            obj.strVideoUrl = [NSString stringWithFormat:@"%@_M",[rs stringForColumn:@"VideoURL"]];
        }
        obj.strSteps = [rs stringForColumn:@"Texts"];
        obj.strType = [rs stringForColumn:@"Type"];
        
        [arrWorkouts addObject:obj];
    }
    return arrWorkouts;
}

+(NSMutableArray *)getExpertsSeriesWorkOuts:(NSString *)gender; //Load All WorkOuts
{
    NSString *strGetWorkouts = [NSString stringWithFormat:@"select * from Workouts where Type = 'Expert Series'"];
    rs = [db executeQuery:strGetWorkouts];
    
    NSMutableArray *arrWorkouts = [[NSMutableArray alloc]init];
    while ([rs next]) {
        WorkoutsObjects *obj =[[WorkoutsObjects alloc]init];
        obj.WID = [rs intForColumn:@"WID"];
        obj.strTitle = [rs stringForColumn:@"Title"];
        if([gender isEqualToString:@"WomenModel"]){
            
            obj.strImageUrl = [NSString stringWithFormat:@"%@_F.png",[rs stringForColumn:@"ImageURL"]];
            obj.strVideoUrl = [NSString stringWithFormat:@"%@_F",[rs stringForColumn:@"VideoURL"]];
            
        }else if([gender isEqualToString:@"MenModel"]){
            
            //            obj.strImageUrl = [rs stringForColumn:@"ImageURL"];
            //            obj.strVideoUrl = [rs stringForColumn:@"VideoURL"];
            
            obj.strImageUrl = [NSString stringWithFormat:@"%@_M.png",[rs stringForColumn:@"ImageURL"]];
            obj.strVideoUrl = [NSString stringWithFormat:@"%@_M",[rs stringForColumn:@"VideoURL"]];
        }
        obj.strSteps = [rs stringForColumn:@"Texts"];
        obj.strType = [rs stringForColumn:@"Type"];
        
        [arrWorkouts addObject:obj];
    }
    return arrWorkouts;
}


+(NSMutableArray *)getButtWorkOuts:(NSString *)gender; //Load All WorkOuts
{
    NSString *strGetWorkouts = [NSString stringWithFormat:@"select * from Workouts where Type = 'Butt Workouts'"];
    rs = [db executeQuery:strGetWorkouts];
    
    NSMutableArray *arrWorkouts = [[NSMutableArray alloc]init];
    while ([rs next]) {
        WorkoutsObjects *obj =[[WorkoutsObjects alloc]init];
        obj.WID = [rs intForColumn:@"WID"];
        obj.strTitle = [rs stringForColumn:@"Title"];
        if([gender isEqualToString:@"WomenModel"]){
            
            obj.strImageUrl = [NSString stringWithFormat:@"%@_F.png",[rs stringForColumn:@"ImageURL"]];
            obj.strVideoUrl = [NSString stringWithFormat:@"%@_F",[rs stringForColumn:@"VideoURL"]];
            
        }else if([gender isEqualToString:@"MenModel"]){
            
            //            obj.strImageUrl = [rs stringForColumn:@"ImageURL"];
            //            obj.strVideoUrl = [rs stringForColumn:@"VideoURL"];
            
            obj.strImageUrl = [NSString stringWithFormat:@"%@_M.png",[rs stringForColumn:@"ImageURL"]];
            obj.strVideoUrl = [NSString stringWithFormat:@"%@_M",[rs stringForColumn:@"VideoURL"]];
        }
        obj.strSteps = [rs stringForColumn:@"Texts"];
        obj.strType = [rs stringForColumn:@"Type"];
        
        [arrWorkouts addObject:obj];
    }
    return arrWorkouts;
}

+ (NSMutableArray *)getResultWorkouts :(int)userId :(NSString *)date
{
    NSString *strGetData = [NSString stringWithFormat:@"select * from UserWorkouts where UserId=%d AND CreatedDate='%@' GROUP BY StartTime",userId,date];
    rs = [db executeQuery:strGetData];
    
    NSMutableArray *arrResult = [[NSMutableArray alloc]init];
    while ([rs next]) {
        CalendarDataObjects *obj =[[CalendarDataObjects alloc]init];
        obj.Id = [rs intForColumn:@"Id"];
        obj.strStartTime = [rs stringForColumn:@"StartTime"];
        obj.strCreatedDate = [rs stringForColumn:@"CreatedDate"];
        obj.CircuitComplete = [[rs stringForColumn:@"CircuitComplete"]integerValue];
        obj.PercentComplete = [[rs stringForColumn:@"PercentComplete"]integerValue];
        obj.Pauses = [[rs stringForColumn:@"Pauses"]integerValue];
        obj.nUserId = [rs intForColumn:@"UserId"];
        [arrResult addObject:obj];
    }
    return arrResult;
}
+(NSMutableArray *)getRecordsWithTime:(NSString *)time withUserId:(int)userId
{
    NSString *strGetData = [NSString stringWithFormat:@"select * from UserWorkouts where UserId=%d AND StartTime='%@'",userId,time];
    rs = [db executeQuery:strGetData];
    
     NSMutableArray *arrResult = [[NSMutableArray alloc]init];
    while ([rs next]) {
        NSMutableDictionary *tDict = [[NSMutableDictionary alloc]init];
        [tDict setObject:[rs stringForColumn:@"PercentComplete"] forKey:@"PercentComplete"];
        [tDict setObject:[rs stringForColumn:@"Pauses"] forKey:@"Pauses"];
  //      NSString *val = [rs stringForColumn:@"PercentComplete"];
        [arrResult addObject:tDict];
    }
    return arrResult;
}
+ (NSMutableArray *)getUsers
{
    NSMutableArray *arrUsers = [[NSMutableArray alloc]init];
    NSString *strQuery = [NSString stringWithFormat:@"select * from UserDetails"];
    rs = [db executeQuery:strQuery];
    while ([rs next]) {
        UserInfo *obj = [[UserInfo alloc]init];
        obj.nId = [rs intForColumn:@"Id"];
        obj.strName  =[rs stringForColumn:@"Name"];
        obj.strSex = [rs stringForColumn:@"Sex"];
        obj.strAge = [rs stringForColumn:@"Age"];
        obj.strHeight  =[rs stringForColumn:@"Height"];
        obj.strWeight = [rs stringForColumn:@"Weight"];
        obj.strImageUrl = [rs stringForColumn:@"UserPhoto"];
        obj.strGoalWeight = [rs stringForColumn:@"GoalWeight"];
        obj.strWeightType = [rs stringForColumn:@"WeightType"];
        obj.strheightType = [rs stringForColumn:@"HeightType"];
        obj.strModelType = [rs stringForColumn:@"ModelType"];
        obj.strVoiceType = [rs stringForColumn:@"VoiceType"];
        
        [arrUsers addObject:obj];
    }
    return arrUsers;
}
+ (int)getCountForWorkout :(int)userId
{
    NSString *strCount = [NSString stringWithFormat:@"select count(*) as Count from UserWorkouts where UserId=%d",userId];
    rs =[db executeQuery:strCount];
    [rs next];
    int nCount = [rs intForColumn:@"Count"];
    return nCount;
}
+ (int)getCycleCountForWorkout :(int)userId
{
    NSString *strCount = [NSString stringWithFormat:@"select count(*) as Count from UserWorkouts where PercentComplete = 100 AND UserId=%d",userId];
    rs =[db executeQuery:strCount];
    [rs next];
    int nCount = [rs intForColumn:@"Count"];
    return nCount;
}
+ (int)getCycleCountInSingleDay :(NSString *)date :(int)userId
{
    NSString *strCount = [NSString stringWithFormat:@"select count(*) as Count from UserWorkouts where CircuitComplete = 1,UserId=%d AND CreatedDate = %@",userId,date];
    rs =[db executeQuery:strCount];
    [rs next];
    int nCount = [rs intForColumn:@"Count"];
    return nCount;
}
+ (int)getCountForGoal :(int)userId
{
    NSString *strCount = [NSString stringWithFormat:@"select count(*) as Count from Goal where UserId=%d",userId];
    rs =[db executeQuery:strCount];
    [rs next];
    int nCount = [rs intForColumn:@"Count"];
    return nCount;
}
+ (AchievementsObjects *)getAchievementObject :(int)aID :(int)userId
{
    aID = (userId-1)*18 + aID;
    NSString *strAchieveTitleQuery = [NSString stringWithFormat:@"select * from Achievements where AID=%d AND UserId=%d",aID,userId];
    rs = [db executeQuery:strAchieveTitleQuery];
    [rs next];
    AchievementsObjects *obj =[[AchievementsObjects alloc]init];
    
    obj.strTitle = [rs stringForColumn:@"Title"];
    obj.strIconImage = [rs stringForColumn:@"ImageURL"];
    
    return obj;
}
+ (BOOL) getLock : (int)aID :(int)userId
{
    aID = (userId-1)*18 + aID;
    NSString *strQuery = [NSString stringWithFormat:@"select Lock from Achievements where AID=%d AND UserId=%d",aID,userId];
    rs = [db executeQuery:strQuery];
    [rs next];
    BOOL isLocked = [[rs stringForColumnIndex:0] boolValue];
    return isLocked;
}

+ (void) getAchievement :(int)aID :(int)userId
{
    aID = (userId-1)*18 + aID;
    NSString *strQuery = [NSString stringWithFormat:@"update Achievements set Lock = 'FALSE' where AID=%d AND userId=%d",aID,userId];
    [db executeUpdate:strQuery];
}
+ (NSString *) dateDifference:(NSString *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *nowDate = [df dateFromString:date];
    
    const NSTimeInterval secondsPerDay = 60 * 60 * 24;
    NSTimeInterval diff = [nowDate timeIntervalSinceNow] * -1.0;
    
    // if the difference is negative, then the given date/time is in the future
    // (because we multiplied by -1.0 to make it easier to follow later)
    if (diff < 0)
        return @"In the future";
    
    diff /= secondsPerDay; // get the number of days
    
    // if the difference is less than 1, the date occurred today, etc.
    if (diff < 1)
        return @"Today";
    else if (diff < 2)
        return @"Yesterday";
    else
        return [date description]; // use a date formatter if necessary
}
+ (UserInfo *)getHeightWeight :(int)userId
{
    NSString *strGet = [NSString stringWithFormat:@"select * from UserDetails where Id=%d",userId];
   rs =  [db executeQuery:strGet];
    UserInfo *obj;
    while ([rs next]) {
        obj = [[UserInfo alloc]init];
        obj.strName = [rs stringForColumn:@"Name"];
        obj.strSex = [rs stringForColumn:@"Sex"];
        obj.strAge = [rs stringForColumn:@"Age"];
        obj.strHeight = [rs stringForColumn:@"Height"];
        obj.strWeight = [rs stringForColumn:@"Weight"];
        obj.strWeightType = [rs stringForColumn:@"WeightType"];
        obj.strGoalWeight = [rs stringForColumn:@"GoalWeight"];
        obj.strModelType = [rs stringForColumn:@"ModelType"];
        obj.strVoiceType = [rs stringForColumn:@"VoiceType"];
    }
    return obj;
}

+ (CalculateBMI *)getCalRecord
{
    NSString *strGetLastRecord = [NSString stringWithFormat:@"SELECT * FROM Calculations ORDER BY ID DESC LIMIT 1"];
    rs  =[db executeQuery:strGetLastRecord];
    CalculateBMI *obj;
    while ([rs next]) {
        obj = [[CalculateBMI alloc]init];
        obj.nID = [[rs stringForColumn:@"ID"]intValue];
        obj.strTodayBMI = [rs stringForColumn:@"TodayBMI"];
        obj.strMonthlyBMI = [rs stringForColumn:@"MonthlyBMI"];
        obj.strTodayWeight = [rs stringForColumn:@"TodayWeight"];
        obj.strMonthlyweight = [rs stringForColumn:@"MonthlyWeight"];
        obj.strTodayCalorie = [rs stringForColumn:@"TodayCalorie"];
        obj.strMonthlyCalorie = [rs stringForColumn:@"MonthlyCalorie"];
        obj.strDate = [rs stringForColumn:@"TodayDate"];
    }
    return obj;
}
+ (NSMutableArray *)getAchievementTrueObject :(int)userId
{
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    NSString *strGetRecord = [NSString stringWithFormat:@"SELECT * FROM Achievements WHERE Lock='TRUE' AND UserId=%d ORDER BY RANDOM()",userId];
    rs = [db executeQuery:strGetRecord];
    while ([rs next]) {
        AchievementsObjects *obj = [[AchievementsObjects alloc]init];
        obj.nID = [rs intForColumn:@"AID"];
        obj.strTitle = [rs stringForColumn:@"Title"];
        obj.strImgBottomtext = [rs stringForColumn:@"BText"];
        obj.strIconImage = [rs stringForColumn:@"ImageURL"];
        obj.strDetails = [rs stringForColumn:@"Detail"];
        obj.strDate =[rs stringForColumn:@"Date"];
        obj.isLocked = [rs boolForColumn:@"Lock"];
          [arrData addObject:obj];
    }
    return arrData;
}
+ (NSMutableArray *)getAchievementNextObject :(int)userId //userId .........
{
    NSString *strGetRecord = [NSString stringWithFormat:@"SELECT * FROM Achievements WHERE Lock='TRUE' AND UserId=%d",userId];
    rs = [db executeQuery:strGetRecord];
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    
    while ([rs next]) {
        AchievementsObjects *obj = [[AchievementsObjects alloc]init];
        obj.nID = [rs intForColumn:@"AID"];
        obj.strTitle = [rs stringForColumn:@"Title"];
        obj.strImgBottomtext = [rs stringForColumn:@"BText"];
        obj.strIconImage = [rs stringForColumn:@"ImageURL"];
        obj.strDetails = [rs stringForColumn:@"Detail"];
        obj.strDate =[rs stringForColumn:@"Date"];
        obj.isLocked = [rs boolForColumn:@"Lock"];
        [arrData addObject:obj];
    }
    return arrData;
}
+ (NSMutableArray *)getAchievementFalseObject :(int)userId
{
    NSString *strGetRecord = [NSString stringWithFormat:@"SELECT * FROM Achievements WHERE Lock='FALSE' AND UserId=%d",userId];
    rs = [db executeQuery:strGetRecord];
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    while ([rs next]) {
        AchievementsObjects *obj = [[AchievementsObjects alloc]init];
        obj.nID = [rs intForColumn:@"AID"];
        obj.strTitle = [rs stringForColumn:@"Title"];
        obj.strImgBottomtext = [rs stringForColumn:@"BText"];
        obj.strIconImage = [rs stringForColumn:@"ImageURL"];
        obj.strDetails = [rs stringForColumn:@"Detail"];
        obj.strDate =[rs stringForColumn:@"Date"];
        obj.isLocked = [rs boolForColumn:@"Lock"];
        [arrData addObject:obj];
    }
    return arrData;
}
+ (void)addCurrentBMI :(CalculateBMI *)objBMI
{
    NSString *strCheckID = [NSString stringWithFormat:@"select * from Calculations where ID=%d",objBMI.nID];
    rs = [db executeQuery:strCheckID];

    if(rs.noOfRow>0){
      
        NSString *strUpdateCalcBMI = [NSString stringWithFormat:@"update Calculations set TodayBMI = '%@', MonthlyBMI = '%@', TodayWeight = '%@', MonthlyWeight = '%@', TodayCalorie = '%@',MonthlyCalorie = '%@', TodayWeightBurn = '%@',MonthlyWeightBurn = '%@',TodayCalorieBurn = '%@',MonthlyCalorieBurn = '%@',TodayDate = '%@',Month = '%@' where Id = %d",objBMI.strTodayBMI,objBMI.strMonthlyBMI,objBMI.strTodayWeight,objBMI.strMonthlyweight,objBMI.strTodayCalorie,objBMI.strMonthlyCalorie,objBMI.strTodayWeightBurn,objBMI.strMonthlyweightBurn,objBMI.strTodayCalorieBurn,objBMI.strMonthlyCalorieBurn,objBMI.strDate,objBMI.strMonth,objBMI.nID];
        [db executeUpdate:strUpdateCalcBMI];

    }else{
        NSString *strAddCalcBMI = [NSString stringWithFormat:@"Insert into Calculations ('ID','TodayBMI','MonthlyBMI','TodayWeight','MonthlyWeight','TodayCalorie','MonthlyCalorie','TodayWeightBurn','MonthlyWeightBurn','TodayCalorieBurn','MonthlyCalorieBurn','TodayDate','Month')  values ('%d','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",objBMI.nID,objBMI.strTodayBMI,objBMI.strMonthlyBMI,objBMI.strTodayWeight,objBMI.strMonthlyweight,objBMI.strTodayCalorie,objBMI.strMonthlyCalorie,objBMI.strTodayWeightBurn,objBMI.strMonthlyweightBurn,objBMI.strTodayCalorieBurn,objBMI.strMonthlyCalorieBurn, objBMI.strDate,objBMI.strMonth];
        [db executeUpdate:strAddCalcBMI];
    }
}
+ (void)addGoalBMI : (Goal *)objGoal
{
    NSString *strAddGoal = [NSString stringWithFormat:@"Insert OR Replace into Goal ('ID','Weight','BMI','Date','Month','WeekStartDate','WeekEndDate','UserId','WeightType') values ('%d','%@','%@','%@','%@','%@','%@','%d','%@')",objGoal.nID,objGoal.strWeight,objGoal.strBMI,objGoal.strDate,objGoal.strMonth, objGoal.strWeekStartDate, objGoal.strWeekEndDate,objGoal.nUserId,objGoal.strWeightType];
    [db executeUpdate:strAddGoal];
}
+(void)deleteWorkOutForTime:(NSString *)tTime withUserId:(int)Id
{
    NSString *str = [NSString stringWithFormat:@"Delete from UserWorkouts where StartTime = '%@' AND UserId=%d", tTime,Id];
    [db executeUpdate:str];
}
+(void)deleteUserForId:(int)nId
{
    NSString *strDeleteUserQuery = [NSString stringWithFormat:@"Delete from UserDetails where id = %i", nId];
    [db executeUpdate:strDeleteUserQuery];
    
    NSString *strDeleteWorkoutQuery = [NSString stringWithFormat:@"Delete from UserWorkouts where UserId = %i", nId];
    [db executeUpdate:strDeleteWorkoutQuery];
    
    NSString *strDeleteGoalQuery  =[NSString stringWithFormat:@"Delete from Goal where UserId = %i", nId];
    [db executeUpdate:strDeleteGoalQuery];
    
    NSString *strAchieventmentQuery = [NSString stringWithFormat:@"update Achievements set Lock = 'TRUE' where UserId = %i",nId];
    [db executeUpdate:strAchieventmentQuery];
    
    NSString *strQueryPhotos = [NSString stringWithFormat:@"Delete from PhotoaMaster where Where UserId = %i", nId];
    [db executeUpdate:strQueryPhotos];
}

@end
