//
//  ProductActionSet.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 15/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "ProductActionSet.h"
#import "ConnectionManager.h"
#import "ShoppingCart.h"

@implementation ProductActionSet

-(id)initWithProductSet:(NSArray *)array withAction:(NSString *)action withDelegate:(id<ProductActionSetDelegate>)delegate
{
    
    
    if(self =[super init])
    {
        self.action =action;
        self.products =array;
        self.delegate =delegate;
    }
    
    return self;
}

-(void)performAction
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i=0; i<self.products.count; i++) {
        
        Product *product = [self.products objectAtIndex:i];
        ProductVariance *variance = [product getSelectedVarience];
        
        NSString *itemId = [NSString stringWithFormat:@"%d",variance.id];
        NSString *quantity = [NSString stringWithFormat:@"%d",(int)product.quantitySelected];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:itemId forKey:@"varianceId"];
        [dict setObject:quantity forKey:@"quantity"];
        
        [items addObject:dict];
    }
    
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"packproducts" isPost:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.action forKey:@"state"];
    [dict setObject:items forKey:@"products"];
    
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    [postRequest setHTTPBody:jsonData];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
    self.operation =operation;
}

#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    [self.delegate actionComplete:self];
}

-(void)operationFailed:(id)operation withErrorCode:(NSUInteger)errorCode
{
    [self.delegate actionFailed:self withErrorCode:errorCode];
}

-(void)networkFailed:(id)operation withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [self.delegate networkFailed:operation withActionSet:self withErrorCode:errorCode withMessage:msg];
}
@end
