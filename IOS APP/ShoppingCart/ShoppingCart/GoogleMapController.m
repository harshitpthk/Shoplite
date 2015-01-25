//
//  GoogleMapController.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 20/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#import "GoogleMapController.h"
#import "ConnectionManager.h"

#define minDistance 00003
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface GoogleMapController ()

@end

@implementation GoogleMapController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
                                                            longitude:0
                                                                 zoom:15];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) camera:camera];
    mapView_.myLocationEnabled = YES;
   
    mapView_.delegate =self;
    mapView_.settings.myLocationButton=YES;
    [self.view addSubview:mapView_];

    
    //centerpin
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-20,mapView_.frame.size.height/2-38,40,40)];
    
    [imageView setImage:[UIImage imageNamed:@"pin.png"]];
    [self.view addSubview:imageView];
    self.pinImage = imageView;
    
    
    //navigation bar
     self.title =@"Pick Delivery Point";
    
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchViewController)];
    self.navigationItem.rightBarButtonItem =button;
    
    NSManagedObjectContext *context = [[Utility getApplicationRootClass] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Address" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    
    if(array.count >0)
    {
        button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showDeliveryAddresses)];
        self.navigationItem.leftBarButtonItem =button;
        
        if(array.count==1)
        {
            self.previousDeliveryAddress =[array objectAtIndex:0];
        }
        
    }
    
    //headerView
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(15, 75, self.view.frame.size.width-25,68)];
    
    //address view
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width,self.headerView.frame.size.height)];
    
    self.userAddressText = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.addressView.frame.size.width-65,35)];
    self.userAddressText.placeholder =@"House number and name";
    [self.addressView addSubview:self.userAddressText];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 33, self.addressView.frame.size.width-20,35)];
    [self.addressView addSubview:label];
    [label setFont:[Utility getFontWithSize:12]];
    self.addressLabel =label;
    
    
    UIButton *setButton =[UIButton buttonWithType:UIButtonTypeSystem];
    [setButton setTitle:@"Set" forState:UIControlStateNormal];
    [setButton setFrame:CGRectMake(self.addressView.frame.size.width-55, 0, 42,40)];
    [setButton addTarget:self action:@selector(fixDeliveryAddress) forControlEvents:UIControlEventTouchUpInside];
    [setButton.titleLabel setFont:[Utility getFontWithSize:18.0f]];
    [self.addressView addSubview:setButton];
    

    self.addressView.layer.cornerRadius = 4;
    self.addressView.layer.borderWidth = 0.5;
    self.addressView.layer.borderColor = [Utility getThemeContrastColor].CGColor;
    [self.addressView setBackgroundColor:[Utility getLightColor]];
    
    [self.headerView addSubview:self.addressView];
    
    [self.view addSubview:self.headerView];
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:(NSKeyValueObservingOptionNew) context: nil];
    
    self.navigationController.navigationBar.translucent =YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Implement here to check if already KVO is implemented.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]])
    {
        [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:mapView_.myLocation.coordinate.latitude
                                                                                 longitude:mapView_.myLocation.coordinate.longitude
                                                                                      zoom:15]];
        isMapPointingToCurrentLocation =YES;
        [mapView_ removeObserver:self forKeyPath:@"myLocation"];
        
    }
}


-(void)showSearchViewController
{

    UISearchBarController *searchController = [[UISearchBarController alloc] initWithNibName:nil bundle:nil];
    searchController.delegate =self;
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)showDeliveryAddresses
{
    if(self.previousDeliveryAddress)
    {
        [self selectedDeliveryAddress:self.previousDeliveryAddress];
        
    }else
    {
        DeliveryAddressTableController *controller = [[DeliveryAddressTableController alloc] initWithNibName:nil bundle:nil];
        [controller setCancelButton];
        controller.delegate =self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:nil];
    }
    
    
}

-(void)getAddressFromLatitude:(double)latitude andLongitude:(double)longitude
{
    
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(latitude,longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        for(GMSAddress* addressObj in [response results])
        {
            if(addressObj.lines!=nil && addressObj.lines.count>0)
            {
                [self.addressLabel setText:[addressObj.lines objectAtIndex:0]];
                
                self.deliveryAddress =addressObj;
            }
            break;
            
        }
    }];
}

