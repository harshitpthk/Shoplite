//
//  SCartCenterViewController.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 10/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "CenterViewController.h"
#import "KeychainWrapper.h"
#import "ConnectionManager.h"
#import "Shop.h"
#import "Product.h"

static int productViewTag = 222;
@interface CenterViewController ()

@end

@implementation CenterViewController


@synthesize delegate;
@synthesize leftButton;
@synthesize mapViewButton;
@synthesize rightButton;
@synthesize isMapViewVisible;
@synthesize captureSession = _captureSession;
@synthesize videoPreviewLayer = _videoPreviewLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
               
        //Adding button Navigation Items
//        leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showLeftMenu:)];
//        leftButton.tag = 1;
//        self.navigationItem.leftBarButtonItem = leftButton;
//        
//        self.mapViewButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [self.mapViewButton addTarget:self action:@selector(clickOnMapView) forControlEvents:UIControlEventTouchDown];
//        self.navigationItem.titleView = self.mapViewButton;
//        
        
        rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showRightMenu:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        
        self.isMapViewVisible = YES;
        
         [self getShop];
        
        [self setTitle:@"Shoplite"];
        
      
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    _isReading = NO;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self startScanning];
    // Do any additional setup after loading the view.
    
      UITabBar *bar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    
    [bar setTintColor:[Utility getActionableFontColor]];
    [self.view addSubview:bar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loginToStar
{
    
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"login" isPost:YES];
    
    [postRequest setValue:[Utility getUniqueSession] forHTTPHeaderField:@"shoplite-client-id"];
    
    KeychainWrapper *keyChain = [KeychainWrapper getInstance];
    NSData *data = [keyChain myObjectForKey:(__bridge id)kSecAttrAccount];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)data];
    
    
    NSArray *array = [NSArray arrayWithObject:[dict objectForKey:@"email"]];
    
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    
    [postRequest setHTTPBody:jsonData];
    
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
    loginStarOperation = operation;
    
}

-(void)getShop
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"getshop" isPost:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"12.9854762" forKey:@"latitude"];
    [dict setObject:@"77.7101112" forKey:@"longitude"];
    
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    [postRequest setHTTPBody:jsonData];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
    getShopOperation = operation;
    
}

-(void)loginToShop:(NSString *)sessionToken
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"login" isPost:YES];
    
    NSArray *array = [NSArray arrayWithObject:sessionToken];
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    
    [postRequest setHTTPBody:jsonData];
    

    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
    loginShopOperation = operation;
}

#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    if([operation isEqual:loginStarOperation])
    {
        NSString* newStr = [[NSString alloc] initWithData:operation.receivedData encoding:NSUTF8StringEncoding];
        
        //change at server
        if([@"\"success\"" isEqualToString:newStr])
        {
            NSString *sessionToken = [operation.headers objectForKey:@"Set-Cookie"];
            if(sessionToken)
                [ConnectionManager getInstance].currentStarToken =sessionToken;
            
            [self getShop];
        }
        
    }else if([operation isEqual:getShopOperation])
    {
        
        NSError *e = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.receivedData options: NSJSONReadingMutableContainers error: &e];
        if(dict!=nil)
        {
            Shop *shop =[[Shop alloc] init];
            
            shop.name = [dict objectForKey:@"name"];
            //shop.location =[dict objectForKey:@"location"];
            [ConnectionManager getInstance].currentShop =shop;
            
            [self loginToShop:[ConnectionManager getInstance].currentStarToken];
        }
        
    }else if([operation isEqual:loginShopOperation])
    {
        NSString* newStr = [[NSString alloc] initWithData:operation.receivedData encoding:NSUTF8StringEncoding];
        
        
        if([@"success" isEqualToString:newStr])
        {
            
        }
    }
}

#pragma mark QR SCanner
#pragma mark ----------

- (void) startScanning
{
    self.productId = [[UITextField alloc] initWithFrame:CGRectMake(10, self.view.frame.origin.y + 80, 150, 30)];
    self.productId.placeholder = @"Phone No";
    self.productId.textAlignment = NSTextAlignmentLeft;
    self.productId.font = [Utility getFontWithSize:14.0];
    self.productId.adjustsFontSizeToFitWidth = YES;
    self.productId.textColor = [UIColor blackColor];
    self.productId.keyboardType = UIKeyboardTypeNumberPad;
    self.productId.returnKeyType = UIReturnKeyDone;
    self.productId.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    [self.view addSubview:self.productId];
    
    self.fetch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.fetch setTitle:@"Fetch" forState:UIControlStateNormal];
    [self.fetch setTitleColor:[Utility getActionableFontColor] forState:UIControlStateNormal];
    self.fetch.layer.cornerRadius = 4;
    self.fetch.layer.borderWidth = 1.0;
    self.fetch.layer.borderColor = [Utility getHighlightFontColor].CGColor;
    [self.fetch.titleLabel setFont:[Utility getFontWithSize:16.0]];
    [self.fetch.titleLabel setTextAlignment:NSTextAlignmentRight];
    [self.fetch addTarget:self action:@selector(showProduct) forControlEvents:UIControlEventTouchDown];
    
    [self.fetch setFrame:CGRectMake(200, self.view.frame.origin.y + 80, 80, 30)];
    [self.view addSubview:self.fetch];
}

