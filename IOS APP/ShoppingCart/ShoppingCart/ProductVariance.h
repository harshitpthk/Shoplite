//
//  ProductVarience.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 08/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductVariance : NSObject
@property(nonatomic) NSUInteger id;
@property(nonatomic,retain) NSString *name;
@property(nonatomic) double price;
@property(nonatomic) NSUInteger quantity;
@end
