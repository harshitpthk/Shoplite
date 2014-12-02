//
//  ProfileController.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 15/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderStatusCell.h"
#import "Order.h"
#import "HttpsOperations.h"
#import "OperationDelegate.h"

@interface ProfileController : UIViewController<UITableViewDataSource,UITableViewDelegate,OperationDelegate>

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *pendingOrdersData;

@property (nonatomic,retain) NSMutableDictionary *statusOperationsDict;
@end
