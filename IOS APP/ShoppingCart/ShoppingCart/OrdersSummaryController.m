//
//  OrdersSummaryScreen.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 17/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "OrdersSummaryController.h"
#import "ShoppingCart.h"
#import "ConnectionManager.h"
#import "Enumerations.h"
#import "Address.h"
#import  "BottomView.h"

#define PICKFROMSHOP 0
#define DELIVERATADDRESS 1

#define PAYONLINE 0
#define PAYATDELIVERY 1

@interface OrdersSummaryController ()

@end

@implementation OrdersSummaryController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        addressRowSelected=0;
        paymentRowSelected=0;
    }
    
    return self;
}
- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    ShoppingCart *shoppingCart = [ShoppingCart getInstance];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 32)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text  = [NSString stringWithFormat:@"Order Amount : %0.2f",[shoppingCart getCartTotal]];
    label.textColor = [Utility getLightColor];
    
    [titleView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0,32, self.view.frame.size.width, 10)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text  = [NSString stringWithFormat:@"%lu items",(unsigned long)[shoppingCart productsAtClient].count];
    label.font =[Utility getFontWithSize:10.0];
    label.textColor = [Utility getLightColor];
    [titleView addSubview:label];
    
    self.navigationItem.titleView = titleView;
     
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 120) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces =NO;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:tableView];
    addressTable =tableView;
    
    
    viewPayment = [[UIView alloc] initWithFrame:CGRectMake(0,150, self.view.frame.size.width, 120)];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(10,0, self.view.frame.size.width-20, 1)];
    [divider setBackgroundColor:[Utility getThemeColor]];
    divider.layer.opacity =0.3;
    [viewPayment addSubview:divider];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,10, self.view.frame.size.width, 80) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces =NO;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [viewPayment addSubview:tableView];
    PaymentTable = tableView;
    
    divider = [[UIView alloc] initWithFrame:CGRectMake(10, 119, self.view.frame.size.width-20, 1)];
    [divider setBackgroundColor:[Utility getThemeColor]];
    divider.layer.opacity =0.3;
    [viewPayment addSubview:divider];
    
    
    [self.view addSubview:viewPayment];
    
    CGFloat bottomViewHeight =55;
    
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50-[Utility getHeightToExclude], self.view.frame.size.width, bottomViewHeight)];
    
    [bottomView.leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [bottomView.leftButton  addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView.rightButton setTitle:@"Order" forState:UIControlStateNormal];
    [bottomView.rightButton addTarget:self action:@selector(placeOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomView];
    
    [self.view setBackgroundColor:[Utility getLightColor]];
    
    self.navigationController.navigationBar.translucent = NO;
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

-(void)cancelOrder
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)placeOrder
{
    ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
    
    BOOL isRegistered =false;
    if([shoppingCart isCartProcessingAnyActions])
    {
        isRegistered = true;
        [shoppingCart registerForChangeNotification:self withKeyPath:@"cartActionsFinished"];
        
    }else
    {
        [self submitOrderToServer];
    }
    
    //since it a sync thread it may happen that by the time we addObserver cart may completed it actions so double check again if it registered
    if(![shoppingCart isCartProcessingAnyActions] && isRegistered)
    {
        [shoppingCart unregisterForChangeNotification:self withKeyPath:@"cartActionsFinished"];
        [self submitOrderToServer];
    }
    
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqual:@"cartActionsFinished"]) {
        NSArray *actionSetArray = [change objectForKey:NSKeyValueChangeNewKey];
        
        ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
        if(actionSetArray.count==0)
        {
            [shoppingCart unregisterForChangeNotification:self withKeyPath:@"cartActionsFinished"];
            [self submitOrderToServer];
        }
        
    }
}


-(void)saveDeliveryAddress
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    if(manager.user.deliveryAddress)
        [Utility saveDeliveryAddress:manager.user.deliveryAddress withLatitude:manager.user.deliveryLat withLongitude:manager.user.deliveryLong];
}

