//
//  SCartGetStartedController.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 09/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "GetStartedController.h"
#import "SignUpController.h"
#import "AESCrypt.h"

@interface GetStartedController ()

@end

@implementation GetStartedController

@synthesize getStartedButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.getStartedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.getStartedButton setFrame:CGRectMake(50, self.view.frame.size.height-80, self.view.frame.size.width*0.7, 40)];
    [self.getStartedButton setTitle:@"Get Started" forState:UIControlStateNormal];
    [self.getStartedButton setTitleColor:[Utility getThemeContrastColor] forState:UIControlStateNormal];
    self.getStartedButton.layer.cornerRadius = 4;
    self.getStartedButton.layer.borderWidth = 0.5;
    self.getStartedButton.layer.borderColor = [Utility getThemeContrastColor].CGColor;
    [self.getStartedButton.titleLabel setFont:[Utility getFontWithSize:16.0]];
    [self.getStartedButton addTarget:self action:@selector(LaunchSignUpScreen) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.getStartedButton];
}

- (void) LaunchSignUpScreen
{
    SignUpController *signUpController = [[SignUpController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:signUpController animated:NO];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
