//
//  ShoppingCart.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 14/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "ShoppingCart.h"
static ShoppingCart* _manager=nil;

@interface ShoppingCart()
@property (nonatomic, retain) NSMutableArray *currentActionSetArray;
@end

@implementation ShoppingCart

+(ShoppingCart*)getInstance
{
    @synchronized([ShoppingCart class])
    {
        if (!_manager)
        {
            _manager = [[self alloc] init];
            
            _manager.productsAtClient =[[NSMutableArray alloc] init];
            _manager.productsAtServer =[[NSMutableArray alloc] init];
            _manager.currentActionSetArray =[[NSMutableArray alloc] init];
        }
        return _manager;
    }
    
    return nil;
}

+(void)clearInstance
{
    if (_manager)
        _manager=nil;
}

-(void)addProduct:(Product *)product
{
    if([product isSimilarProductFoundInArray:self.productsAtClient])
    {
        NSLog(@"contains product");
        return;
    }
    
    [self.productsAtClient addObject:product];
    
    if(!self.currentPendingInsertSet)
    {
        self.currentPendingInsertSet =[[NSMutableArray alloc] init];
    }
    
    [self.currentPendingInsertSet  addObject:product];
    
    if(self.currentPendingInsertSet.count ==3)
    {
        ProductActionSet *action =[[ProductActionSet alloc] initWithProductSet:self.currentPendingInsertSet withAction:@"INSERT" withDelegate:self];
        
        [action performAction];
        [self.currentActionSetArray addObject:action];
        self.currentPendingInsertSet=nil;
        
    }
}

-(void)removeProduct:(Product *)product
{
    [self.productsAtClient removeObject:product];
    
    if(self.currentPendingInsertSet && [self.currentPendingInsertSet containsObject:product])
    {
        [self.currentPendingInsertSet  removeObject:product];
        
    }else
    {
        ProductActionSet *action =[[ProductActionSet alloc] initWithProductSet:[NSArray arrayWithObject:product]withAction:@"DELETE" withDelegate:self];
        
        [action performAction];
        [self.currentActionSetArray addObject:action];
    }
}

-(void)modifyProduct:(Product *)product withPrevVarianceIndex:(int)prevVarianceIndex withPrevQuantity:(int)quantity
{
    
    //After modification if the product with selected varience already exists then we shouldn't allow it
    if(product.varianceSelected != prevVarianceIndex && [product isSimilarProductFoundInArray:self.productsAtClient])
    {
        product.varianceSelected = prevVarianceIndex;
        product.quantitySelected =quantity;
        NSLog(@"contains product");
        return;
    }

    
    if(self.currentPendingInsertSet && [self.currentPendingInsertSet containsObject:product])
    {
        /*no need to do anything since these currentPendingInsertSet and productsAtClient at clients are pointing to same object. Object will be already modified*/
        return;
        
    }else{
        
        int currentVarience = product.varianceSelected;
        
        product.varianceSelected = prevVarianceIndex;
        
        ProductActionSet *action =[[ProductActionSet alloc] initWithProductSet:[NSArray arrayWithObject:product]withAction:@"DELETE" withDelegate:self];
        
        [action performAction];
        [self.currentActionSetArray addObject:action];
        
        
        product.varianceSelected = currentVarience;
        
        ProductActionSet *actionInsert =[[ProductActionSet alloc] initWithProductSet:[NSArray arrayWithObject:product]withAction:@"INSERT" withDelegate:self];
        
        [actionInsert performAction];
        [self.currentActionSetArray addObject:actionInsert];
    }
}

-(void)checkOutCart
{
    if(self.currentPendingInsertSet.count > 0)
    {
        ProductActionSet *action =[[ProductActionSet alloc] initWithProductSet:self.currentPendingInsertSet withAction:@"INSERT" withDelegate:self];
        
        [action performAction];
        [self.currentActionSetArray addObject:action];
        self.currentPendingInsertSet=nil;
    
    }
}

