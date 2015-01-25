//
//  HttpsOperations.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 27/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationDelegate.h"


@interface HttpsOperations:NSOperation<NSURLConnectionDelegate>

@property(nonatomic,assign) id<OperationDelegate> delegate;
@property(nonatomic,retain) NSURLRequest *request;
@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,retain) NSURLConnection *connection;
@property(nonatomic,retain) NSDictionary *headers;
@property(nonatomic) long errorCode;

-(id)initWithRequest:(NSURLRequest *)req withDelegate:(id<OperationDelegate>) delegate;

@end