-(NSDictionary *)getLocationFromAddress:(NSString *)address
{
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,address];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:queryUrl];
    NSError* errorResponse;
    NSURLResponse *response;

    NSData *data = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&errorResponse];
    
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    NSArray* results = [json objectForKey:@"results"];
    NSDictionary *result = [results objectAtIndex:0];
    NSDictionary *geometry = [result objectForKey:@"geometry"];
    NSDictionary *location = [geometry objectForKey:@"location"];
    
    return location;
}

-(void)showBannerWithIndex:(NSUInteger)index
{
    if(self.bannerView==nil)
    {
        self.bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width,self.headerView.frame.size.height)];
        
        UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.addressView.frame.size.width-65,35)];
        mainLabel.tag =11;
        mainLabel.textColor = [Utility getThemeColor];
        [self.bannerView addSubview:mainLabel];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 33, self.addressView.frame.size.width-20,35)];
        [subLabel setFont:[Utility getFontWithSize:12]];
         subLabel.tag =12;
        [self.bannerView addSubview:subLabel];
    
        
        UIButton *shopButton =[UIButton buttonWithType:UIButtonTypeSystem];
        [shopButton setTitle:@"Shop" forState:UIControlStateNormal];
        [shopButton setFrame:CGRectMake(self.addressView.frame.size.width-60, 0, 55,40)];
        [shopButton addTarget:self action:@selector(connectToShop) forControlEvents:UIControlEventTouchUpInside];
        shopButton.tag =13;
        [shopButton.titleLabel setFont:[Utility getFontWithSize:18.0f]];
        [self.bannerView addSubview:shopButton];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicator setFrame:CGRectMake(self.addressView.frame.size.width-57, 0, 40,40)];
        activityIndicator.tag =14;
        [self.bannerView addSubview:activityIndicator];
        
        self.bannerView.layer.cornerRadius = 4;
        self.bannerView.layer.borderWidth = 0.5;
        self.bannerView.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        [self.bannerView setBackgroundColor:[Utility getLightColor]];
        
    }
    
    UILabel *mainLabel =(UILabel *)[self.bannerView viewWithTag:11];
    UILabel *subLabel =(UILabel *) [self.bannerView viewWithTag:12];
    UIButton *setButton =(UIButton *) [self.bannerView viewWithTag:13];
    UIActivityIndicatorView *activityIndicator =(UIActivityIndicatorView *) [self.bannerView viewWithTag:14];
    
    if(index==0)
    {
        [mainLabel setText:@"No shops to serve"];
        [subLabel setText:@"Drag the map to change the delivery location"];
        [setButton setHidden:YES];
        [activityIndicator setHidden:YES];
        
    }else if (index ==1 && selectedShop)
    {
        [mainLabel setText:[NSString stringWithFormat:@"Welcome to %@",[selectedShop name]]];
        [subLabel setText:@"Tap on other shop marker to connect to them"];
        [setButton setHidden:NO];
        [activityIndicator setHidden:YES];
        
    }else if (index ==2 && selectedShop)
    {
        [mainLabel setText:[NSString stringWithFormat:@"Connecting to %@",[selectedShop name]]];
        [subLabel setHidden:YES];
        [setButton setHidden:YES];
        [activityIndicator setHidden:NO];
        [activityIndicator startAnimating];
        
    }
    
    [UIView transitionFromView:self.addressView toView:self.bannerView duration:0.5f options:UIViewAnimationOptionTransitionFlipFromTop+UIViewAnimationOptionCurveEaseOut completion:nil];
}

-(void)hideBanner
{
    
    [UIView transitionFromView:self.bannerView toView:self.addressView duration:0.5f options:UIViewAnimationOptionTransitionFlipFromBottom+UIViewAnimationOptionCurveEaseIn completion:nil];
    
}

