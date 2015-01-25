//
//  SCartVerifyController.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 09/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "VerificationController.h"
#import "ConnectionManager.h"
#import "KeychainWrapper.h"
#import "AESCrypt.h"
#import "NSData+CommonCrypto.h"
#import "NSData+Base64.h"

@interface VerificationController ()

@end

@implementation VerificationController


@synthesize  screenTitle;
@synthesize  msgBox;
@synthesize  verifiedPhoneNumber;
@synthesize  verificationCode;
@synthesize  verifyButton;
@synthesize  resendButton;
@synthesize  signUpAgainButton;
@synthesize  verificatinErrorMsg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //Veify Tite Lable
        self.screenTitle = [[UILabel alloc] init];
        [self.screenTitle setText:@"Verify"];
        [self.screenTitle setTextColor:[Utility getThemeContrastColor]];
        self.screenTitle.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        [self.screenTitle setFont:[Utility getFontWithSize:25.0f]];
        self.screenTitle.textAlignment = NSTextAlignmentLeft;
        
        
        self.msgBox = [[UILabel alloc] init];
        [self.msgBox setText:@"We have sent a code for verifying you as a real person, please enter the code received on your phone number"];
        [self.msgBox setTextColor:[Utility getDarkColor]];
        self.msgBox.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        [self.msgBox setFont:[Utility getFontWithSize:11.0f]];
        self.msgBox.textAlignment = NSTextAlignmentLeft;
        self.msgBox.numberOfLines = 0;
        
        self.verifiedPhoneNumber = [[UILabel alloc] initWithFrame:CGRectZero];
        self.verifiedPhoneNumber.textAlignment = NSTextAlignmentLeft;
        self.verifiedPhoneNumber.font = [Utility getFontWithSize:14.0];
        self.verifiedPhoneNumber.adjustsFontSizeToFitWidth = YES;
        self.verifiedPhoneNumber.textColor =  [Utility getDarkColor];
        
        
        self.verificationCode = [[UITextField alloc] initWithFrame:CGRectZero];
        self.verificationCode.placeholder = @"Unknown Field to Clarify";
        self.verificationCode.textAlignment = NSTextAlignmentLeft;
        self.verificationCode.font = [Utility getFontWithSize:14.0];
        self.verificationCode.adjustsFontSizeToFitWidth = YES;
        self.verificationCode.textColor =  [Utility getDarkColor];
        self.verificationCode.keyboardType = UIKeyboardTypeEmailAddress;
        self.verificationCode.returnKeyType = UIReturnKeyDone;
        self.verificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        
        self.verifyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.verifyButton setTitle:@"Verify" forState:UIControlStateNormal];
        self.verifyButton.layer.cornerRadius = 4;
        self.verifyButton.layer.borderWidth = 0.5;
        self.verifyButton.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        [self.verifyButton.titleLabel setFont:[Utility getFontWithSize:16.0f]];
        [self.verifyButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.verifyButton addTarget:self action:@selector(verify) forControlEvents:UIControlEventTouchDown];
        
        self.resendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.resendButton setTitle:@"Resend" forState:UIControlStateNormal];
        self.resendButton.layer.cornerRadius = 4;
        self.resendButton.layer.borderWidth = 0.5;
        self.resendButton.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        [self.resendButton.titleLabel setFont:[Utility getFontWithSize:16.0f]];
        [self.resendButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.resendButton addTarget:self action:@selector(resend) forControlEvents:UIControlEventTouchDown];
        
        self.signUpAgainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.signUpAgainButton setTitle:@"Reenter" forState:UIControlStateNormal];
        self.signUpAgainButton.layer.cornerRadius = 4;
        self.signUpAgainButton.layer.borderWidth = 0.5;
        self.signUpAgainButton.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        [self.signUpAgainButton.titleLabel setFont:[Utility getFontWithSize:16.0f]];
        [self.signUpAgainButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.signUpAgainButton addTarget:self action:@selector(gotoSignUpAgainScreen) forControlEvents:UIControlEventTouchDown];
        
        
        //Error msg display label initially hidden
        self.verificatinErrorMsg = [[UILabel alloc] init];
        [self.verificatinErrorMsg setText:@"Wrong Verifycation code try again"];
        [self.verificatinErrorMsg setTextColor:[UIColor redColor]];
        self.verificatinErrorMsg.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        [self.verificatinErrorMsg setFont:[Utility getFontWithSize:13.0f]];
        self.verificatinErrorMsg.textAlignment = NSTextAlignmentCenter;
        self.verificatinErrorMsg.hidden = YES;
        
        
        [self.view addSubview:self.screenTitle];
        [self.view addSubview:self.msgBox];
        [self.view addSubview:self.verifiedPhoneNumber];
        [self.view addSubview:self.verificationCode];
        [self.view addSubview:self.verifyButton];
        [self.view addSubview:self.resendButton];
        [self.view addSubview:self.signUpAgainButton];
        [self.view addSubview:self.verificatinErrorMsg];


        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    

    // Do any additional setup after loading the view.
    
    [self.screenTitle setFrame:CGRectMake(20, self.view.frame.origin.y + 20, 150, 100)];
    [self.msgBox setFrame:CGRectMake(20, self.screenTitle.frame.size.height-20, self.view.frame.size.width - 20, 60)];
    [self.verifiedPhoneNumber setFrame:CGRectMake(20, self.msgBox.frame.origin.y + self.msgBox.frame.size.height, self.view.frame.size.width-20, 40)];
    [self.verificationCode setFrame:CGRectMake(20, self.verifiedPhoneNumber.frame.origin.y+self.verifiedPhoneNumber.frame.size.height + 10,self.view.frame.size.width - 20 , 40)];
    [self.verifyButton setFrame:CGRectMake(20, self.verificationCode.frame.origin.y+self.verificationCode.frame.size.height + 20, self.view.frame.size.width/3-40, 35)];
    [self.resendButton setFrame:CGRectMake(self.view.frame.size.width/3+10, self.verificationCode.frame.origin.y+self.verificationCode.frame.size.height + 20, self.view.frame.size.width/3-40, 35)];
    [self.signUpAgainButton setFrame:CGRectMake(2*self.view.frame.size.width/3, self.verificationCode.frame.origin.y+self.verificationCode.frame.size.height + 20, self.view.frame.size.width/3-30, 35)];
    
    [self.verificatinErrorMsg setFrame:CGRectMake(20, self.signUpAgainButton.frame.origin.y+self.signUpAgainButton.frame.size.height + 25, self.view.frame.size.width - 20, 50)];

}

