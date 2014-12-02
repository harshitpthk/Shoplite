//
//  SCartUtility.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 09/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCartAppDelegate.h"
#import "Enumerations.h"
#import "SavedList.h"
#import "OrderDetail.h"
#import "Order.h"
#import "ProductVariance.h"

@interface Utility : NSObject

+ (SCartAppDelegate *) getApplicationRootClass;
+(NSString *)getSecurityKeyName;
+(NSString *)getGoogleAPIKey;
+(NSString *)getGooglePlacesAPIKey;
+ (NSString *) encrypt:(NSString *) dataToEncrypt withKey:(NSString*) key;
+ (NSString *) decrypt:(NSString *) dataToDecrypt withKey:(NSString*) key;
+(NSString *)getUniqueSession;
+(NSString *)getSpliter;

//enum conversions
+(NSString *)getOrderStatusObject:(NSUInteger)state;
+(NSUInteger)getOrderStateFromObject:(NSString *)state;

//error
+(NSUInteger)getClientErrorCodeFromServerCode:(NSUInteger )serverErrorCode;
+(void)showNetworkAlert:(id)errorClassObj withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg;


//coredata
+(void)saveDeliveryAddress:(NSString *)addressTxt withLatitude:(double)latitude withLongitude:(double)longitude;

+(CGFloat)getHeightToExclude;
//apearence
+(UIFont *)getFontWithSize:(CGFloat)fontSize;

+(UIColor *) getDarkColor;
+(UIColor *) getThemeContrastColor;
+(UIColor *) getLightColor;
+(UIColor *) getNeutralColor;
+(UIColor *) getThemeColor;

+(void)setAppearance;

@end
