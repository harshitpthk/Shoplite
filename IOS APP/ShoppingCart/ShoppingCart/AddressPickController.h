//
//  AddressPickController.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 23/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "UISearchBarController.h"

@protocol AddressPickDelegate <NSObject>
-(void)selectedDeliveryAddress:(NSString *)address withLatitude:(double)latitude withLongitude:(double)longitude;
@end

@interface AddressPickController : UIViewController<GMSMapViewDelegate,SearchDelegate>
{
    GMSMapView *mapView_;
    GMSCircle *circleView;
}

@property(nonatomic,retain) UILabel *addressLabel;
@property(nonatomic,retain) UITextField *userAddressText;
@property(nonatomic,retain) UIView *addressView;
@property(nonatomic,retain) GMSAddress *deliveryAddress;
@property(nonatomic) BOOL shdRestrictAddressAroundShop;
@property(nonatomic,assign) id<AddressPickDelegate> delegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil shoudRestrictArroundShop:(BOOL)shdRestrict;
@end
