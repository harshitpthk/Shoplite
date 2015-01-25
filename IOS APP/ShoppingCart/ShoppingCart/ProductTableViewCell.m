//
//  ProductTableViewCell.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 14/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "ProductTableViewCell.h"

@implementation ProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithProduct:(Product *)product reuseIdentifier:CellIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (self) {
        // Initialization code
       
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        self.productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2.5, 75, 75)];
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, self.frame.size.width-75-2*5, 30)];
        self.vareinceTitle = [[UILabel alloc] initWithFrame:CGRectMake(85, 32, (self.frame.size.width-85)/2, 20)];
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editButton setFrame:CGRectMake(self.frame.size.width-40, 20, 35, 20)];
        
        int part = (self.frame.size.width-85)/3;
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(85, 55, part-10, 25)];
        
        UILabel *labelStar = [[UILabel alloc] initWithFrame:CGRectMake(85+part-10, 55, 5, 25)];
        self.quantity = [[UILabel alloc] initWithFrame:CGRectMake(85+part-5, 55, part-10, 25)];
        
        UILabel *labelEqual = [[UILabel alloc] initWithFrame:CGRectMake(85+2*part-15, 55, 5, 25)];
        self.total = [[UILabel alloc] initWithFrame:CGRectMake(85+2*part-10, 55, part, 25)];
       
        
        [self.title setFont:[Utility getFontWithSize:16.0f]];
        [self.price setFont:[Utility getFontWithSize:14.0f]];
        [self.quantity setFont:[Utility getFontWithSize:14.0f]];
        [self.vareinceTitle setFont:[Utility getFontWithSize:14.0f]];
        [self.total setFont:[Utility getFontWithSize:14.0f]];
        
        [labelStar setFont:[Utility getFontWithSize:12.0f]];
        [labelEqual setFont:[Utility getFontWithSize:12.0f]];
        
        [self.editButton.titleLabel setFont:[Utility getFontWithSize:14.0f]];
        
        [self.title setTextAlignment:NSTextAlignmentLeft];
        [self.vareinceTitle setTextAlignment:NSTextAlignmentLeft];
        [self.price setTextAlignment:NSTextAlignmentLeft];
        [self.quantity setTextAlignment:NSTextAlignmentCenter];
        [self.total setTextAlignment:NSTextAlignmentRight];
        
        self.productImageView.image = [UIImage imageNamed:@"product.png"];
        self.title.text = product.name;
        
        ProductVariance *variance =  [product getSelectedVarience];
        
        self.vareinceTitle.text = variance.name;
        self.quantity.text = [NSString stringWithFormat:@"%d Units",(int)product.quantitySelected];
        self.price.text = [NSString stringWithFormat:@"%0.2f ₹",variance.price];
        self.total.text = [NSString stringWithFormat:@"%0.2f ₹",(variance.price * (int)product.quantitySelected)];
    
        labelStar.text=@"*";
        labelEqual.text=@"=";
        
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        
        [self addSubview:self.productImageView];
        [self addSubview:self.title];
        [self addSubview:self.vareinceTitle];
        [self addSubview:self.quantity];
        [self addSubview:self.price];
        [self addSubview:self.total];
        
        [self addSubview:labelStar];
        [self addSubview:labelEqual];
        
        [self addSubview:self.editButton];
        
        self.currentProduct =product;
        
    }
    return self;
}

-(void)setCurrentProduct:(Product *)product
{
    if(_currentProduct)
    {
        _currentProduct=nil;
    }
    
    if(product)
    {
        self.productImageView.image = [UIImage imageNamed:@"product.png"];
        self.title.text = product.name;
        
        ProductVariance *variance =  [product getSelectedVarience];
        
        self.vareinceTitle.text = variance.name;
        self.quantity.text = [NSString stringWithFormat:@"%d Units",(int)product.quantitySelected];
        self.price.text = [NSString stringWithFormat:@"%0.2f ₹",variance.price];
        self.total.text = [NSString stringWithFormat:@"%0.2f ₹",(variance.price * (int)product.quantitySelected)];
        
        _currentProduct = product;
    }
    
    
    
    
}

-(void)goToEditMode
{
    self.prevVarianceIndexSelected = [self.currentProduct varianceSelected];
    self.prevQuantitySelected = [self.currentProduct quantitySelected];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 15, self.frame.size.width, 80)];
    
    self.variancePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(view.frame.size.width/2-20, -85 , 25, 300)];
    [self.variancePicker setDelegate:self];
    [self.variancePicker setDataSource:self];
    self.variancePicker.showsSelectionIndicator =YES;
    self.variancePicker.backgroundColor = [UIColor clearColor];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    [self.variancePicker setTransform:rotate];
    self.variancePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;;
    [view addSubview:self.variancePicker];
    
    
    self.quantityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(view.frame.size.width/2-20,-45, 25, 300)];
    [self.quantityPicker setDelegate:self];
    [self.quantityPicker setDataSource:self];
    self.quantityPicker.showsSelectionIndicator =YES;
    self.quantityPicker.backgroundColor = [UIColor clearColor];
    [self.quantityPicker setTransform:rotate];
    [view addSubview:self.quantityPicker];
    
    [self.variancePicker selectRow:self.currentProduct.varianceSelected inComponent:0 animated:NO];
    [self.quantityPicker selectRow:self.currentProduct.quantitySelected-1 inComponent:0 animated:NO];
    
    [self addSubview:view];
    view.layer.opacity =0.2;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [view setFrame:CGRectMake(0, 80, self.frame.size.width, 80)];
    view.layer.opacity =1.0;
    [UIView commitAnimations];
    
    self.editView = view;
    
    [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
}

-(void)removeEditMode
{
    self.prevVarianceIndexSelected=-1;
    self.prevQuantitySelected=-1;
    
    if(self.editView)
    {
        [UIView animateWithDuration:0.2f
                              delay: 0.0f
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.editView.transform =CGAffineTransformMakeTranslation(0, -65);
                             self.editView.layer.opacity =0.1;
                         }
                         completion:^(BOOL finished){
                             self.variancePicker =nil;
                             self.quantityPicker=nil;
                             [self.editView removeFromSuperview];
                             self.editView =nil;
                             
                             [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
                         }
         ];
        
        
    }
}

#pragma pickerview delegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    CGRect rect=CGRectZero;
    
    if([pickerView isEqual:self.variancePicker])
    {
        rect = CGRectMake(0, 0, 90, 25);
        
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
        return 90;
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
        self.price.text = [NSString stringWithFormat:@"%0.2f ₹",variance.price];
        self.vareinceTitle.text = variance.name;
        
        if(variance.quantity>0)
        {
            self.quantityPicker.hidden=NO;
            [self.quantityPicker reloadAllComponents];
            [self.quantityPicker selectRow:0 inComponent:0 animated:YES];
            self.currentProduct.quantitySelected=1;
            
        }else
        {
            self.currentProduct.quantitySelected=0;
            self.quantityPicker.hidden=YES;
        }
        
    }else
    {
        self.currentProduct.quantitySelected =row+1;
    }
    
    self.quantity.text = [NSString stringWithFormat:@"%d Units",(int)self.currentProduct.quantitySelected];
    ProductVariance *variance =  [self.currentProduct getSelectedVarience];
    self.total.text = [NSString stringWithFormat:@"%0.2f ₹",(variance.price)*(self.currentProduct.quantitySelected)];
}

@end
