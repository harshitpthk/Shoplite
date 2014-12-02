//
//  ProductInfoView1.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 10/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "ProductInfoView.h"
#import "ConnectionManager.h"
#import "Utility.h"

@implementation ProductInfoView


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
     [super drawRect:rect];
     
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextSetStrokeColorWithColor(context, [Utility getThemeColor].CGColor);
     
     // Draw them with a 2.0 stroke width so they are a bit more visible.
     CGContextSetLineWidth(context, 1.0f);
     
     CGContextMoveToPoint(context, 0.0f, rect.size.height-40); //start at this point
     
     CGContextAddLineToPoint(context, rect.size.width, rect.size.height-40); //draw to this point
     
     CGContextMoveToPoint(context, rect.size.width/2, rect.size.height-40);
     CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height);
     
     // and now draw the Path!
     CGContextStrokePath(context);
 }
 
-(id)initWithFrame:(CGRect)frame withProduct:(Product *)product
{
    self =[super initWithFrame:frame];
    if(self)
    {
        self.product  = product;
        self.currentProduct = product;
        [self getProductDetails];
        
        self.backgroundColor = [Utility getLightColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, self.frame.size.width-100-2*10, 60)];
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, self.frame.size.width-100-2*10, 30)];
        self.error = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, self.frame.size.width-2*10, 100)];
        
        
        [self.title setFont:[Utility getFontWithSize:16.0f]];
        [self.price setFont:[Utility getFontWithSize:16.0f]];
        [self.error setFont:[Utility getFontWithSize:16.0f]];
        
        [self.title setTextAlignment:NSTextAlignmentCenter];
        [self.title setLineBreakMode:NSLineBreakByWordWrapping];
        
        [self.price setTextAlignment:NSTextAlignmentCenter];
        [self.error setTextAlignment:NSTextAlignmentCenter];
        
        [self.imageView setImage:[UIImage imageNamed:@"product.png"]];
        
        self.addProduct = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.addProduct setTitle:@"Add" forState:UIControlStateNormal];
        [self.addProduct.titleLabel setFont:[Utility getFontWithSize:16.0f]];
        [self.addProduct.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.addProduct addTarget:self action:@selector(addProductToCart) forControlEvents:UIControlEventTouchDown];
        
        [self.addProduct setFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height-40, self.frame.size.width/2, 35)];
        
        self.cancelProduct = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.cancelProduct setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelProduct.titleLabel setFont:[Utility getFontWithSize:16.0f]];
        [self.cancelProduct.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.cancelProduct addTarget:self action:@selector(removeProduct) forControlEvents:UIControlEventTouchDown];
        
        [self.cancelProduct setFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width/2, 35)];
        
        
        [self.title setTextColor:[Utility getThemeColor]];
        [self.price setTextColor:[Utility getThemeColor]];
        
    
        [self addSubview:self.imageView];
        [self addSubview:self.title];
        [self addSubview:self.price];
        [self addSubview:self.error];
        [self addSubview:self.addProduct];
        [self addSubview:self.cancelProduct];
    }
    
    return self;
}

