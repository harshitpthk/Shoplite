//
//  SCartSignUpController.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 09/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationDelegate.h"

@interface SignUpController : UIViewController <UITextFieldDelegate,OperationDelegate>
{
    UILabel             *titleSignUpLabel;
    UITextField         *userNameField;
    UITextField         *userMailField;
    UITextField         *phoneField;

    UIButton            *signUPDelegate;
}


@property (strong, nonatomic) UILabel             *titleSignUpLabel;
@property (strong, nonatomic) UITextField         *userNameField;
@property (strong, nonatomic) UITextField         *userMailField;
@property (strong, nonatomic) UITextField         *phoneField;

@property (strong, nonatomic) UIButton            *signUPDelegate;

@end