#pragma mark - tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifier = @"Cell";
    
   if([tableView isEqual:addressTable])
   {
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       if (cell == nil) {
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
       }
       
       cell.accessoryType = UITableViewCellAccessoryNone;
       cell.detailTextLabel.text = nil;
       cell.imageView.image =nil;
       
       if(indexPath.row ==PICKFROMSHOP)
       {
           cell.textLabel.text =@"Pick From Shop";
           
           if(addressRowSelected==PICKFROMSHOP)
           {
               cell.accessoryType = UITableViewCellAccessoryCheckmark;
               
               cell.detailTextLabel.numberOfLines =3;
               cell.detailTextLabel.text = @"#140 flat 9 Sumadhura Sawan, Seetharamapalaya, Hoodi circle, bangalore";
           }
           
       }else if (indexPath.row ==DELIVERATADDRESS)
       {
           cell.textLabel.text =@"Deliver at address";
           
           if(addressRowSelected==DELIVERATADDRESS)
           {
               cell.accessoryType = UITableViewCellAccessoryCheckmark;
               ConnectionManager *manager = [ConnectionManager getInstance];
        
               if(manager.user.deliveryAddress)
               {
                   cell.detailTextLabel.numberOfLines =3;
                   cell.detailTextLabel.text = [manager.user.deliveryAddress stringByReplacingOccurrencesOfString:[Utility getSpliter] withString:@", "];
                   
               }
           }
       }

       
       return cell;

   }else
   {
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       if (cell == nil) {
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
       }
       
       if(indexPath.row ==PAYONLINE)
           cell.textLabel.text =@"Pay Online";
       
       else if (indexPath.row ==PAYATDELIVERY)
           cell.textLabel.text =@"Pay at Delivery";
       
       if(paymentRowSelected==indexPath.row)
       {
           cell.accessoryType = UITableViewCellAccessoryCheckmark;
           
       }else
       {
           cell.accessoryType = UITableViewCellAccessoryNone;
       }
       
       return cell;
   }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([tableView isEqual:PaymentTable])
    {
        return 40;
    }
    
    if(addressRowSelected==indexPath.row)
        return 80;
    
    else
        return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:PaymentTable] && paymentRowSelected != indexPath.row)
    {
        paymentRowSelected = indexPath.row;
        [tableView reloadData];
    }
    else if(addressRowSelected != indexPath.row)
    {
        addressRowSelected = indexPath.row;
        ConnectionManager *manager = [ConnectionManager getInstance];
        
        if(addressRowSelected == DELIVERATADDRESS && !manager.user.deliveryAddress)
        {
            DeliveryAddressTableController *controller = [[DeliveryAddressTableController alloc] initWithNibName:nil bundle:nil];
            [controller setAddButtonWithRestriction:YES];
            controller.delegate =self;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            [tableView reloadData];
        }
    }

}

#pragma mark - opeartions

-(void)submitOrderToServer
{
    ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
    
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"submitorder" isPost:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if(addressRowSelected==PICKFROMSHOP )
    {
        
        if(PAYONLINE ==paymentRowSelected)
        {
            [dict setValue:[Utility getOrderStatusObject:FORDELIVERY] forKey:@"status"];
            [dict setObject:@"ONL345" forKey:@"refNumber"];
            
        }else
        {
            [dict setValue:[Utility getOrderStatusObject:FORPAYMENT] forKey:@"status"];
        }
        
        
    }else{
        
        NSString *address =nil;
        
        if(manager.user.deliveryAddress)
        {
            address =manager.user.deliveryAddress;
            
        }else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"Please enter delivery address" delegate:self
                                                      cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
        
        
        
        [dict setObject:[NSString stringWithFormat:@"%@" ,address] forKey:@"address"];
        [dict setObject:[NSNumber numberWithDouble:manager.user.deliveryLat] forKey:@"latitude"];
        [dict setObject:[NSNumber numberWithDouble:manager.user.deliveryLong] forKey:@"longitude"];
        
        if(PAYONLINE ==paymentRowSelected)
        {
            [dict setValue:[Utility getOrderStatusObject:FORHOMEDELIVERY] forKey:@"status"];
            [dict setObject:@"ONL345" forKey:@"refNumber"];
            
        }else
        {
            [dict setValue:[Utility getOrderStatusObject:FORHOMEDELIVERYPAYMENT] forKey:@"status"];
        }
    }
    
   [dict setObject:[NSNumber numberWithDouble:[shoppingCart getCartTotal]] forKey:@"amount"];
    
    
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    [postRequest setHTTPBody:jsonData];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
    [self saveDeliveryAddress];
}

#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    NSString *newStr = [[NSString alloc] initWithData:operation.receivedData encoding:NSUTF8StringEncoding];
    NSUInteger orderId = [newStr integerValue];
    
    [[ShoppingCart getInstance] saveOrderWithId:orderId withStatus:@"PACKING"];
    [[Utility getApplicationRootClass] launchMainScreenWithIndex:2];
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

#pragma mark - DeliveryAddressDelegate

-(void)selectedDeliveryAddress:(Address *)address
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    manager.user.deliveryAddress  =address.fullText;
    manager.user.deliveryLat = [address.latitude doubleValue];
    manager.user.deliveryLong =[address.longitude doubleValue];
    
    [addressTable reloadData];
}

@end
