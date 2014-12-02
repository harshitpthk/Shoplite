//
//  OrderDetailController.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 16/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItemDetail.h"
#import "OrderDetailCell.h"

@interface OrderDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,OperationDelegate>

@property (nonatomic,retain) UITableView *orderDetailsTable;
@property (nonatomic,retain) NSArray *list;
@property (nonatomic,retain) NSMutableArray *selectedProducts;
@property (nonatomic,retain) NSMutableArray *outOfStockProducts;
@property (nonatomic,retain) NSNumber *amount;

@property (nonatomic) int operationCount;
@end
