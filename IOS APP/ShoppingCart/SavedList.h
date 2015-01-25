//
//  SavedList.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 29/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderDetail;

@interface SavedList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * noOfItems;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *listDetails;
@end

@interface SavedList (CoreDataGeneratedAccessors)

- (void)addListDetailsObject:(OrderDetail *)value;
- (void)removeListDetailsObject:(OrderDetail *)value;
- (void)addListDetails:(NSSet *)values;
- (void)removeListDetails:(NSSet *)values;

@end
