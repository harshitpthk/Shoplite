//
//  RandomGenerator.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 07/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "RandomGenerator.h"
static long long  multiplier = 0x5DEECE66DL;
static long long addend = 0xBL;
static long long mask = (1L << 48) - 1;


@implementation RandomGenerator

-(id) initWithSeed:(long) seed1 {
    self = [super init];
    
    seed = (seed1 ^ multiplier) & mask;
    return self;
}

-(int) next:(int)bits {
    long long oldseed, nextseed;
    long long seed1 = seed; //AtomicLong
    //do {
    oldseed = seed1;
    nextseed = (oldseed * multiplier + addend) & mask;
    
    seed =nextseed;
    ///int ret = (int)(nextseed >>> (48 - bits));
    int ret = (unsigned int)(nextseed >> (48 - bits));
    return ret;
}


-(int) nextInt:(int) n {
    if (n <= 0)
        return 0;
    
    if ((n & -n) == n)  // i.e., n is a power of 2
        return (int)((n * (long)[self next:31]) >> 31);
    
    int bits, val;
    do {
        bits = [self next:31];
        val = bits % n;
    } while (bits - val + (n-1) < 0);
    return val;
}

@end
