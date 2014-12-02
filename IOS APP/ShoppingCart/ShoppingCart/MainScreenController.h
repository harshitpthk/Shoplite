//
//  SCartQRScanner.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 10/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
#import "LeftViewController.h"

@interface MainScreenController : UIViewController<CenterViewControllerDelegate>
{
    CenterViewController *centerView;
    LeftViewController   *leftView;
    UINavigationController    *centerNavController;
    UINavigationController    *leftNavController;
}

@property (nonatomic, strong) CenterViewController *centerView;
@property (nonatomic, strong) LeftViewController   *leftView;
@property (nonatomic, strong) UINavigationController    *centerNavController;
@property (nonatomic, strong) UINavigationController    *leftNavController;



@end
