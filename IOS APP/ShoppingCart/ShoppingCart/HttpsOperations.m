//
//  HttpsOperations.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 27/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "HttpsOperations.h"
#import "Enumerations.h"

@implementation HttpsOperations
@synthesize request;

-(id)initWithRequest:(NSURLRequest *)req withDelegate:(id<OperationDelegate>) delegate
{
    if (self = [super init]) {
        
        self.request =req;
        self.delegate =delegate;
    }
    
    return self;
}

- (void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        self.receivedData = [[NSMutableData alloc] init];
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [self.connection start];
        
        if (!self.connection) {
            // Release the receivedData object.
            self.receivedData = nil;
            
            // Inform the user that the connection failed.
        }
        
        if (self.isCancelled) {
            [self.connection cancel];
            self.receivedData = nil;
            return;
        }
    
        
    }
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
    self.headers =headers;
    [self.receivedData setLength:0];
    
    self.errorCode = [(NSHTTPURLResponse *)response statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData appendData:data];
    
    if (self.isCancelled) {
        [self.connection cancel];
        self.receivedData = nil;
        return;
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    self.connection = nil;
    self.receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@ %ld",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey], (long)error.code);
    
    [self.delegate networkFailed:self withErrorCode:error.code withMessage:[error localizedDescription]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.receivedData length]);
    NSString* newStr = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"recieved data %@" ,newStr);
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    
    if (self.isCancelled) {
        self.connection = nil;
        self.receivedData = nil;
        return;
    }
    
    if(self.errorCode!=200 && self.errorCode !=201)
    {
    
        [self.delegate operationFailed:self withErrorCode:[Utility getClientErrorCodeFromServerCode:self.errorCode]];
        
    }else
    {
        [self.delegate operationFinishedWithdata:self];
    }
//    [(NSObject *)self.delegate performSelectorOnMainThread:@selector(operationFinishedWithdata:) withObject:self waitUntilDone:NO];
//    
   
}


@end
