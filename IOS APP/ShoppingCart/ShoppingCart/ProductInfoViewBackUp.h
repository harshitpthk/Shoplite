//
//  ProductInfoView.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 08/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "HttpsOperations.h"
#import "ProductVarience.h"

@interface ProductInfoViewBackUp : UIView<OperationDelegate>
{
    HttpsOperations *getProductDetails;
    HttpsOperations *getBrandDetails;
}

@property(nonatomic,retain) Product *product;
@property(nonatomic,retain) Product *currentProduct;

@property(nonatomic,retain) ProductVarience *currentVarience;

@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UILabel *title;
@property (nonatomic,retain) UILabel *price;
@property (nonatomic,retain) UILabel *quantity;
@property (nonatomic,retain) UISegmentedControl *varienceControl;
@property (nonatomic,retain) UIStepper *quantityStepper;

-(id)initWithFrame:(CGRect)frame withProduct:(Product *)product;
@end
