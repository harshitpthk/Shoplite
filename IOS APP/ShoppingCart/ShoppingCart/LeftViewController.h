//
//  SCartLeftViewController.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 10/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController <UITableViewDataSource, UITabBarDelegate>
{
    UITableView     *leftTable;
}

@property (nonatomic, strong) UITableView *leftTable;
@property (nonatomic,strong) NSMutableArray *menuItems;

@end
