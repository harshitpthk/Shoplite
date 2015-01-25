//
//  ConnectionQueues.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 27/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager

static ConnectionManager* _manager=nil;

+(ConnectionManager*)getInstance
{
    @synchronized([ConnectionManager class])
    {
        if (!_manager)
        {
            _manager = [[self alloc] init];
        
            _manager.serailQueue = [[NSOperationQueue alloc] init];
            _manager.serailQueue.maxConcurrentOperationCount =1;
        
        
            _manager.concurrentQueue = [[NSOperationQueue alloc] init];
        }
        return _manager;
    }
    
    return nil;
}

+(void)clearInstance
{
    if (_manager)
        _manager=nil;
}

-(void) prepareRequestForConnection:(NSMutableURLRequest *)request withService:(NSString *)serviceName isPost:(BOOL)isPost
{
    //NSString *url =@"https://starp1940130226trial.hanatrial.ondemand.com/central-sys/service/user/";
    //NSString *url =@"http://10.207.119.149:8080/Earth/service/";
    NSString *url =@"http://builto.elasticbeanstalk.com/service/";
    
    url =[url stringByAppendingString:serviceName];
    [request setURL:[NSURL URLWithString:url]];
    // Set the request's content type to application/x-www-form-urlencoded
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"shoplite" forHTTPHeaderField:@"Access-Control-Allow-Star"];
    
    if(isPost)
    {
        // Designate the request a POST request and specify its body data
        [request setHTTPMethod:@"POST"];
    }
}

@end