-(void)showProduct
{
    Product *product =[[Product alloc] init];
    product.id = [[self.productId text] integerValue];
    
    UIView *prevView = [self.view viewWithTag:productViewTag] ;
    
    if(prevView)
    {
        [prevView removeFromSuperview];
    }
    
    ProductInfoView *view = [[ProductInfoView alloc] initWithFrame:CGRectMake(25, self.view.frame.origin.y + 120, self.view.frame.size.width-2*25, 240) withProduct:product];
    view.layer.cornerRadius = 4.0;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowRadius =2.0f;
    view.layer.shadowOffset = CGSizeMake(6, 6);
    view.layer.shadowOpacity = 0.3;
    view.layer.masksToBounds =NO;
    //view.clipsToBounds =YES;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    
    view.tag =productViewTag;
    view.delegate =self;
    
    view.transform =CGAffineTransformMakeScale(0.1, 0.1);
    view.layer.opacity =0.1;
    
    [self.view addSubview:view];
    
    
    [UIView animateWithDuration:0.3f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.transform =CGAffineTransformMakeScale(1.0, 1.0);
                         view.layer.opacity =1.0;
                     }
                     completion:^(BOOL finished){
                    }
     ];
    
    [self.productId setHidden:YES];
    [self.fetch setHidden:YES];
}

#pragma mark productInfoViewDelgate
-(void)addProductToCart:(Product *)product
{
    
    ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
    [shoppingCart addProduct:product];
    
    UIView *prevView = [self.view viewWithTag:productViewTag] ;
    [UIView animateWithDuration:0.3f
                     delay: 0.0f
                     options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         prevView.transform =CGAffineTransformMakeScale(0.1, 0.1);
                         prevView.center =CGPointMake(self.view.frame.size.width-20, 0);
                         prevView.layer.opacity =0.1;
                     }
                     completion:^(BOOL finished){
                         [prevView removeFromSuperview];
                     }
     ];
    
    [self.productId setHidden:NO];
    [self.fetch setHidden:NO];
}

-(void) cancelProduct
{
    UIView *prevView = [self.view viewWithTag:productViewTag] ;
    [UIView animateWithDuration:0.3f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         prevView.transform =CGAffineTransformMakeScale(0.1, 0.1);
                         prevView.layer.opacity =0.1;
                     }
                     completion:^(BOOL finished){
                         [prevView removeFromSuperview];
                     }
     ];
    
    [self.productId setHidden:NO];
    [self.fetch setHidden:NO];
}

#pragma mark RightButtonMethod
#pragma mark -----------------

- (void) showRightMenu:(id)sender
{
   
    
    ShoppingCartViewController *itemController = [[ShoppingCartViewController alloc] initWithNibName:nil bundle:nil];
    
   /* CATransition* transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    */
    [self.navigationController pushViewController:itemController animated:YES];
}


#pragma mark MapViewButton Method
#pragma mark --------------------

- (void) clickOnMapView
{

    if(self.isMapViewVisible)
    {

        [self setIsMapViewVisible:NO];
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(30, 80, self.view.frame.size.width-60 , self.view.frame.size.height-120)];
        self.mapView.showsUserLocation = YES;
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.mapView.delegate = self;
        [self.mapView.layer setBorderWidth:2.0f];
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        [self.mapView.layer setBorderColor:[Utility getActionableFontColor].CGColor];
        [self.mapView.layer setCornerRadius:5.0f];
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        
        self.mapView.showsUserLocation = YES;
        self.mapView.mapType = MKMapTypeStandard;
        
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        
        [self.view addSubview:self.mapView];
    }
    else{
        self.isMapViewVisible = YES;
        [self.mapView removeFromSuperview];
    }
    
    
    
}

#pragma mark MapViewDelegate Method
#pragma mark ----------------------

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}


#pragma mark LeftButton Method
#pragma mark -----------------

- (void) showLeftMenu:(id)sender

{
    UIBarButtonItem *button = sender;
    switch (button.tag) {
        case 0:{
            //[close the centerviewscreen]
            [self.delegate movePanelToOriginalPosition];
            break;
        }
        case 1:{
            [self.delegate movePanelRight];
        }
        
        default:
            break;
        
    }
}


#pragma mark QR Scanner Methods
#pragma mark ------------------

- (BOOL)startReading
{
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}



@end
