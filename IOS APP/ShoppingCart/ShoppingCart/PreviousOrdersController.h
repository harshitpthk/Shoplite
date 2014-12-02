//
//  PreviousOrdersController.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 16/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviousOrdersController : UIViewController<UITableViewDataSource,UITableViewDelegate,OperationDelegate>

@property (nonatomic,retain) UITableView *ordersTable;
@property (nonatomic,retain) UISegmentedControl *ordersSegment;

@property (nonatomic,retain) NSMutableArray *orderHistoryData;
@property (nonatomic,retain) NSMutableArray *savedOrdersData;

-(void)setCancelButton;
@end
