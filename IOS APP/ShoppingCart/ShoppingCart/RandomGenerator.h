//
//  RandomGenerator.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 07/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomGenerator : NSObject
{
    long long seed;
}
-(int) nextInt:(int) n;
-(id) initWithSeed:(long) seed1;
@end
