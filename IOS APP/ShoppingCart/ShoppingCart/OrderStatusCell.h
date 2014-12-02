//
//  OrderStatusCellTableViewCell.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 22/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusCell : UITableViewCell

@property(nonatomic,retain) NSArray *statusArray;
@property(nonatomic,retain) UILabel *mainTitle;
@property(nonatomic,retain) UILabel *rightTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withStatusArray:(NSArray *)array;
-(void)highlightStatus:(NSString *)status;
@end