-(BOOL)saveList:(NSString *)name
{
    NSManagedObjectContext *context = [[Utility getApplicationRootClass] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name==[c]%@",name];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"SavedList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
    
    if(!count)
    {
        SavedList *list = [NSEntityDescription insertNewObjectForEntityForName:@"SavedList"
                                      inManagedObjectContext:context];
        
        list.name =name;
        list.noOfItems = [NSNumber numberWithInt:[self.productsAtClient count]];
        list.date = [NSDate date];
        
        for (int i=0; i<self.productsAtClient.count; i++) {
            Product *product = [self.productsAtClient objectAtIndex:i];
            ProductVariance *variance = [product getSelectedVarience];
            
            OrderDetail *orderDetail = [NSEntityDescription insertNewObjectForEntityForName:@"OrderDetail"
                                                            inManagedObjectContext:context];
            orderDetail.name = product.name;
            orderDetail.id = [NSNumber numberWithUnsignedInteger:product.id];
            orderDetail.varianceName = variance.name;
            orderDetail.varianceId =[NSNumber numberWithUnsignedInteger:variance.id];
            orderDetail.amount = [NSNumber numberWithDouble:variance.price];
            orderDetail.quantitySelected = [NSNumber numberWithUnsignedInteger:product.quantitySelected];
            
            [list addListDetailsObject:orderDetail];
        }
        
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return false;
        }
        
        return true;
    }
    
    return false;
    
}

-(BOOL)saveOrderWithId:(NSInteger )orderId withStatus:(NSString *)status
{
    NSManagedObjectContext *context = [[Utility getApplicationRootClass] managedObjectContext];
    Order *order = [NSEntityDescription insertNewObjectForEntityForName:@"Order"
                                                    inManagedObjectContext:context];
    order.id = [[NSNumber alloc] initWithUnsignedInt:orderId];
    order.date = [NSDate date];
    order.noOfItems = [NSNumber numberWithInt:[self.productsAtClient count]];
    order.status = status;
    order.amount = [NSNumber numberWithDouble:[self getCartTotal]];
    NSError *error;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return true;

}

-(BOOL)isCartProcessingAnyActions
{
    return self.currentActionSetArray.count;
}

-(double) getCartTotal
{
    double total =0;
    
    for(int i=0;i<self.productsAtClient.count;i++)
    {
        Product *product =[self.productsAtClient objectAtIndex:i];
        ProductVariance *variance =  [product getSelectedVarience];
        total = total + (variance.price * (int)product.quantitySelected);
    }
    
    return total;
}

- (void)registerForChangeNotification:(id)object withKeyPath:(NSString *)keyPath {
    
    [self.currentActionSetArray addObserver:object forKeyPath:keyPath options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
}

- (void)unregisterForChangeNotification:(id)object withKeyPath:(NSString *)keyPath {
    
    [self.currentActionSetArray removeObserver:object forKeyPath:keyPath];
}

#pragma mark - action set delegate

-(void)actionComplete:(ProductActionSet *)actionSet
{
    if([@"INSERT" isEqualToString:actionSet.action])
    {
        [self.productsAtServer addObjectsFromArray:actionSet.products];
        [self.currentActionSetArray removeObject:actionSet];
        
    }else if([@"DELETE" isEqualToString:actionSet.action])
    {
        [self.productsAtServer removeObjectsInArray:actionSet.products];
        [self.currentActionSetArray removeObject:actionSet];
    }
}
-(void)actionFailed:(id)operation withErrorCode:(NSUInteger)errorCode
{
    if (errorCode==UNAUTHORIZED) {
        
        [[Utility getApplicationRootClass] initiateApplication];
        
    }else
    {
        [[Utility getApplicationRootClass] launchErrorScreen];
    }
}

-(void)networkFailed:(id)operation withActionSet:(id)actionSet  withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [self.currentActionSetArray insertObject:actionSet atIndex:0];
    [Utility showNetworkAlert:self withErrorCode:errorCode withMessage:msg];
}
@end
