//
//  QRScannerController.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 15/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "QRScannerController.h"
#import "KeychainWrapper.h"
#import "ConnectionManager.h"
#import "Shop.h"
#import "Product.h"
#import "Utility.h"

@interface QRScannerController ()


@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CALayer *targetLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


- (void) startQRScanner;

@end

static int productViewTag = 222;


@implementation QRScannerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Scan";
        [self.view setBackgroundColor:[Utility getDarkColor]];
        self.tabBarItem.image = [UIImage imageNamed:@"barcode-7.png"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startScanning];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopScanning];
    
}

-(void) startScanning
{
    self.isScannerOn =TRUE;
    #if (TARGET_IPHONE_SIMULATOR)
        [self startIdScanning];
    #else
        NSLog(@"Running on a device");
        [self startQRScanner];
    #endif
}

-(void) stopScanning
{
    self.isScannerOn =FALSE;
#if (TARGET_IPHONE_SIMULATOR)
    [self stopIdScanning];
#else
    NSLog(@"Running on a device");
    [self stopQRScanner];
#endif
}

#pragma mark QRErrorAlertHandler
#pragma mark -----------------

- (void)showAlertForCameraError:(NSError *)error
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera Error"
                                                        message:@"Cant Read Camera"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark Notifications
#pragma mark -----------

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self stopScanning];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [self startScanning];
}


#pragma mark QRScanner and Delgate Methods
#pragma mark -------------------------

- (void) startQRScanner
{
    [self.captureSession startRunning];
}

- (void) stopQRScanner
{
    [self.previewLayer removeFromSuperlayer];
    [self.targetLayer removeFromSuperlayer];
    [self.captureSession stopRunning];
    
    self.previewLayer=nil;
    self.targetLayer=nil;
    self.captureSession = nil;
}

- (AVCaptureSession *)captureSession
{
    if (!_captureSession)
    {
        NSError *error = nil;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device.isAutoFocusRangeRestrictionSupported)
        {
            if ([device lockForConfiguration:&error])
            {
                [device setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
                [device unlockForConfiguration];
            }
        }
        
        
        
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (deviceInput)
        {
            _captureSession = [[AVCaptureSession alloc] init];
            if ([_captureSession canAddInput:deviceInput])
            {
                [_captureSession addInput:deviceInput];
            }
            
            AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
            if ([_captureSession canAddOutput:metadataOutput])
            {
                [_captureSession addOutput:metadataOutput];
                [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
                [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            }
            
            self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.previewLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:self.previewLayer];
            
            self.targetLayer = [CALayer layer];
            self.targetLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:self.targetLayer];
            
        }
        else
        {
            NSLog(@"Input Device error: %@",[error localizedDescription]);
            [self showAlertForCameraError:error];
        }
    }
    return _captureSession;
}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if(!self.isScannerOn)
    {
        return;
    }
    for (AVMetadataObject *metadataObject in metadataObjects)
    {
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            AVMetadataMachineReadableCodeObject *transformed = (AVMetadataMachineReadableCodeObject *)metadataObject;
            
            NSString *str = [transformed stringValue];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self stopQRScanner];
            [self showProduct:str];
            
        }
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark AddProductScreen
#pragma mark ------------

/*temporary for prodcut scan in simulator*/
- (void) startIdScanning
{
    if(!self.productId)
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
    }
    
    if(!self.fetch)
    {
        self.fetch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.fetch setTitle:@"Fetch" forState:UIControlStateNormal];
        self.fetch.layer.cornerRadius = 4;
        self.fetch.layer.borderWidth = 1.0;
        self.fetch.layer.borderColor = [Utility getLightColor].CGColor;
        [self.fetch.titleLabel setFont:[Utility getFontWithSize:16.0]];
        [self.fetch.titleLabel setTextAlignment:NSTextAlignmentRight];
        [self.fetch addTarget:self action:@selector(showProduct) forControlEvents:UIControlEventTouchDown];
        
        [self.fetch setFrame:CGRectMake(200, self.view.frame.origin.y + 80, 80, 30)];
        [self.view addSubview:self.fetch];
    }
    
    [self.productId setHidden:NO];
    [self.fetch setHidden:NO];
}

-(void)stopIdScanning
{
    [self.productId setHidden:YES];
    [self.fetch setHidden:YES];
}

-(void)showProduct
{
    [self stopScanning];
    [self showProduct:self.productId.text];
}

-(void)showProduct:(NSString *)productId
{
    
    Product *product =[[Product alloc] init];
    product.id = [productId integerValue];
    
    UIView *prevView = [self.view viewWithTag:productViewTag] ;
    
    if(prevView)
    {
        [prevView removeFromSuperview];
    }
    
    ProductInfoView *view = [[ProductInfoView alloc] initWithFrame:CGRectMake(25, self.view.frame.origin.y + 60, self.view.frame.size.width-2*25, 240) withProduct:product];
    view.layer.cornerRadius = 4.0;
    view.layer.shadowColor = [Utility getThemeContrastColor].CGColor;
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
                         [self startScanning];
                     }
     ];
    
    
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
                         [self startScanning];
                     }
     ];
    
   [self startScanning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
