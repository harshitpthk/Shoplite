//
//  CenterTabController.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 15/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "CenterTabController.h"
#import "ListController.h"
#import "QRScannerController.h"
#import "ProfileController.h"

@interface CenterTabController ()

@end

@implementation CenterTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"ShopLite";
    
    UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showShoppingCart:)];
    
    UIBarButtonItem *signOut = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(chooseDifferentShop)];
    
    self.navigationItem.rightBarButtonItem =cartButton;
    self.navigationItem.leftBarButtonItem = signOut;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
  
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark RightButtonMethod
#pragma mark -----------------

- (void) showShoppingCart:(id)sender
{
    
    ShoppingCartViewController *itemController = [[ShoppingCartViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:itemController animated:YES];
}

-(void)chooseDifferentShop
{
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Choosing a different shop will remove  all the current items in cart. Do you want to proceed ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Proceed", nil];
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [[Utility getApplicationRootClass] launchShopSelectionScreen];
    }
}


@end
