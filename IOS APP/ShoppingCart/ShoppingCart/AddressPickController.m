//
//  AddressPickController.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 23/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "AddressPickController.h"
#import "ConnectionManager.h"
#import "Utility.h"

@interface AddressPickController ()

@end

@implementation AddressPickController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil shoudRestrictArroundShop:(BOOL)shdRestrict
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        self.shdRestrictAddressAroundShop =shdRestrict;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    double latitude = 0;
    double longitude =0;
    
    if(manager.currentShop)
    {
        latitude = manager.currentShop.latitude;
        longitude = manager.currentShop.longitude;
    }
    
    
    // Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:15];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-[Utility getHeightToExclude]) camera:camera];
    mapView_.myLocationEnabled = YES;
    
    mapView_.delegate =self;
    mapView_.settings.myLocationButton=YES;
    [self.view addSubview:mapView_];
    
    
    
    //centerpin
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-20,mapView_.frame.size.height/2-38,40,40)];
    
    [imageView setImage:[UIImage imageNamed:@"pin.png"]];
    [self.view addSubview:imageView];
   
    
    //navigation bar
    self.title =@"Pick Delivery Point";

    
    //address view
    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width-25,68)];
    
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
    
    [self.view addSubview:self.addressView];
    
    if(self.shdRestrictAddressAroundShop)
    {
        CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(latitude, longitude);
        
        circleView = [GMSCircle circleWithPosition:circleCenter
                                            radius:2000];
        
        circleView.fillColor = [UIColor colorWithRed:0 green:0 blue:0.25 alpha:0.05];
        circleView.strokeColor = [Utility getThemeContrastColor];
        circleView.strokeWidth = 1;
        circleView.map = mapView_;
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.map = mapView_;
        
    }else
    {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchViewController)];
        self.navigationItem.rightBarButtonItem =button;
    
    }
    
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

//is valid when we are adding address from profile
-(void)showSearchViewController
{
    
    UISearchBarController *searchController = [[UISearchBarController alloc] initWithNibName:nil bundle:nil];
    searchController.delegate =self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self presentViewController:navController animated:YES completion:nil];
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

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{

    [self getAddressFromLatitude:position.target.latitude andLongitude:position.target.longitude];
    
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
        self.addressLabel.text = address;
    }
}

-(void)fixDeliveryAddress
{
    if(self.delegate)
    {
        NSMutableString *address = [[NSMutableString alloc] init];
        [address appendString:self.userAddressText.text];
        [address appendString:[Utility getSpliter]];
        
        for(int i=0;i<self.deliveryAddress.lines.count;i++)
        {
            if(i!=0)
                [address appendString:@", "];
            [address appendString:[self.deliveryAddress.lines objectAtIndex:i]];
        }
        
        [self.delegate selectedDeliveryAddress:address withLatitude:mapView_.camera.target.latitude withLongitude:mapView_.camera.target.longitude];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
