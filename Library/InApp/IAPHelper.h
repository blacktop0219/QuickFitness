//
//  IAPHelper.h
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

#define kProductsLoadedNotification         @"productsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

#define kProductPurchasedforAdvancedWorkout @"AdvancedWorkoutPurchased"
#define kProductPurchasedFailedforAdvancedWorkout @"AdvancedWorkoutFailed"

#define kProductPurchasedforExpertsWorkout @"ExpertsWorkoutPurchased"
#define kProductPurchasedFailedforExpertsWorkout @"ExpertsWorkoutFailed"

#define kProductPurchasedforButtWorkout @"ButtWorkoutPurchased"
#define kProductPurchasedFailedforButtWorkout @"ButtWorkoutFailed"

#define kProductPurchasedforAllWorkout @"AllWorkoutPurchased"
#define kProductPurchasedFailedforAllWorkout @"AllWorkoutFailed"

#define kProductRestoreFailed @"ProductRestoreFailed"

#define kProductPurchasedforRemoveAds @"RemoveAds"
#define kProductFailedforRemoveAds @"RemoveAdsFailed"

@class DownloadAppDelegate;

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
        
    NSSet * _productIdentifiers;    
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
}

@property (retain) NSSet *productIdentifiers;
@property (retain) NSArray * products;
@property (retain) NSMutableSet *purchasedProducts;
@property (retain) SKProductsRequest *request;
@property (assign) BOOL isRestored;

- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProductIdentifier:(NSString *)productIdentifier;
-(void)restoreProductIdentifier:(NSString *)productIdentifier;

@end
