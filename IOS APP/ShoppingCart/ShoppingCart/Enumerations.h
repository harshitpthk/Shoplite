//
//  Enumerations.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 19/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#ifndef ShoppingCart_Enumerations_h
#define ShoppingCart_Enumerations_h

enum ErrorCode : NSUInteger
{
    RESULT_NOT_FOUND = 400,
    INTERNAL_SERVER_ERROR,
    PRECONDITION_FAILED,
    REQUEST_FORBIDDEN,
    REQUEST_NOTFOUND,
    UNAUTHORIZED,
    NETWORK_ERROR
};

enum OrderState : NSUInteger
{
    INITIAL,
    FORPAYMENT,
    FORHOMEDELIVERYPAYMENT,
    FORHOMEDELIVERY,
    FORDELIVERY,
    CLOSED,
    CANCELED
};

#endif
