//
//  DeliveryAddressTableViewController.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 22/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "DeliveryAddressTableController.h"


@interface DeliveryAddressTableController ()

@end

@implementation DeliveryAddressTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationController.navigationBar.translucent =NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAddButtonWithRestriction:(BOOL)shdRestrictAddressAroundShop
{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAddress)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.shdRestrictAddressAroundShop =shdRestrictAddressAroundShop;
}

-(void)setCancelButton
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

-(void)cancelView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addAddress
{
    AddressPickController *addressPick = [[AddressPickController alloc] initWithNibName:nil bundle:nil shoudRestrictArroundShop:self.shdRestrictAddressAroundShop];
    
    addressPick.delegate =self;
    
    [self.navigationController pushViewController:addressPick animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    NSManagedObjectContext *context = [[Utility getApplicationRootClass] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Address" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    
    self.data = [[NSMutableArray alloc] initWithArray:array];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        if(self.delegate)
        {
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        }
        
        
    }

    Address *address = [self.data objectAtIndex:indexPath.row];
    
    NSArray *split= [address.fullText componentsSeparatedByString:[Utility getSpliter]];
    
    cell.textLabel.text = split[0];
    
    if(split.count==2)
    {
        cell.detailTextLabel.text =split[1];
        cell.detailTextLabel.numberOfLines=2;
    }else
    {
        cell.detailTextLabel.text =@"";
    }
    // Configure the cell...
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Address *address =[self.data objectAtIndex:indexPath.row];
        NSManagedObjectContext *context = [[Utility getApplicationRootClass] managedObjectContext];
        [context deleteObject:address];
        [self.data removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(void)tableView:tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate)
    {
        [self.delegate selectedDeliveryAddress:[self.data objectAtIndex:indexPath.row]];
        
        if(self.navigationController.childViewControllers.count>1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else
            [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}


-(void)selectedDeliveryAddress:(NSString *)addressTxt withLatitude:(double)latitude withLongitude:(double)longitude
{
    [Utility saveDeliveryAddress:addressTxt withLatitude:latitude withLongitude:longitude];
}


@end
