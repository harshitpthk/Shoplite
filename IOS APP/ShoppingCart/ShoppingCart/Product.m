//
//  Product.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 08/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "Product.h"

@implementation Product

-(ProductVariance *)getSelectedVarience
{
    if(self.varianceSelected > self.varianceList.count-1)
        self.varianceSelected =0;
    
    return [self.varianceList  objectAtIndex:self.varianceSelected];
}

- (BOOL)isProductEqual:(Product *)product
{
    if(self.id!=product.id)
        return false;

    if(self.varianceSelected != product.varianceSelected)
        return false;
    
    return true;
}

// returns true when it finds similar product other than self in a guven array(simillar means products with same product id and varianceid)
-(BOOL)isSimilarProductFoundInArray:(NSArray *)array
{
    for(int i = 0;i<array.count;i++)
    {
        if([self isProductEqual:[array objectAtIndex:i]] && ![self isEqual:[array objectAtIndex:i]])
            return true;
    }
    
    return false;
}

-(Product *)getSimilarProductInArray:(NSArray *)array
{
    for(int i = 0;i<array.count;i++)
    {
        if([self isProductEqual:[array objectAtIndex:i]])
            return [array objectAtIndex:i];
    }
    
    return nil;
}
@end
