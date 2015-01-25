//
//  ShoppingCart.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 14/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "ProductActionSet.h"

@interface ShoppingCart : NSObject<ProductActionSetDelegate>
{
}

@property (nonatomic, retain) NSMutableArray *productsAtClient;
@property (nonatomic, retain) NSMutableArray *productsAtServer;

/* actions(insert/delete/modify) items in shopping cart that sent to server are stored temperoraily here until the action is complete from server side */



/* The products which are added to shopping cart are not imediately sent to server , Until we reach the products count to some number ( example 3 )they are hold in this array. Once they are dispatched this array will be empty.*/
@property (nonatomic, retain) NSMutableArray *currentPendingInsertSet;
+(ShoppingCart*)getInstance;
+(void)clearInstance;

-(void)addProduct:(Product *)product;
-(void)removeProduct:(Product *)product;
-(void)modifyProduct:(Product *)product withPrevVarianceIndex:(int)varianceIndex withPrevQuantity:(int)quantity;

-(double) getCartTotal;
-(void)checkOutCart;
-(BOOL)saveList:(NSString *)name;
-(BOOL)saveOrderWithId:(NSInteger )orderId withStatus:(NSString *)status;

-(BOOL)isCartProcessingAnyActions;
- (void)registerForChangeNotification:(id)object withKeyPath:(NSString *)keyPath;
- (void)unregisterForChangeNotification:(id)object withKeyPath:(NSString *)keyPath;
@end
