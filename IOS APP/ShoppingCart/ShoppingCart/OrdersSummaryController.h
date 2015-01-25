//
//  OrdersSummaryScreen.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 17/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpsOperations.h"
#import "OperationDelegate.h"
#import  "DeliveryAddressTableController.h"


@interface OrdersSummaryController : UIViewController<UITableViewDataSource,UITableViewDelegate,OperationDelegate,DeliveryAddressDelegate>
{
 
    NSUInteger addressRowSelected;
    NSUInteger paymentRowSelected;
    
    UITableView *addressTable;
    UITableView *PaymentTable;
    
    UIView *viewPayment;
}

@end
