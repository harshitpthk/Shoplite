//
//  User.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 02/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithName:(NSString *)name withEmail:(NSString *)email withPhno:(NSString *)phno
{
    if(self==[super init])
    {
        self.name = name;
        self.email =email;
        self.phno =phno;
    }
    
    return self;
}
@end
