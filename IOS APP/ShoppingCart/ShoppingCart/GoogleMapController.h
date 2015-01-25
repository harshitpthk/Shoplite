//
//  GoogleMapController.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 20/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "HttpsOperations.h"
#import "UISearchBarController.h"
#import "Shop.h"
#import "DeliveryAddressTableController.h"

@interface GoogleMapController : UIViewController<GMSMapViewDelegate,OperationDelegate,SearchDelegate,DeliveryAddressDelegate>
{
    GMSMapView *mapView_;
    
    //tempStorage
    HttpsOperations *connectShopOperation;
    HttpsOperations *getShopOperation;
    Shop *selectedShop;
    
    BOOL isMapPointingToCurrentLocation;
    BOOL isDeliveryAddressFixed;
    
    GMSCircle *circleView; 

}

@property(nonatomic,retain) NSMutableArray *shops;
@property(nonatomic,retain) NSMutableArray *markers;
@property(nonatomic,retain) UILabel *addressLabel;
@property(nonatomic,retain) UITextField *userAddressText;
@property(nonatomic,retain) UIView *bannerView;
@property(nonatomic,retain) UIView *addressView;
@property(nonatomic,retain) UIView *headerView;
@property(nonatomic,retain) UIImageView *pinImage;

@property(nonatomic,retain) GMSAddress *deliveryAddress;

//is set when only one previous address exist if more we present DeliveryAddressTableController to pick
@property(nonatomic,retain) Address *previousDeliveryAddress;

-(NSDictionary *)getLocationFromAddress:(NSString *)address;
-(void)getAddressFromLatitude:(double)latitude andLongitude:(double)longitude;

@end
