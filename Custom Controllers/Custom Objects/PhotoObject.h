//
//  PhotoObject.h
//  QuickFitness
//
//  Created by Brijesh on 02/05/14.
//  Copyright (c) 2014 Brijesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoObject : NSObject

@property (nonatomic) NSInteger Id, nUserId;
@property (nonatomic, strong) NSString *strDate;
@property (nonatomic, strong) NSString *strImagePath;

@end
