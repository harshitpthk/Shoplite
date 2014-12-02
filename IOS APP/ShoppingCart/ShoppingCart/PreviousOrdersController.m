//
//  PreviousOrdersController.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 16/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "PreviousOrdersController.h"
#import "OrderDetailController.h"
#import "ConnectionManager.h"
#import  "OrderItemDetail.h"

@interface PreviousOrdersController ()

@end

@implementation PreviousOrdersController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Orders";
        [self.view setBackgroundColor:[Utility getLightColor]];

        
    
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    
    
    CGFloat heightToExclude =[Utility getHeightToExclude];
    
    self.ordersSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Saved",@"Previous", nil]];
    [self.ordersSegment setFrame:CGRectMake((self.view.frame.size.width-200)/2, 10,200, 35)];
    [self.ordersSegment setSelectedSegmentIndex:0];
    [self.ordersSegment addTarget:self action:@selector(switchOrders:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:self.ordersSegment];
    
    self.ordersTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-heightToExclude) style:UITableViewStyleGrouped];
    
    self.ordersTable.delegate =self;
    self.ordersTable.dataSource =self;
    
    self.ordersTable.tableHeaderView =headerView;
    [self.ordersTable setBackgroundColor:[Utility getLightColor]];
    [self.view addSubview:self.ordersTable];
        
}

- (void) viewWillAppear:(BOOL)animated
{
    
    NSManagedObjectContext *context = [[Utility getApplicationRootClass] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Order" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    
    self.orderHistoryData = [[NSMutableArray alloc] init];
    
    for (int i=0; i<array.count; i++) {
        Order *order = [array objectAtIndex:i];
        
        if([order.status isEqualToString:@"DELIVERED"])
        {
           [self.orderHistoryData addObject:order];
        }
    }
    
    
    entity = [NSEntityDescription entityForName:@"SavedList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    array = [context executeFetchRequest:fetchRequest error:&error];
    
    self.savedOrdersData =[NSMutableArray arrayWithArray:array];
    [self.ordersTable reloadData];
    
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSManagedObjectContext *context = [[Utility getApplicationRootClass] managedObjectContext];
    NSError *error;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)setCancelButton
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

-(void)cancelView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)switchOrders:(id)sender{
    [self.ordersTable reloadData];
}

#pragma UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    if(self.ordersSegment.selectedSegmentIndex == 0)
    {
        SavedList *order = [self.savedOrdersData objectAtIndex:indexPath.row];
        cell.mainTitle.text = order.name;
        cell.subTitle.text =[NSString stringWithFormat:@"%ld items", (long)[order.noOfItems integerValue]];
        cell.rightTitle.text = @"";
        
    }else
    {
        Order *order = [self.orderHistoryData objectAtIndex:indexPath.row];
        cell.mainTitle.text = [NSString stringWithFormat:@"%f", [order.date timeIntervalSince1970]];
        cell.subTitle.text = order.status;
        cell.rightTitle.text = [NSString stringWithFormat:@"%0.2f ₹",[order.amount doubleValue]];
    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.ordersSegment.selectedSegmentIndex == 0)
        return self.savedOrdersData.count;
    
    else
        return self.orderHistoryData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 45;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = [[Utility getApplicationRootClass] managedObjectContext];
        if(self.ordersSegment.selectedSegmentIndex == 0)
        {
            SavedList *order = [self.savedOrdersData objectAtIndex:indexPath.row];
            [context deleteObject:order];
            [self.savedOrdersData removeObjectAtIndex:indexPath.row];
            
        }else
        {
            Order *order = [self.orderHistoryData objectAtIndex:indexPath.row];
            [context deleteObject:order];
            [self.orderHistoryData objectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
    
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.ordersSegment.selectedSegmentIndex == 0)
    {
        OrderDetailController *orderDetails = [[OrderDetailController alloc] initWithNibName:nil bundle:nil];
        
        SavedList *savedList = [self.savedOrdersData objectAtIndex:indexPath.row];
        NSArray *list = [savedList.listDetails allObjects];
        
        
        NSMutableArray *productList = [[NSMutableArray alloc] init];
        
        for(int i=0;i<list.count;i++)
        {
            OrderItemDetail *orderDetail = [[OrderItemDetail alloc] init];
            OrderDetail *details = [list objectAtIndex:i];
            
            orderDetail.name = details.name;
            orderDetail.id = details.id;
            orderDetail.varianceName = details.varianceName;
            orderDetail.varianceId = details.varianceId;
            orderDetail.amount= details.amount;
            orderDetail.quantitySelected =details.quantitySelected;
            
            [productList addObject:orderDetail];
            
        }
        
        orderDetails.list =productList;
        [self.navigationController pushViewController:orderDetails animated:YES];
        
    }else
    {
        Order *order = [self.orderHistoryData objectAtIndex:indexPath.row];
        [self getOrderDetails:order.id];
    }
    
}

#pragma mark - opeartions
-(void)getOrderDetails:(NSNumber *)orderId
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"getorderdetails" isPost:YES];
    
    
    NSData *data =[[orderId stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    [postRequest setHTTPBody:data];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.concurrentQueue addOperation:operation];
    
}


#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    NSError *e = nil;
    NSArray *list = [NSJSONSerialization JSONObjectWithData:operation.receivedData options: NSJSONReadingMutableContainers error: &e];
    
    NSMutableArray *productList = [[NSMutableArray alloc] init];
    
    for(int i=0;i<list.count;i++)
    {
        OrderItemDetail *orderDetail = [[OrderItemDetail alloc] init];
        NSDictionary *dict = [list objectAtIndex:i];
        
        orderDetail.name = [dict objectForKey:@"productName"];
        orderDetail.id = [dict objectForKey:@"productId"];
        orderDetail.varianceName = [dict objectForKey:@"varianceName"];
        orderDetail.varianceId = [dict objectForKey:@"varianceId"];
        orderDetail.amount= [dict objectForKey:@"price"];
        orderDetail.quantitySelected = [dict objectForKey:@"quantity"];
        
        [productList addObject:orderDetail];

    }
    
    
    OrderDetailController *orderDetails = [[OrderDetailController alloc] initWithNibName:nil bundle:nil];
    orderDetails.list = productList;
    [self.navigationController pushViewController:orderDetails animated:YES];
    
}

-(void)operationFailed:(id)operation withErrorCode:(NSUInteger)errorCode
{
    if (errorCode==UNAUTHORIZED) {
        
        [[Utility getApplicationRootClass] initiateApplication];
        
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                               message:@"Sorry for the inconvenience. Unable to retrive order details at this point of time. Please call or write to customer care for futher details." delegate:self
                                     cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)networkFailed:(id)operation withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [Utility showNetworkAlert:self withErrorCode:errorCode withMessage:msg];
}

@end