-(void)fixDeliveryAddress
{
    isDeliveryAddressFixed =TRUE;
    
    if(self.shops.count==0)
    {
        return;
    }
    
    if(self.shops.count ==1)
    {
        for (int i=0;i<self.shops.count;i++) {
            Shop *shop =[self.shops objectAtIndex:i];
            selectedShop =shop;
            [self connectToShop];
        }
        
    }else
    {
        BOOL isFirstIndex =true;
        
        [mapView_ animateToViewingAngle:50];
        [mapView_ animateToZoom:13.5];
        [self hideNavigationBar];
        
        mapView_.settings.myLocationButton =NO;
        
        CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(mapView_.camera.target.latitude, mapView_.camera.target.longitude);
        
        circleView = [GMSCircle circleWithPosition:circleCenter
                                                 radius:2000];
        
        circleView.fillColor = [UIColor colorWithRed:0 green:0 blue:0.25 alpha:0.05];
        circleView.strokeColor = [Utility getThemeContrastColor];
        circleView.strokeWidth = 1;
        circleView.map = mapView_;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.02];
        self.pinImage.transform =CGAffineTransformMakeTranslation(self.view.frame.size.width/2-50, self.view.frame.size.height/2-20);
        [UIView commitAnimations];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDeliveryAddress)];
        [self.pinImage addGestureRecognizer:tap];
        self.pinImage.userInteractionEnabled=YES;

        
        for (int i=0;i<self.shops.count;i++) {
            
            Shop *shop =[self.shops objectAtIndex:i];
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(shop.latitude, shop.longitude);
            marker.map = mapView_;
            
            if(!self.markers)
            {
                self.markers = [[NSMutableArray alloc] init];
            }
            
            [self.markers addObject:marker];
            if(isFirstIndex)
            {
                selectedShop =shop;
                isFirstIndex =false;
            }
            
        }
        
        [self showBannerWithIndex:1];
    }
}

-(void)changeDeliveryAddress
{
    isDeliveryAddressFixed =NO;
    [self showNavigationBar];
    [mapView_ animateToViewingAngle:0];
    [mapView_ animateToZoom:15];
     mapView_.settings.myLocationButton =YES;
    
    if(circleView)
        circleView.map=nil;
    
    NSArray *array = self.pinImage.gestureRecognizers;
    [self.pinImage removeGestureRecognizer:[array objectAtIndex:0]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.02];
    self.pinImage.transform =CGAffineTransformIdentity;
    [UIView commitAnimations];
    
    for (int i=0;i<self.markers.count;i++) {
        
        GMSMarker *marker =[self.markers objectAtIndex:i];
        marker.map = nil;
        
    }
    
}

-(void)showNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.02];
    self.headerView.transform =CGAffineTransformIdentity;
    [UIView commitAnimations];
}

-(void)hideNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.02];
    self.headerView.transform =CGAffineTransformMakeTranslation(0, -45);
    [UIView commitAnimations];
}

