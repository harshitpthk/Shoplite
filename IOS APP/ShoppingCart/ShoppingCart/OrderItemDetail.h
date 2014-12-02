//
//  OrderItemDetail.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 17/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItemDetail : NSObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * varianceName;
@property (nonatomic, retain) NSNumber * varianceId;
@property (nonatomic, retain) NSNumber * quantitySelected;
@property (nonatomic, retain) NSNumber * amount;

@end
