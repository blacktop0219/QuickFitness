//
//  CalendarDataObjects.h
//  QuickFitness
//
//  Created by Brijesh on 02/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarDataObjects : NSObject

@property (nonatomic) NSInteger Id, nUserId;
@property (nonatomic, strong) NSString *strStartTime;
@property (nonatomic) NSInteger CircuitComplete;
@property (nonatomic) NSInteger PercentComplete;
@property (nonatomic) NSInteger Pauses;
@property (nonatomic,strong) NSString *strCreatedDate;

@end
