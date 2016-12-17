//
//  InAppRageIAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "InAppRageIAPHelper.h"

@implementation InAppRageIAPHelper

static InAppRageIAPHelper * _sharedHelper;

+ (InAppRageIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppRageIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init
{
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 INAPP_PRODUCT_AdvancedWorkout, INAPP_PRODUCT_ExpertsWorkout, INAPP_PRODUCT_ButtWorkouts,INAPP_PRODUCT_RemoveAds,INAPP_PRODUCT_AllWorkout,
                                 nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers]))
    {
        
    }
    return self;
    
}

@end
