//
//  ProfileController.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 15/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "ProfileController.h"
#import "ConnectionManager.h"
#import "PreviousOrdersController.h"
#import "DeliveryAddressTableController.h"

@interface ProfileController ()

@end

@implementation ProfileController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.title = @"Profile";
        [self.view setBackgroundColor:[Utility getLightColor]];
        self.tabBarItem.image = [UIImage imageNamed:@"photo-7.png"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 81)];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 15)];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 15)];
    
    [nameLabel setText:manager.user.name];
    [emailLabel setText:manager.user.email];
    [phoneLabel setText:manager.user.phno];
    
    [nameLabel setFont:[Utility getFontWithSize:24]];
    [emailLabel setFont:[Utility getFontWithSize:14]];
    [phoneLabel setFont:[Utility getFontWithSize:14]];
    
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [emailLabel setTextAlignment:NSTextAlignmentCenter];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    
    [view addSubview:nameLabel];
    [view addSubview:emailLabel];
    [view addSubview:phoneLabel];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(10,view.frame.size.height-1, view.frame.size.width-20, 1)];
    [divider setBackgroundColor:[Utility getThemeColor]];
    divider.layer.opacity =0.3;
    [view addSubview:divider];
    
    [self.view addSubview:view];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 81, self.view.frame.size.width, self.view.frame.size.height-81-[Utility getHeightToExclude]) style:UITableViewStyleGrouped];
    
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    
    [self.view addSubview:self.tableView];
    
    [self.view setBackgroundColor:[Utility getLightColor]];
    //[self.tableView setBackgroundColor:[Utility getLightColor]];
   
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
    
    self.pendingOrdersData = [[NSMutableArray alloc] init];
    
    for (int i=0; i<array.count; i++) {
        Order *order = [array objectAtIndex:i];
        
        if(![order.status isEqualToString:@"DELIVERED"])
        {
            [self.pendingOrdersData addObject:order];
            [self getOrderStatus:order.id];
        }
    }
    
   [self.tableView reloadData];
    
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

-(void)settings
{
    
}


#pragma UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"OrderCell";
        
        OrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            NSArray *array = [[NSArray alloc] initWithObjects:@"Packing",@"Packed",@"In Transit",@"Delivered", nil];
            cell = [[OrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withStatusArray:array];
            
        }
        
        cell.accessoryView = nil;
        Order *order = [self.pendingOrdersData objectAtIndex:indexPath.row];
        cell.mainTitle.text = [NSString stringWithFormat:@"%@", order.id];
        cell.rightTitle.text = [NSString stringWithFormat:@"%0.2f ₹",[order.amount doubleValue]];
        
        [cell highlightStatus:order.status];
        return cell;
        
    }else
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if(indexPath.section==1)
        {
            if(indexPath.row==0)
            {
                cell.textLabel.text =@"Orders";
                
            }else if(indexPath.row==1){
                
                cell.textLabel.text =@"Address";
                
            }else
            {
                cell.textLabel.text =@"Cards";
            }
        
        }else if(indexPath.section==2)
        {
            if(indexPath.row==1)
            {
                cell.textLabel.text =@"License";
                
            }else
            {
                cell.textLabel.text =@"About";
            }
        }
        
        return cell;
        
        
        
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0)
        return self.pendingOrdersData.count;
    
    else if(section ==1)
        return 3;
    else
        return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0)
        return 90;
    
    else
        return 45;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        if(indexPath.row==0 )
        {
            PreviousOrdersController *orders = [[PreviousOrdersController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:orders animated:YES];
            return;
            
        }else if(indexPath.row==1)
        {
            DeliveryAddressTableController *controller = [[DeliveryAddressTableController alloc] initWithNibName:nil bundle:nil];
            [controller setAddButtonWithRestriction:NO];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
    
}


#pragma operation delegate

-(void)getOrderStatus:(NSNumber *) orderId
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"getorderstate" isPost:YES];
    
    
    NSData *data =[[orderId stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    [postRequest setHTTPBody:data];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.concurrentQueue addOperation:operation];
    
    if(!self.statusOperationsDict)
    {
        self.statusOperationsDict =[[NSMutableDictionary alloc] init];
    }
    
    NSValue *key = [NSValue valueWithNonretainedObject:operation];
    [self.statusOperationsDict setObject:orderId forKey:key];
    
}

#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    NSValue *key = [NSValue valueWithNonretainedObject:operation];
    NSNumber *orderId = [self.statusOperationsDict objectForKey:key];
    NSString *newStr = [[NSString alloc] initWithData:operation.receivedData encoding:NSUTF8StringEncoding];
   
    NSString *state = [newStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    for (int i=0; i<self.pendingOrdersData.count; i++) {
        
        Order *order =[self.pendingOrdersData objectAtIndex:i];
        if([orderId isEqualToNumber:order.id])
        {
            order.status = state;
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(void)operationFailed:(id)operation withErrorCode:(NSUInteger)errorCode
{
    if (errorCode==UNAUTHORIZED) {
        
        [[Utility getApplicationRootClass] initiateApplication];
        
    }
    
}

-(void)networkFailed:(id)operation withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [Utility showNetworkAlert:self withErrorCode:errorCode withMessage:msg];
}


@end
