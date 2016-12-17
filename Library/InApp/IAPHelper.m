//
//  IAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "IAPHelper.h"

@implementation IAPHelper
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;
@synthesize isRestored;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    if ((self = [super init]))
    {
        // Store product identifiers
        _productIdentifiers = [productIdentifiers retain];
        
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers)
        {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            
            if (productPurchased)
            {
                [purchasedProducts addObject:productIdentifier];
            }
        }
        self.purchasedProducts = purchasedProducts;
    }
    
    return self;
}

- (void)requestProducts
{    
    self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] autorelease];
    _request.delegate = self;
    [_request start];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    self.request = nil;  
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];    
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {    
    // TODO: Record the transaction on the server side...    
}

-(void)restoreProductIdentifier:(NSString *)productIdentifier
{
    if ([SKPaymentQueue canMakePayments])
	{
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
	}
	else
	{
        [self showAlertForUnauthorizedPurchase];
	}
}

- (void)buyProductIdentifier:(NSString *)productIdentifier
{    
    NSLog(@"Buying %@", productIdentifier);
    
    if ([SKPaymentQueue canMakePayments])
    {
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
       // SKPayment *payment = [SKPayment paymentWithProduct:self.products];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        [self showAlertForUnauthorizedPurchase];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"transactionState = %d",transaction.transactionState);
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
//    self.isRestored = TRUE;
//    [self recordTransaction: transaction];
//    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContent:(NSString *)productIdentifier
{
    NSLog(@"Toggling flag for: %@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_purchasedProducts addObject:productIdentifier];
        
    if (appDelegate.SelectedPurchaseType == 1)//AdvancedWorkout
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedforAdvancedWorkout object:productIdentifier];
        return;
    }
    else if (appDelegate.SelectedPurchaseType == 2)//ExpertsWorkout
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedforExpertsWorkout object:productIdentifier];
        return;
    }else if(appDelegate.SelectedPurchaseType == 3)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedforButtWorkout object:productIdentifier];
        return;
    }else if (appDelegate.SelectedPurchaseType == 4)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedforRemoveAds object:productIdentifier];
        return;
    }else if (appDelegate.SelectedPurchaseType == 5)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedforAllWorkout object:productIdentifier];
        return;
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    
    if (appDelegate.SelectedPurchaseType == 1)//Bump
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedFailedforAdvancedWorkout object:transaction];
        return;
    }
    else if (appDelegate.SelectedPurchaseType == 2){
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedFailedforExpertsWorkout object:transaction];
        return;
    }else if (appDelegate.SelectedPurchaseType == 3){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedFailedforButtWorkout object:transaction];
        return;
    }else if (appDelegate.SelectedPurchaseType == 4){
     
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductFailedforRemoveAds object:transaction];
        return;
    }else if (appDelegate.SelectedPurchaseType == 5){
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedFailedforAllWorkout object:transaction];
        return;
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)showAlertForUnauthorizedPurchase
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization" message:@"You are not authorized to purchase from AppStore" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    //int thisIsTheTotalNumberOfPurchaseToBeRestored = queue.transactions.count;
    NSString *selectedProdId = [self getSelProductId];
    SKPaymentTransaction *transactionCompleted;
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *thisIsProductIDThatHasAlreadyBeenPurchased = transaction.payment.productIdentifier;
        NSLog(@"thisIsProductIDThatHasAlreadyBeenPurchased = %@",thisIsProductIDThatHasAlreadyBeenPurchased);
        if([thisIsProductIDThatHasAlreadyBeenPurchased isEqualToString:selectedProdId])
        {
            //Enable product1 here
            NSLog(@"already purchased.");
            transactionCompleted = transaction;
            self.isRestored = TRUE;
            [self recordTransaction: transactionCompleted];
//            [self provideContent: transactionCompleted.originalTransaction.payment.productIdentifier];

            [self completeTransaction:transactionCompleted];
            return;
        }
        else
        {
            NSLog(@"not purchased.");
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kAppName message:@"Can not restore. You have to purchase the product." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductRestoreFailed object:nil];
}

-(NSString *)getSelProductId
{
    NSString *prodId = @"";
    switch (appDelegate.SelectedPurchaseType) {
        case 1:
            prodId = [NSString stringWithFormat:@"%@",INAPP_PRODUCT_AdvancedWorkout];
            break;
            
        case 2:
            prodId = [NSString stringWithFormat:@"%@",INAPP_PRODUCT_ExpertsWorkout];
            break;
        
        case 3:
            prodId = [NSString stringWithFormat:@"%@",INAPP_PRODUCT_ButtWorkouts];
            break;
        
        case 4:
            prodId = [NSString stringWithFormat:@"%@",INAPP_PRODUCT_RemoveAds];
            break;
        
        case 5:
            prodId = [NSString stringWithFormat:@"%@",INAPP_PRODUCT_AllWorkout];
            break;
            
        default:
            break;
    }
    
    return prodId;
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [appDelegate HideActivity];
}

- (void)dealloc
{
    [_productIdentifiers release];
    _productIdentifiers = nil;
    [_products release];
    _products = nil;
    [_purchasedProducts release];
    _purchasedProducts = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}


@end
