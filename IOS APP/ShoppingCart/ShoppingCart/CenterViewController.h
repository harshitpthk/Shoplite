//
//  SCartCenterViewController.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 10/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ShoppingCartViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HttpsOperations.h"
#import "ProductInfoView.h"
#import "ShoppingCart.h"


@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end


@interface CenterViewController : UIViewController <MKMapViewDelegate,AVCaptureMetadataOutputObjectsDelegate,OperationDelegate,ProductInfoViewDelegate>
{
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
    UIButton        *mapViewButton;
    BOOL            isMapViewVisible;

    
    //QR Variables
    
    //tempStorage
    HttpsOperations *loginStarOperation;
    HttpsOperations *loginShopOperation;
    HttpsOperations *getShopOperation;
}

@property (nonatomic, assign) id<CenterViewControllerDelegate>  delegate;
@property (nonatomic, strong) UIBarButtonItem                   *leftButton;
@property (nonatomic, strong) UIBarButtonItem                   *rightButton;

@property (nonatomic, strong) UIButton                          *mapViewButton;
@property (strong, nonatomic) MKMapView                         *mapView;
@property (nonatomic, assign)   BOOL                              isMapViewVisible;

//tmp for simulator testing
@property (nonatomic, retain) UIButton *fetch;
@property (nonatomic, retain) UITextField *productId;

//QR variables
@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

-(BOOL)startReading;
-(void)loginToStar;
-(void)loginToShop:(NSString *)sessionToken;
-(void)getShop;


@end
