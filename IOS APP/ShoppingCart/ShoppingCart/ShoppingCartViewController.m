//
//  SCartItemsController.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 15/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import  "PreviousOrdersController.h"
#import "BottomView.h"

#define totalLabelIndex 99


@interface ShoppingCartViewController ()
{
     int editIndex;
}
@end

@implementation ShoppingCartViewController

@synthesize cartProducts;
@synthesize productTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
        [self.view setBackgroundColor:[Utility getLightColor]];
        self.cartProducts =shoppingCart.productsAtClient;
        
        editIndex =-1;
        
        UIBarButtonItem *importButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(importFromOrders)];
        self.navigationItem.rightBarButtonItem = importButton;
        
        [self.view setBackgroundColor:[Utility getLightColor]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat heightToExclude = [Utility getHeightToExclude];
    CGFloat bottomViewHeight =55;
    
    self.productTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-bottomViewHeight-heightToExclude) style:UITableViewStyleGrouped];
    
    self.productTable.delegate =self;
    self.productTable.dataSource=self;
    self.productTable.allowsMultipleSelectionDuringEditing = NO;
    [self.productTable setBackgroundColor:[Utility getLightColor]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.productTable.frame.size.width, 30)];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.productTable.frame.size.width, 25)];
    name.text =@"Total";
    [view addSubview:name];
    
    ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
    UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(self.productTable.frame.size.width-110, 5,100, 25)];
    total.text =[NSString stringWithFormat:@"%0.2f ₹",[shoppingCart getCartTotal]];
    total.textAlignment =NSTextAlignmentRight;
    total.tag = totalLabelIndex;
    [view addSubview:total];
    self.productTable.tableHeaderView =view;
   [self.view addSubview:self.productTable];
    
    
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, self.productTable.frame.size.height, self.view.frame.size.width, bottomViewHeight)];
    
    [bottomView.leftButton setTitle:@"Save" forState:UIControlStateNormal];
    [bottomView.leftButton addTarget:self action:@selector(saveCart) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView.rightButton setTitle:@"Check Out" forState:UIControlStateNormal];
    [bottomView.rightButton addTarget:self action:@selector(checkOutCart) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:bottomView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.productTable reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)importFromOrders
{
    PreviousOrdersController *controller = [[PreviousOrdersController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller setCancelButton];
    navController.navigationBar.translucent = NO;
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)saveCart
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
        BOOL isSaved = [shoppingCart saveList:[alertView textFieldAtIndex:0].text];
        
        if(!isSaved)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:@"Name already exists" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            [alertView show];
        }
    }
}

-(void)checkOutCart
{
    ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
    [shoppingCart checkOutCart];

    OrdersSummaryController *controller = [[OrdersSummaryController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = [self.cartProducts objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProductTableViewCell alloc] initWithProduct:product reuseIdentifier:CellIdentifier];
        
        [cell.editButton addTarget:self action:@selector(editButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.currentProduct=product;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cartProducts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == editIndex)
        return 160;
    
    return 80;
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return YES if you want the specified item to be editable.
//    return YES;
//}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Product *product = [self.cartProducts objectAtIndex:indexPath.row];
        ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
        [shoppingCart removeProduct:product];
        
        [self.productTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void) editButtonTapped:(UIControl *)button withEvent:(UIEvent *)event
{
    NSIndexPath * indexPath = [self.productTable indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.productTable]];
    if ( indexPath == nil )
        return;
    
    [self.productTable beginUpdates];
    
    if(editIndex>-1)
    {
        ProductTableViewCell *cell =(ProductTableViewCell *)[self.productTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:editIndex inSection:0]];
        
        Product *product = [self.cartProducts objectAtIndex:indexPath.row];
        
        if(product.varianceSelected !=cell.prevVarianceIndexSelected  || product.quantitySelected != cell.prevQuantitySelected)
        {
            ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
            [shoppingCart modifyProduct:product withPrevVarianceIndex:cell.prevVarianceIndexSelected withPrevQuantity:cell.prevQuantitySelected];
        }
        
        [cell removeEditMode];
        [self updateTotalInHeader];
    }
    
    if(editIndex == indexPath.row)
    {
        editIndex=-1;
       
    }else
    {
        editIndex = (int)indexPath.row;
        ProductTableViewCell *cell =(ProductTableViewCell *)[self.productTable cellForRowAtIndexPath:indexPath];
        [cell goToEditMode];
    }
    [self.productTable endUpdates];
}

-(void)updateTotalInHeader
{
    UIView *view = [self.productTable tableHeaderView];
    ShoppingCart *shoppingCart  =[ShoppingCart getInstance];
    UILabel *totalLabel = (UILabel *)[view viewWithTag:totalLabelIndex];
    totalLabel.text =[NSString stringWithFormat:@"%0.2f ₹",[shoppingCart getCartTotal]];
    
}




@end
