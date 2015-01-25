//
//  ProductTableViewCell.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 14/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ProductVariance.h"

@interface ProductTableViewCell : UITableViewCell<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
}

@property (nonatomic,retain) UIImageView *productImageView;
@property (nonatomic,retain) UILabel *title;
@property (nonatomic,retain) UILabel *vareinceTitle;
@property (nonatomic,retain) UILabel *price;
@property (nonatomic,retain) UILabel *quantity;
@property (nonatomic,retain) UILabel *total;
@property (nonatomic,retain) Product *currentProduct;

@property (nonatomic,retain) UIButton *editButton;

@property (nonatomic,retain) UIView *editView;
@property (nonatomic,retain) UIPickerView *variancePicker;
@property (nonatomic,retain) UIPickerView *quantityPicker;

//temporarly store for previous varience while user is editing. After editing you can compare this with the selected varience and do apropriate action
@property (nonatomic) int prevVarianceIndexSelected;

//temporarly store for quantitySelected while user is editing. After editing you can compare this with the selected varience and do apropriate action
@property (nonatomic) int prevQuantitySelected;

- (id)initWithProduct:(Product *)product reuseIdentifier:CellIdentifier;
-(void)goToEditMode;
-(void)removeEditMode;

@end