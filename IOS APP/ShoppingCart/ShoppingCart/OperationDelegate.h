//
//  OperationDelegate.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 27/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OperationDelegate <NSObject>

-(void)operationFinishedWithdata:(id)operation;

-(void)operationFailed:(id)operation withErrorCode:(NSUInteger)errorCode;
-(void)networkFailed:(id)operation withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg;
@end
