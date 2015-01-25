//
//  SCartVerifyController.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 09/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationDelegate.h"
#import "HttpsOperations.h"

@interface VerificationController : UIViewController<OperationDelegate>
{
    UILabel             *screenTitle;
    UILabel             *msgBox;
    
    UILabel             *verifiedPhoneNumber;
    UITextField         *verificationCode;
    
    UIButton            *verifyButton;
    UIButton            *resendButton;
    UIButton            *signUpAgainButton;
    
    UILabel             *verificatinErrorMsg;
    HttpsOperations     *resendOperation;
}

@property (nonatomic, strong) UILabel             *screenTitle;
@property (nonatomic, strong) UILabel             *msgBox;

@property (nonatomic, strong) UILabel         *verifiedPhoneNumber;
@property (nonatomic, strong) UITextField         *verificationCode;

@property (nonatomic, strong) UIButton            *verifyButton;
@property (nonatomic, strong) UIButton            *resendButton;
@property (nonatomic, strong) UIButton            *signUpAgainButton;

@property (nonatomic, strong) UILabel             *verificatinErrorMsg;


@end
