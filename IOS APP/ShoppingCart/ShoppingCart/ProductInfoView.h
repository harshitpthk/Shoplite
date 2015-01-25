//
//  ProductInfoView1.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 10/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "HttpsOperations.h"
#import "ProductVariance.h"

@protocol ProductInfoViewDelegate <NSObject>

-(void)addProductToCart:(Product *)product;
-(void)cancelProduct;

@end

@interface ProductInfoView : UIView<OperationDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    HttpsOperations *getProductDetails;
    HttpsOperations *getBrandDetails;
}

@property(nonatomic,retain) Product *product;
@property(nonatomic,retain) Product *currentProduct;


@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UILabel *title;
@property (nonatomic,retain) UILabel *price;
@property (nonatomic,retain) UILabel *error;
@property (nonatomic,retain) UIPickerView *variancePicker;
@property (nonatomic,retain) UIPickerView *quantityPicker;

@property (nonatomic,retain) UIButton *addProduct;
@property (nonatomic,retain) UIButton *cancelProduct;

@property(nonatomic,assign) id<ProductInfoViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withProduct:(Product *)product;
@end