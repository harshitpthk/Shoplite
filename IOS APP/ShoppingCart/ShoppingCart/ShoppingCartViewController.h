//
//  SCartItemsController.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 15/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ProductVariance.h"
#import "ProductTableViewCell.h"
#import "ShoppingCart.h"
#import "OrdersSummaryController.h"

@interface ShoppingCartViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{

    
}

@property (nonatomic, retain) UITableView   *productTable;
@property (nonatomic, retain) UITextField *saveTextField;

/* This array always point to ShoppingCart's prodcuts at client.*/
@property (nonatomic, retain) NSMutableArray *cartProducts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)updateTotalInHeader;
@end