-(void)getProductDetails
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"getproduct" isPost:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"productid" forKey:@"type"];
    [dict setObject:[NSNumber numberWithInteger:self.currentProduct.id] forKey:@"id"];
    
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    [postRequest setHTTPBody:jsonData];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.concurrentQueue addOperation:operation];
    
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
            self.currentProduct.name = [dict objectForKey:@"name"];
            self.title.text= [dict objectForKey:@"name"];
            
            
            NSArray *varianceList =[dict objectForKey:@"varianceList"];
            NSMutableArray *itemsnames = [[NSMutableArray alloc] init];
            
            for(int i=0;i<varianceList.count;i++)
            {
                NSDictionary *dictItem = [varianceList objectAtIndex:i];
                ProductVariance *item = [[ProductVariance alloc] init];
                item.id =[[dictItem objectForKey:@"id"] integerValue];
                item.name =[dictItem objectForKey:@"name"];
                
                item.price =[[dictItem objectForKey:@"price"] doubleValue];
                item.quantity =[[dictItem objectForKey:@"quantity"] integerValue];
                
                if(item.quantity>0)
                {
                    if(!self.currentProduct.varianceList)
                    {
                        self.currentProduct.varianceList = [[NSMutableArray alloc] init];
                    }
                    
                    
                    [self.currentProduct.varianceList addObject:item];
                    
                    [itemsnames addObject:item.name];
                }
                
            }
            
            
            if(self.currentProduct.varianceList.count >0)
            {
                self.variancePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20, 15, 30, 300)];
                [self.variancePicker setDelegate:self];
                [self.variancePicker setDataSource:self];
                //self.variancePicker.showsSelectionIndicator =YES;
                self.variancePicker.backgroundColor = [UIColor clearColor];
                CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
                [self.variancePicker setTransform:rotate];
                self.variancePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;;
                [self addSubview:self.variancePicker];
                
                self.currentProduct.varianceSelected = 0;
                
                ProductVariance *variance =[self.currentProduct getSelectedVarience];
                self.price.text = [NSString stringWithFormat:@"%0.2f",variance.price];
                
                self.error.hidden=YES;
                
                self.currentProduct.quantitySelected =1;
                
                self.quantityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-20,60, 25, 300)];
                [self.quantityPicker setDelegate:self];
                [self.quantityPicker setDataSource:self];
                //self.quantityPicker.showsSelectionIndicator =YES;
                self.quantityPicker.backgroundColor = [UIColor clearColor];
                rotate = CGAffineTransformMakeRotation(-3.14/2);
                [self.quantityPicker setTransform:rotate];
                [self addSubview:self.quantityPicker];
            }else
            {
                self.error.hidden=NO;
                self.error.text = @"Out of Stock";
                [self showOutOfStockError];
            }
            
            
        }
    }
}

-(void)showOutOfStockError
{
    self.error.hidden=NO;
    self.error.text = @"Out of Stock";
    [self.addProduct.titleLabel setTextColor:[Utility getNeutralColor]];
    [self.addProduct removeTarget:self action:@selector(addProductToCart) forControlEvents:UIControlEventTouchDown];
}

-(void)operationFailed:(id)operation withErrorCode:(NSUInteger)errorCode
{
    if (errorCode==UNAUTHORIZED) {
        
        [[Utility getApplicationRootClass] initiateApplication];
        
    }else if(errorCode == RESULT_NOT_FOUND)
    {
        [self showOutOfStockError];
        
    }else
    {
        [[Utility getApplicationRootClass] launchErrorScreen];
    }
}

-(void)networkFailed:(id)operation withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [Utility showNetworkAlert:self withErrorCode:errorCode withMessage:msg];
}

-(void)addProductToCart
{
    [self.delegate addProductToCart:self.currentProduct];
}

-(void) removeProduct
{
    [self.delegate cancelProduct];
}

#pragma pickerview delegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    CGRect rect=CGRectZero;
    
    if([pickerView isEqual:self.variancePicker])
    {
        rect = CGRectMake(0, 0, 80, 30);
        
    }else
    {
        rect = CGRectMake(0, 0, 60, 25);
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
    //rotate = CGAffineTransformScale(rotate, 0.25, 2.0);
    [label setTransform:rotate];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.backgroundColor = [UIColor clearColor];
    label.clipsToBounds = YES;
    [label setFont:[Utility getFontWithSize:14.0f]];
    
    if([pickerView isEqual:self.variancePicker])
    {
        label.text = [[self.currentProduct.varianceList objectAtIndex:row] name];
        
    }else
    {
        label.text = [NSString stringWithFormat:@"Qty : %d",(int)row+1];
    }
    
    [label setTextColor:[Utility getDarkColor]];
    
    return label ;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual:self.variancePicker])
    {
        return self.currentProduct.varianceList.count;
        
    }else{
        ProductVariance *variance =  [self.currentProduct getSelectedVarience];
        return variance.quantity+30;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if([pickerView isEqual:self.variancePicker])
    {
        return 80;
    }else{
        return 60;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:self.variancePicker])
    {
        self.currentProduct.varianceSelected = (int)row;
        ProductVariance *variance =  [self.currentProduct.varianceList objectAtIndex:row];
        self.price.text = [NSString stringWithFormat:@"%0.2f",variance.price];
        
        self.quantityPicker.hidden=NO;
        [self.quantityPicker reloadAllComponents];
        [self.quantityPicker selectRow:0 inComponent:0 animated:YES];
        
    }else
    {
         ProductVariance *variance =  [self.currentProduct getSelectedVarience];
        self.currentProduct.quantitySelected =row+1;
         self.price.text = [NSString stringWithFormat:@"%0.2f",(variance.price)*(row+1)];
    }
}

@end
