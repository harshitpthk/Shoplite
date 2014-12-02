//
//  Product.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 08/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductVariance.h"

@interface Product : NSObject

@property(nonatomic) NSUInteger id;
@property(nonatomic,retain) NSString *name;
@property(nonatomic) NSUInteger categoryId;
@property(nonatomic) NSUInteger brandId;
@property(nonatomic,retain) NSMutableArray *varianceList;
@property(nonatomic) NSUInteger varianceSelected;
@property(nonatomic) NSUInteger quantitySelected;

-(ProductVariance *)getSelectedVarience;

/*checks whether two prodcuts id's are equal and also have same quantity and variance selected*/
- (BOOL)isProductEqual:(Product *)product;
-(BOOL)isSimilarProductFoundInArray:(NSArray *)array;
-(Product *)getSimilarProductInArray:(NSArray *)array;
@end