-(void)verify
{
    
    NSString *regEmailPattern = @"^[0-9]+$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regEmailPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger noOfMatches = [regex numberOfMatchesInString:self.verificationCode.text options:0 range:NSMakeRange(0, [self.verificationCode.text length])];
    
    if(noOfMatches==0)
    {
        self.verificationCode.text = @"";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Validation failed. Please enter the verification code received on your mobile."
                                                        message:nil delegate:self
                                              cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
        
        
    
        return;
    }
    NSData *data =[self.verificationCode.text dataUsingEncoding:NSUTF8StringEncoding];
    
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"adduser" isPost:YES];
    [postRequest setHTTPBody:data];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
}

- (void) launchMainApp
{
    [[Utility getApplicationRootClass] initiateApplication];
}


- (void) resend
{
    
    KeychainWrapper *keyChain = [KeychainWrapper getInstance];
    NSData *data = [keyChain myObjectForKey:(__bridge id)kSecAttrAccount];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)data];
    
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"registeruser" isPost:YES];
    [postRequest setHTTPBody:jsonData];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
     resendOperation = operation;
    
}

- (void) gotoSignUpAgainScreen
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    if(![operation isEqual:resendOperation])
    {
        NSError *e = nil;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:operation.receivedData options: NSJSONReadingMutableContainers error: &e];
        
        if(array==nil || [array count]<1)
        {
            //throw error
        }

        NSString *encodedString  = [array objectAtIndex:0];
        NSString *decodedString = [Utility decrypt:encodedString withKey:[Utility getSecurityKeyName]];
         KeychainWrapper *keyChain = [KeychainWrapper getInstance];
        [keyChain mySetObject:decodedString forKey:(__bridge id)kSecValueData];
        [self launchMainApp];
    }
}

-(void)operationFailed:(id)operation withErrorCode:(NSUInteger)errorCode
{
    if(![operation isEqual:resendOperation])
    {
        self.verificationCode.text = @"";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Validation failed. Please enter the verification code received on your mobile."
                                                            message:nil delegate:self
                                                  cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
        
        
        
        return;
    }
    
     [[Utility getApplicationRootClass] launchErrorScreen];
    
}

-(void)networkFailed:(id)operation withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [Utility showNetworkAlert:self withErrorCode:errorCode withMessage:msg];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
