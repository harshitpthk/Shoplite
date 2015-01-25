//
//  SCartUtility.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 09/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "RandomGenerator.h"
#import "KeychainWrapper.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation Utility

+ (SCartAppDelegate *) getApplicationRootClass
{
        return (SCartAppDelegate *)[UIApplication sharedApplication].delegate;
}

+(NSString *)getSecurityKeyName
{
    return @"thrhIRI8N0A6H*PA";
}

+(NSString *)getGoogleAPIKey
{
    return @"AIzaSyDkyLGGNUS83UIN0ZShFO13EFhrvSva_mg";
}

+(NSString *)getGooglePlacesAPIKey
{
    return @"AIzaSyAfPOIcSyMoYPCcvDkwxZe2F6q5xSzALOE";
}

+(NSString *)getSpliter
{
    return @";*";
}

+ (NSString *) encrypt:(NSString *) dataToEncrypt withKey:(NSString*) key{
    
    
    NSData *data = [dataToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *mData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus ccStatus = kCCSuccess;
    
    
    // Begin to calculate bytesNeeded....
    
    size_t bytesNeeded = 0;
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmAES,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       [mData bytes],
                       [mData length],
                       nil,
                       [data bytes],
                       [data length],
                       NULL,
                       0,
                       &bytesNeeded);
    
    if(kCCBufferTooSmall != ccStatus){
        
        NSLog(@"Buffer too small");
        return nil;
    }
    
    // .....End
    // Now i do the real Crypting
    
    char* cypherBytes = malloc(bytesNeeded);
    size_t bufferLength = bytesNeeded;
    
    if(NULL == cypherBytes)
        NSLog(@"cypherBytes NULL");
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmAES,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       [mData bytes],
                       [mData length],
                       nil,
                       [data bytes],
                       [data length],
                       cypherBytes,
                       bufferLength,
                       &bytesNeeded);
    
    if(kCCSuccess != ccStatus){
        NSLog(@"kCCSuccess NO!");
        return nil;
    }
    
    return [NSString base64StringFromData:[NSData dataWithBytes:cypherBytes length:bufferLength] length:bufferLength];
    //return [Base64 encode:[NSData dataWithBytes:cypherBytes length:bufferLength]];
}

+ (NSString *) decrypt:(NSString *) dataToDecrypt withKey:(NSString*) key{
    
     NSData *data = [NSData base64DataFromString:dataToDecrypt];
     NSData *mData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus ccStatus = kCCSuccess;
    
    
    // Begin to calculate bytesNeeded....
    
    size_t bytesNeeded = 0;
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmAES,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       [mData bytes],
                       [mData length],
                       nil,
                       [data bytes],
                       [data length],
                       NULL,
                       0,
                       &bytesNeeded);
    
    if(kCCBufferTooSmall != ccStatus){
        
        NSLog(@"Buffer too small");
        return nil;
    }
    
    // .....End
    // Now i do the real Crypting
    
    char* cypherBytes = malloc(bytesNeeded);
    size_t bufferLength = bytesNeeded;
    
    if(NULL == cypherBytes)
        NSLog(@"cypherBytes NULL");
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmAES,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       [mData bytes],
                       [mData length],
                       nil,
                       [data bytes],
                       [data length],
                       cypherBytes,
                       bufferLength,
                       &bytesNeeded);
    
    if(kCCSuccess != ccStatus){
        NSLog(@"kCCSuccess NO!");
        return nil;
    }
    
    return [[NSString alloc] initWithData:[NSData dataWithBytes:cypherBytes length:bytesNeeded] encoding:NSUTF8StringEncoding];

}

+(NSString *)getUniqueSession
{
    NSTimeInterval time =[[NSDate date] timeIntervalSince1970];
    int factor = (int)time/63000;
    
    NSString *seed = [Utility genarateSeedWithKey:factor withLength:8];
    
    KeychainWrapper *keyChain = [[KeychainWrapper alloc] init];
    NSString *client = [keyChain myObjectForKey:(__bridge id)kSecValueData];

    NSString *str = [NSString stringWithFormat:@"%@%@",client,seed];
    
    str = [Utility encrypt:str withKey:[Utility getSecurityKeyName]];
    
    return str;
}

+(NSString *)genarateSeedWithKey:(long)key withLength:(int)length
{
    RandomGenerator *random = [[RandomGenerator alloc] initWithSeed:key];
    
    NSMutableString *str =[[NSMutableString alloc] init];
    for(int i=0; i<length; ++i) {
        
        int len =[random nextInt:26];
        char c= (char) (65 + len);
        [str appendFormat:@"%c",c];
    }
    return str;
}

//error handling
+(NSUInteger)getClientErrorCodeFromServerCode:(NSUInteger )serverErrorCode
{
    NSUInteger errorCode=0;
    
    switch (serverErrorCode) {
        case 500:
            errorCode = INTERNAL_SERVER_ERROR;
            break;
            
        case 401:
            errorCode = UNAUTHORIZED;
            break;
            
        case 403:
            errorCode = REQUEST_FORBIDDEN;
            break;
            
        case 404:
            errorCode = REQUEST_NOTFOUND;
            break;
            
        case 204:
            errorCode = RESULT_NOT_FOUND;
            break;
            
        case 412:
            errorCode = PRECONDITION_FAILED;
            break;
            
        default:
            errorCode = INTERNAL_SERVER_ERROR;
            break;
    }
    
    return errorCode;
    
}

