//
//  ProductActionSet.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 15/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "product.h"
#import "ProductVariance.h"
#import "HttpsOperations.h"

@protocol ProductActionSetDelegate <NSObject>

-(void)actionComplete:(id)actionSet;
-(void)actionFailed:(id)operation withErrorCode:(NSUInteger)errorCode;
-(void)networkFailed:(id)operation withActionSet:(id)actionSet  withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg;

@end

@interface ProductActionSet : NSObject <OperationDelegate>

@property (nonatomic,retain) NSString *action;
@property (nonatomic,retain) NSArray *products;
@property (nonatomic,retain) HttpsOperations *operation;
@property (nonatomic,retain) id<ProductActionSetDelegate> delegate;

-(id)initWithProductSet:(NSArray *)array withAction:(NSString *)action withDelegate:(id<ProductActionSetDelegate>)delegate;
-(void)performAction;


@end


