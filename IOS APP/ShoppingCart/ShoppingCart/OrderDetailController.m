//
//  OrderDetailController.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 16/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "OrderDetailController.h"
#import "ConnectionManager.h"
#import  "BottomView.h"

@interface OrderDetailController ()

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat heightToExclude =[Utility getHeightToExclude];
    CGFloat bottomViewHeight =55;
    
    self.orderDetailsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-bottomViewHeight-heightToExclude) style:UITableViewStyleGrouped];
    
    self.orderDetailsTable.tableHeaderView =nil;
    
    self.orderDetailsTable.delegate =self;
    self.orderDetailsTable.dataSource =self;
    
    [self.orderDetailsTable setBackgroundColor:[Utility getLightColor]];
    [self.view addSubview:self.orderDetailsTable];
    
    
    self.selectedProducts = [[NSMutableArray alloc] init];
    
     
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, self.orderDetailsTable.frame.size.height, self.view.frame.size.width, bottomViewHeight)];
    
    [bottomView.leftButton setTitle:@"Import All" forState:UIControlStateNormal];
    [bottomView.leftButton addTarget:self action:@selector(importAll) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView.rightButton setTitle:@"Import Selected" forState:UIControlStateNormal];
    [bottomView.rightButton addTarget:self action:@selector(importSelected) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomView];
    
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
    }
    
    OrderItemDetail *detail= [self.list objectAtIndex:indexPath.row];
    
    cell.mainTitle.text = detail.name;
    cell.subTitle.text = detail.varianceName;
    cell.rightTitle.text = [NSString stringWithFormat:@"%@ ₹",detail.amount];
    
    if([self.selectedProducts containsObject:detail])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.selectedProducts addObject:[self.list objectAtIndex:indexPath.row]];
}

-(void)importAll
{
    [self.selectedProducts removeAllObjects];
    [self.selectedProducts addObjectsFromArray:self.list];
    
    [self getProductDetails];
}

-(void)importSelected
{
    [self getProductDetails];
}

-(void)getProductDetails
{
    self.operationCount =0;
    
    for (int i=0; i<self.selectedProducts.count; i++) {
        
        OrderItemDetail *orderItemDetail = [self.selectedProducts objectAtIndex:i];
        
        ConnectionManager *manager = [ConnectionManager getInstance];
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
        [manager prepareRequestForConnection:postRequest withService:@"getproduct" isPost:YES];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"productid" forKey:@"type"];
        [dict setObject:orderItemDetail.id forKey:@"id"];
        
        NSError *error =nil;
        NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        [postRequest setHTTPBody:jsonData];
        
        HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
        [manager.concurrentQueue addOperation:operation];
        
    }
    
    
}



#pragma mark - opeartion delegate

-(void)networkFailed:(id)operation withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [Utility showNetworkAlert:self withErrorCode:errorCode withMessage:msg];
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
-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.receivedData options: NSJSONReadingMutableContainers error: &e];
    
    if(dict!=nil)
    {
        Product *product = [[Product alloc] init];
        
        product.id = [[dict objectForKey:@"id"] integerValue];
        product.brandId = [[dict objectForKey:@"brandId"] integerValue];
        product.name = [dict objectForKey:@"name"];
        
        OrderItemDetail *itemDetail =nil;
        
        for(int i=0;self.selectedProducts.count;i++)
        {
            OrderItemDetail *orderItemDetail = [self.selectedProducts objectAtIndex:i];
            
            if([orderItemDetail.id integerValue] == product.id)
            {
                itemDetail =orderItemDetail;
                break;
            }
        }
        
        BOOL isOutOfStock =YES;
        
        NSArray *varianceList =[dict objectForKey:@"varianceList"];
        for(int i=0;i<varianceList.count;i++)
        {
            NSDictionary *dictItem = [varianceList objectAtIndex:i];
            ProductVariance *item = [[ProductVariance alloc] init];
            item.id =[[dictItem objectForKey:@"id"] integerValue];
            item.name =[dictItem objectForKey:@"name"];
            
            item.price =[[dictItem objectForKey:@"price"] doubleValue];
            item.quantity =[[dictItem objectForKey:@"quantity"] integerValue];
            
            if(!product.varianceList)
            {
                product.varianceList = [[NSMutableArray alloc] init];
            }
            
            [product.varianceList addObject:item];
            
            
            if(itemDetail && [itemDetail.varianceId integerValue]== item.id)
            {
                product.varianceSelected = i;
                
                if(item.quantity>=[itemDetail.quantitySelected integerValue])
                {
                    product.quantitySelected = [itemDetail.quantitySelected integerValue];
                    
                }else
                {
                    product.quantitySelected =item.quantity;
                }
                
                isOutOfStock =NO;
            }
    
        }
        
        if(isOutOfStock)
        {
            if(!self.outOfStockProducts)
            {
                self.outOfStockProducts = [[NSMutableArray alloc] init];
            }
            
            [self.outOfStockProducts addObject:itemDetail];
            
        }else{
            ShoppingCart *cart = [ShoppingCart getInstance];
            [cart addProduct:product];
        }
        
        
        
    }
    
    self.operationCount++;
    
    if(self.operationCount == self.selectedProducts.count)
    {
        
       if(self.outOfStockProducts.count>0)
       {
           NSMutableString *message = [[NSMutableString alloc] init];
           
           [message appendString:@"We regeret to say that following item(s) are out of stock \n"];
           
           for(int i=0;i<self.outOfStockProducts.count;i++)
           {
               OrderItemDetail *item = [self.outOfStockProducts objectAtIndex:i];
               
               NSString *str = [NSString stringWithFormat:@"%@(%@) \n", item.name,item.varianceName];
               [message appendString:str];
           }
           
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Out Of Stock"
                                                               message:message delegate:self
                                                     cancelButtonTitle:@"ok" otherButtonTitles:nil];
           [alertView show];
           
       }else
       {
           
           [self popToParentController];
           
           
       }
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self popToParentController];
}

-(void)popToParentController
{
    for(UIViewController *controller in self.navigationController.childViewControllers)
    {
        if([controller isKindOfClass:[ShoppingCartViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
    
    if(self.navigationController.childViewControllers.count>2)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
