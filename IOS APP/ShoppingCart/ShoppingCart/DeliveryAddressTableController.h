//
//  DeliveryAddressTableViewController.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 22/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
#import  "AddressPickController.h"
#import "ConnectionManager.h"

@protocol DeliveryAddressDelegate <NSObject>
-(void)selectedDeliveryAddress:(Address *)address;
@end

@interface DeliveryAddressTableController : UITableViewController<AddressPickDelegate>

@property(nonatomic,assign) id<DeliveryAddressDelegate> delegate;
@property(nonatomic,retain) NSMutableArray *data;
@property(nonatomic) BOOL shdRestrictAddressAroundShop;

-(void)setAddButtonWithRestriction:(BOOL)shdRestrictAddressAroundShop;
-(void)setCancelButton;

@end
