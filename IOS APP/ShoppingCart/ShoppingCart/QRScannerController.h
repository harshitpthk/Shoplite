//
//  QRScannerController.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 15/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import "ProductInfoView.h"
#import "ShoppingCart.h"
#import "ShoppingCartViewController.h"





@interface QRScannerController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,ProductInfoViewDelegate>{

}


//tmp for simulator testing
@property (nonatomic, retain) UIButton *fetch;
@property (nonatomic, retain) UITextField *productId;
@property (nonatomic) BOOL isScannerOn;

@end