-(void)connectToShop
{
    if(selectedShop)
    {
        [self showBannerWithIndex:2];
        ConnectionManager *manager = [ConnectionManager getInstance];
        manager.currentShop =selectedShop;
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
        [manager prepareRequestForConnection:postRequest withService:@"connect" isPost:YES];
        
        
        NSNumber *num = [NSNumber numberWithUnsignedInt:selectedShop.id];
        NSData *data =[[num stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        [postRequest setHTTPBody:data];
        
        
        HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
        [manager.serailQueue addOperation:operation];
        
        connectShopOperation = operation;
    }
}

-(void)getShopList
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"getshoplist" isPost:YES];
    
    NSLog(@"%f,%f",mapView_.myLocation.coordinate.latitude,mapView_.myLocation.coordinate.longitude);
    
    if(mapView_.myLocation.coordinate.latitude ==0 && mapView_.myLocation.coordinate.longitude==0)
    {
        return;
    }
    
    NSString *latitude= [NSString stringWithFormat:@"%f",mapView_.camera.target.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",mapView_.camera.target.longitude];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:latitude forKey:@"latitude"];
    [dict setObject:longitude forKey:@"longitude"];
    
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    [postRequest setHTTPBody:jsonData];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
    getShopOperation = operation;
}


#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    if([operation isEqual:getShopOperation])
    {
        
        NSError *e = nil;
        NSArray *shopList = [NSJSONSerialization JSONObjectWithData:operation.receivedData options: NSJSONReadingMutableContainers error: &e];
    
        self.shops = [[NSMutableArray alloc] init];
        
        for (int i=0; i<shopList.count; i++) {
            
            NSDictionary *dict = [shopList objectAtIndex:i];
            
            Shop *shop =[[Shop alloc] init];
            
            shop.id = [[dict objectForKey:@"id"] integerValue];
            shop.name = [dict objectForKey:@"name"];
            NSDictionary *location =[dict objectForKey:@"location"];
            
            shop.latitude = [[location objectForKey:@"latitude"] doubleValue];
            shop.longitude = [[location objectForKey:@"longitude"] doubleValue];
            [self.shops addObject:shop];
            
            if(isMapPointingToCurrentLocation)
            {
                if(shop.latitude >  mapView_.camera.target.latitude-0.0003 && shop.latitude <  mapView_.camera.target.latitude + 0.0003  && shop.longitude >  mapView_.camera.target.longitude-0.0003 && shop.longitude <  mapView_.camera.target.longitude + 0.0003 )
                {
                    selectedShop =shop;
                    [self connectToShop];
                    return;
                }
            }
        }
        
        //just required for first shoplist. Since we are cheking whether the user is in shop or not at first fetch of shops.
        isMapPointingToCurrentLocation =FALSE;
        
        if(self.shops.count<1)
        {
            [self showBannerWithIndex:0];
        }
        
    }else if([operation isEqual:connectShopOperation])
    {
        NSError *e = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.receivedData options: NSJSONReadingMutableContainers error: &e];
        
        if([@"success" isEqualToString:[dict objectForKey:@"status"]])
        {
            if(!isMapPointingToCurrentLocation)
            {
                ConnectionManager *manager = [ConnectionManager getInstance];
                
                NSMutableString *address = [[NSMutableString alloc] init];
                [address appendString:self.userAddressText.text];
                [address appendString:[Utility getSpliter]];
                
                for(int i=0;i<self.deliveryAddress.lines.count;i++)
                {
                    if(i!=0)
                        [address appendString:@", "];
                    [address appendString:[self.deliveryAddress.lines objectAtIndex:i]];
                }
                
                manager.user.deliveryAddress = address;
                manager.user.deliveryLat = mapView_.camera.target.latitude;
                manager.user.deliveryLong = mapView_.camera.target.longitude;
                [[Utility getApplicationRootClass] launchMainScreenWithIndex:0];
                
            }else
            {
                [[Utility getApplicationRootClass] launchMainScreenWithIndex:1];
            }
            
            
        }
        
    }
}

-(void)operationFailed:(id)operation withErrorCode:(NSUInteger)errorCode
{
    if (errorCode==UNAUTHORIZED) {
        [[Utility getApplicationRootClass] initiateApplication];
    }else
    {
        [[Utility getApplicationRootClass] launchErrorScreen];
    }
    
}

-(void)networkFailed:(id)operation withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [Utility showNetworkAlert:self withErrorCode:errorCode withMessage:msg];
}


#pragma GMSMapViewDelegate


- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{

    if(isDeliveryAddressFixed)
        return;
    [self getAddressFromLatitude:position.target.latitude andLongitude:position.target.longitude];
    
    [self getShopList];
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if(isDeliveryAddressFixed)
        return;
    
    [self hideBanner];
    //remove previous shops
    selectedShop=nil;
    self.shops = nil;

}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    
    NSUInteger index = [self.markers indexOfObject:marker];
    Shop *shop = [self.shops objectAtIndex:index];
    
    if(shop)
    {
        selectedShop =shop;
        [self showBannerWithIndex:1];
    }
    
    
    return NO;
}



#pragma searchDelegate (UISearchbarControllerDelegate)

-(void)selectedAddress:(NSString *)address
{
    NSDictionary *dict = [self getLocationFromAddress:address];
    
    if(dict)
    {
        double latitude = [[dict objectForKey:@"lat"] doubleValue];
        double longitude = [[dict objectForKey:@"lng"] doubleValue];

        
        [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:latitude
                                                                      longitude:longitude
                                                                           zoom:15]];
    }
}

#pragma DeliveryAddressDelegate (DeliveryAddressTableController)
-(void)selectedDeliveryAddress:(Address *)address
{
    [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:[address.latitude doubleValue]
                                                                  longitude:[address.longitude doubleValue]
                                                                       zoom:15]];
    NSArray *split= [address.fullText componentsSeparatedByString:[Utility getSpliter]];
    
    self.userAddressText.text =split[0];
    

}

@end
