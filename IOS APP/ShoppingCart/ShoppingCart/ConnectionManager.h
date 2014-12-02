//
//  ConnectionQueues.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 27/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shop.h"
#import "User.h"

@interface ConnectionManager : NSObject

@property (nonatomic,retain) ConnectionManager *manager;
@property (nonatomic,retain) NSOperationQueue *serailQueue;
@property (nonatomic,retain) NSOperationQueue *concurrentQueue;
@property (nonatomic,retain) Shop *currentShop;
@property (nonatomic,retain) NSString *currentShopToken;
@property (nonatomic,retain) NSString *currentStarToken;
@property (nonatomic,retain) User *user;

+(ConnectionManager*)getInstance;
+(void)clearInstance;

-(void) prepareRequestForConnection:(NSMutableURLRequest *)request withService:(NSString *)serviceName isPost:(BOOL)isPost;


@end