+(void)showNetworkAlert:(id)errorClassObj withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [[[ConnectionManager getInstance] serailQueue] cancelAllOperations];
    [[[ConnectionManager getInstance] concurrentQueue] cancelAllOperations];
    UIAlertView *alertView =nil;
    
    if(errorCode==kCFURLErrorTimedOut)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                            message:@"Network appears to be too low. Please check your connection" delegate:errorClassObj
                                                  cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
        
    }else if(errorCode==kCFURLErrorNotConnectedToInternet)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                               message:@"Please check your network connections. Network appears to be offline." delegate:errorClassObj
                                     cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
        
    }else
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                               message:msg delegate:errorClassObj
                                     cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
    }
}

+(NSString *)getOrderStatusObject:(NSUInteger)state
{
    switch (state)
    {
        case FORDELIVERY:
            return @"FORDELIVERY";
        
        case FORPAYMENT:
            return @"FORPAYMENT";
            
        case FORHOMEDELIVERY:
            return @"FORHOMEDELIVERY";
            
        case FORHOMEDELIVERYPAYMENT:
            return @"FORHOMEDELIVERYPAYMENT";
        
        case CLOSED:
            return @"CLOSED";
        
        case CANCELED:
            return @"CANCELED";
            
        case INITIAL:
            return @"INITIAL";
            
        default:
            return @"";
            
    }
}

+(NSUInteger)getOrderStateFromObject:(NSString *)state
{
    if ([state isEqualToString:@"FORDELIVERY"]) {
        return FORDELIVERY;
        
    }else if ([state isEqualToString:@"FORPAYMENT"]) {
        return FORPAYMENT;
        
    }else if ([state isEqualToString:@"FORHOMEDELIVERY"]) {
        return FORHOMEDELIVERY;
        
    }else if ([state isEqualToString:@"FORHOMEDELIVERYPAYMENT"]) {
        return FORHOMEDELIVERYPAYMENT;
        
    }else if ([state isEqualToString:@"CLOSED"]) {
        return CLOSED;
        
    }else if ([state isEqualToString:@"CANCELED"]) {
        return CANCELED;
        
    }else{
        return INITIAL;
        
    }
}

+(void)saveDeliveryAddress:(NSString *)addressTxt withLatitude:(double)latitude withLongitude:(double)longitude
{
    NSManagedObjectContext *context = [[Utility getApplicationRootClass] managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Address"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"fullText = %@", addressTxt]];
    [request setFetchLimit:1];
    
    NSUInteger count = [context countForFetchRequest:request error:&error];
    if (count == NSNotFound)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }else if (count == 0)
    {
        Address *address = [NSEntityDescription insertNewObjectForEntityForName:@"Address"
                                                         inManagedObjectContext:context];
        address.fullText =addressTxt;
        address.latitude = [NSNumber numberWithDouble:latitude];
        address.longitude = [NSNumber numberWithDouble:longitude];
        
        if (![context save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }

                
    
}

+(CGFloat)getHeightToExclude
{
    return (44+[UIApplication sharedApplication].statusBarFrame.size.height);
}

+(UIFont *)getFontWithSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

+(UIColor *) getDarkColor
{
    //return [UIColor whiteColor]; //pat1 gray , white gold theme
    //return UIColorFromRGB(0x585858); //pat 2 green theme
    
    //return [UIColor colorWithRed:(80.0/255.0) green:(124.0/255.0) blue:(236.0/255.0) alpha:1.0]; //webtheme
    
    return  [UIColor blackColor];
}

+(UIColor *) getLightColor
{
    //return [UIColor colorWithRed:(255.0/255.0) green:(182.0/255.0) blue:(0.0/255.0) alpha:1.0f]; //pat1 gold bar title
    //return UIColorFromRGB(0x118C4E);
    
    //return [UIColor purpleColor];
    
    return [UIColor whiteColor];
    
    
}

+(UIColor *) getThemeContrastColor
{
    //return [UIColor whiteColor]; //pat 1
    //return UIColorFromRGB(0x118C4E); //pat 2
    //return [UIColor colorWithRed:(49.0/255.0) green:(49.0/255.0) blue:(49.0/255.0) alpha:1.0f]; //pat 3
    //return [UIColor colorWithRed:(76.0/255.0) green:(103.0/255.0) blue:(137.0/255.0) alpha:1.0f];
    return [UIColor colorWithRed:(35.0/255.0) green:(47.0/255.0) blue:(115.0/255.0) alpha:1.0f];
}

+(UIColor *) getThemeColor
{
    //pat 1 pt 2 ans 3 same as dark
    return [UIColor colorWithRed:(46.0/255.0) green:(160.0/255.0) blue:(220.0/255.0) alpha:1.0f];
    
}

+(UIColor *) getNeutralColor
{
    //return [UIColor colorWithRed:(49.0/255.0) green:(49.0/255.0) blue:(49.0/255.0) alpha:1.0f]; //pat1 gray
    
    //return [UIColor whiteColor];// pat 2
    
    //return [UIColor whiteColor]; //pat3
    
    return [UIColor colorWithRed:(223.0/255.0) green:(223.0/255.0) blue:(223.0/255.0) alpha:1.0f];
}

+(void)setAppearance
{
    [[UINavigationBar appearance] setBarTintColor:[Utility getThemeColor]];
    
    [[UINavigationBar appearance] setTintColor:[Utility getThemeContrastColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                                                           NSForegroundColorAttributeName,
                                                           nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UISearchBar appearance] setBarTintColor:[Utility getThemeColor]];
    
    
    [[UISearchBar appearance] setTintColor:[Utility getThemeContrastColor]];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[Utility getLightColor]];
    
    [[UISegmentedControl appearance] setTintColor:[Utility getThemeContrastColor]];
    [[UIButton appearance] setTintColor:[Utility getThemeContrastColor]];
    
}

@end
