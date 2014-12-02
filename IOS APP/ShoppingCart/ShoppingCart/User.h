//
//  User.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 02/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *email;
@property(nonatomic) NSString *phno;
@property(nonatomic) double deliveryLat;
@property(nonatomic) double deliveryLong;
@property(nonatomic,retain) NSString *deliveryAddress;

-(id)initWithName:(NSString *)name withEmail:(NSString *)email withPhno:(NSString *)phno;
@end
