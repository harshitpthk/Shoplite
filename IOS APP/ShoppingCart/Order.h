//
//  Order.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 29/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderDetail;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * noOfItems;
@property (nonatomic, retain) NSSet *details;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addDetailsObject:(OrderDetail *)value;
- (void)removeDetailsObject:(OrderDetail *)value;
- (void)addDetails:(NSSet *)values;
- (void)removeDetails:(NSSet *)values;

@end
