//
//  SCartSignUpController.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 09/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "SignUpController.h"
#import "VerificationController.h"
#import "HttpsOperations.h"
#import "ConnectionManager.h"
#import "KeychainWrapper.h"

@interface SignUpController ()

@end

@implementation SignUpController

@synthesize  titleSignUpLabel;
@synthesize  userNameField;
@synthesize  userMailField;
@synthesize  phoneField;
@synthesize  signUPDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.titleSignUpLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleSignUpLabel setText:@"Sign Up"];
        [self.titleSignUpLabel setTextColor:[Utility getThemeContrastColor]];
       // self.SCTitleSignUpLabel.layer.cornerRadius = 4;
       // self.SCTitleSignUpLabel.layer.borderWidth = 0.5;
        self.titleSignUpLabel.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        [self.titleSignUpLabel setFont:[Utility getFontWithSize:22.0f]];
        self.titleSignUpLabel.textAlignment = NSTextAlignmentLeft;
        
        
        self.userNameField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.userNameField.placeholder = @"Name";
        self.userNameField.textAlignment = NSTextAlignmentLeft;
        self.userNameField.font = [Utility getFontWithSize:14.0];
        self.userNameField.adjustsFontSizeToFitWidth = YES;
        self.userNameField.textColor = [Utility getDarkColor];
        self.userNameField.keyboardType = UIKeyboardTypeAlphabet;
        self.userNameField.returnKeyType = UIReturnKeyNext;
        self.userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.userNameField.delegate =self;
        self.userNameField.tag=10;
        
        self.userMailField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.userMailField.placeholder = @"Email Id";
        self.userMailField.textAlignment = NSTextAlignmentLeft;
        self.userMailField.font = [Utility getFontWithSize:14.0];
        self.userMailField.adjustsFontSizeToFitWidth = YES;
        self.userMailField.textColor = [Utility getDarkColor];
        self.userMailField.keyboardType = UIKeyboardTypeEmailAddress;
        self.userMailField.returnKeyType = UIReturnKeyNext;
        self.userMailField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.userMailField.delegate =self;
        self.userMailField.tag=11;
        
        self.phoneField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.phoneField.placeholder = @"Phone No";
        self.phoneField.textAlignment = NSTextAlignmentLeft;
        self.phoneField.font = [Utility getFontWithSize:14.0];
        self.phoneField.adjustsFontSizeToFitWidth = YES;
        self.phoneField.textColor =  [Utility getDarkColor];
        self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneField.returnKeyType = UIReturnKeyDone;
        self.phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.phoneField.delegate =self;
        
        self.userMailField.tag=12;
        
        
        self.signUPDelegate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.signUPDelegate setTitle:@"Sign Up" forState:UIControlStateNormal];
        self.signUPDelegate.layer.cornerRadius = 4;
        self.signUPDelegate.layer.borderWidth = 1.0;
        self.signUPDelegate.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        [self.signUPDelegate.titleLabel setFont:[Utility getFontWithSize:16.0f]];
        [self.signUPDelegate.titleLabel setTextAlignment:NSTextAlignmentRight];
        [self.signUPDelegate addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchDown];
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float margin = 24.0f;
    float gapbetweencomponents = 10.0f;
    
    
    
    
    [self.titleSignUpLabel setFrame:CGRectMake(margin, self.view.frame.origin.y + 40, 150, 60)];
    [self.userNameField setFrame:CGRectMake(margin, self.titleSignUpLabel.frame.size.height +self.titleSignUpLabel.frame.origin.y+ gapbetweencomponents, self.view.frame.size.width-20, 40)];
    [self.userMailField setFrame:CGRectMake(margin, self.userNameField.frame.origin.y + self.userNameField.frame.size.height + gapbetweencomponents, self.view.frame.size.width-20, 40)];
    [self.phoneField setFrame:CGRectMake(margin, self.userMailField.frame.origin.y+self.userMailField.frame.size.height + gapbetweencomponents,self.view.frame.size.width - 20 , 40)];

    [self.signUPDelegate setFrame:CGRectMake(self.phoneField.frame.size.width/2, self.phoneField.frame.origin.y+self.phoneField.frame.size.height + gapbetweencomponents, self.view.frame.size.width/2-20 , 35)];


    
    [self.view addSubview:self.titleSignUpLabel];
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.userMailField];
    [self.view addSubview:self.phoneField];
    [self.view addSubview:self.signUPDelegate];

    
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
  
    
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userNameField.text = nil;
    self.userMailField.text = nil;
    self.phoneField.text = nil;
    
    KeychainWrapper *keyChain = [[KeychainWrapper alloc] init];
    id account = [keyChain myObjectForKey:(__bridge id)kSecAttrAccount];
    
    if([account isKindOfClass:[NSData class]])
    {
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)account];
        
        if([dict count]==3)
        {
            [self.userNameField setText:[dict objectForKey:@"name"]];
            [self.userMailField setText:[dict objectForKey:@"email"]];
            [self.phoneField setText:[dict objectForKey:@"phno"]];
            
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField==self.userNameField)
    {
        NSString *regEmailPattern = @"^[a-zA-Z][a-zA-Z .]+$";
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regEmailPattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger noOfMatches = [regex numberOfMatchesInString:textField.text options:0 range:NSMakeRange(0, [textField.text length])];
        
        if (noOfMatches == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter name without any numeric and special characters."
                                                                message:nil delegate:self
                                                      cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alertView show];
            
            return NO;
        }
        
        [self.userMailField becomeFirstResponder];
        
    }else if (textField==self.userMailField)
    {
        
        NSString *regEmailPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regEmailPattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger noOfMatches = [regex numberOfMatchesInString:textField.text options:0 range:NSMakeRange(0, [textField.text length])];
       
        if (noOfMatches == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter valid email address."
                                                   message:nil delegate:self
                                         cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alertView show];
            
            return NO;
        }
       
        [textField resignFirstResponder]; //bug
        
    }else
    {
        if(textField.text.length!=10)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter mobile number without any country code."
                                                                message:nil delegate:self
                                                      cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alertView show];
            
            return NO;
        }
            
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void)dismissKeyboard
{
    [self.userNameField resignFirstResponder];
    [self.userMailField resignFirstResponder];
    [self.phoneField resignFirstResponder];
}

- (void) signup
{
    
    if(self.userNameField.text.length==0 || self.userMailField.text.length==0 || self.phoneField.text.length==0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please fill all the fields"
                                                            message:nil delegate:self
                                                  cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    NSArray *objects=[[NSArray alloc]initWithObjects:self.userNameField.text,self.userMailField.text,self.phoneField.text,nil];
    NSArray *keys=[[NSArray alloc]initWithObjects:@"name",@"email",@"phno",nil];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
   
    
    NSError *error =nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"registeruser" isPost:YES];
    [postRequest setHTTPBody:jsonData];
    
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.serailQueue addOperation:operation];
    
   KeychainWrapper *keyChain = [KeychainWrapper getInstance];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:dict];
      [keyChain mySetObject:data forKey:(__bridge id)kSecAttrAccount];
   
}


- (void) launchVerificationScreen
{
    VerificationController *verifyController = [[VerificationController alloc] initWithNibName:nil bundle:nil];
    
    [verifyController.verifiedPhoneNumber setText:self.phoneField.text];
    [self.navigationController pushViewController:verifyController animated:NO];
}

#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    [self launchVerificationScreen];
}

-(void)operationFailed:(id)operation withErrorCode:(NSUInteger)errorCode
{
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
