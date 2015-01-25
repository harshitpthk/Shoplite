//
//  ProductInfoView.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 08/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "ProductInfoViewBackUp.h"
#import "ConnectionManager.h"


@implementation ProductInfoViewBackUp

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame withProduct:(Product *)product
{
    self =[super initWithFrame:frame];
    if(self)
    {
        self.product  = product;
        self.currentProduct = product;
        [self getProductDetails];
        
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 60)];
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 100, 30)];
        
        
        
        self.title.text= @"232142";
        
        [self.imageView setImage:[UIImage imageNamed:@"product.jpg"]];
        
        [self addSubview:self.imageView];
        [self addSubview:self.title];
        [self addSubview:self.price];
        
    }
    
    return self;
}

-(void)getProductDetails
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForShopConnection:postRequest withService:@"getitem" isPost:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"itemcategoryid" forKey:@"type"];
    [dict setObject:[NSNumber numberWithInt:self.currentProduct.id] forKey:@"id"];
    
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    [postRequest setHTTPBody:jsonData];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
    getProductDetails = operation;
}


#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    if([operation isEqual:getProductDetails])
    {
        NSError *e = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.receivedData options: NSJSONReadingMutableContainers error: &e];
        
        if(dict!=nil)
        {
            self.currentProduct.brandId = [[dict objectForKey:@"brandId"] integerValue];
            NSArray *itemList =[dict objectForKey:@"itemList"];
            
            NSMutableArray *itemsnames = [[NSMutableArray alloc] init];
            
            for(int i=0;i<itemList.count;i++)
            {
                NSDictionary *dictItem = [itemList objectAtIndex:i];
                ProductVarience *item = [[ProductVarience alloc] init];
                item.id =[[dictItem objectForKey:@"id"] integerValue];
                item.name =[dictItem objectForKey:@"name"];
                
                item.price =[[dictItem objectForKey:@"price"] doubleValue];
                item.quantity =[[dictItem objectForKey:@"quantity"] integerValue];
                
                if(!self.currentProduct.varienceList)
                {
                    self.currentProduct.varienceList = [[NSMutableArray alloc] init];
                }
                
                [self.currentProduct.varienceList addObject:item];
                
                [itemsnames addObject:item.name];
                
            }
            
            
            if(self.currentProduct.varienceList.count >0)
            {
                self.varienceControl = [[UISegmentedControl alloc] initWithItems:itemsnames];
                [self.varienceControl setSelectedSegmentIndex:0];
                [self.varienceControl setFrame:CGRectMake(10, 110, 180, 30)];
                [self addSubview:self.varienceControl];
                [self.varienceControl addTarget:self action:@selector(varienceChanged:) forControlEvents:UIControlEventValueChanged];
                
                self.currentVarience = [self.currentProduct.varienceList objectAtIndex:0];
                self.price.text = [NSString stringWithFormat:@"%2f",self.currentVarience.price];
                
                if(self.currentVarience.quantity>0)
                {
                    self.quantity = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 70, 40)];
                    self.quantity.text = @"Qty : 1";
                    [self addSubview:self.quantity];
                    
                    self.quantityStepper = [[UIStepper alloc] initWithFrame:CGRectMake(70,150, 80, 30)];
                    self.quantityStepper.minimumValue=1;
                    self.quantityStepper.stepValue=1;
                    self.quantityStepper.maximumValue =self.currentVarience.quantity;
                    [self addSubview:self.quantityStepper];
                    
                    [self.quantityStepper addTarget:self action:@selector(quantityChanged:) forControlEvents:UIControlEventValueChanged];
                    
                }else
                {
                    self.quantity = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 150, 40)];
                    self.quantity.text = @"Qty : Out of Stock";
                    [self addSubview:self.quantity];
                }
            }
            
            
        }
    }
}

-(void)quantityChanged:(UIStepper *)sender
{
    int value = [sender value];
    self.quantity.text = [NSString stringWithFormat:@"Qty : %d",value];
    
    self.price.text = [NSString stringWithFormat:@"%2f",(self.currentVarience.price*value)];
    
}

-(void)varienceChanged:(UIStepper *)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    self.currentVarience =  [self.currentProduct.varienceList objectAtIndex:selectedSegment];
    self.price.text = [NSString stringWithFormat:@"%2f",self.currentVarience.price];
    
    if(self.currentVarience.quantity>0)
    {
        self.quantityStepper.hidden=NO;
        self.quantityStepper.maximumValue = self.currentVarience.quantity;
        self.quantityStepper.value =1;
        
    }else
    {
        self.quantity.text = @"Qty : Out of Stock";
        self.quantityStepper.hidden=YES;
    }
}

@end
