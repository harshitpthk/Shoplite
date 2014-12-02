//
//  Shop.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 07/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject
@property(nonatomic) NSUInteger id;
@property(nonatomic,retain) NSString *name;
@property(nonatomic) double latitude;
@property(nonatomic) double longitude;
@property(nonatomic,retain) NSString *address;

@end
