//
//  SCartQRScanner.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 10/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "MainScreenController.h"


#define CENTER_VIEW_TAG 1

@interface MainScreenController ()

@end

@implementation MainScreenController

@synthesize centerView;
@synthesize leftView;
@synthesize centerNavController;
@synthesize leftNavController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor lightTextColor]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCenterViewToMainView];
    // Do any additional setup after loading the view.
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if(value)
    {
        [self.centerNavController.view.layer setCornerRadius:5];
        [self.centerNavController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.centerNavController.view.layer setShadowOpacity:0.8];
        [self.centerNavController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
    else{
        [self.centerNavController.view.layer setCornerRadius:0.0f];
        [self.centerNavController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}



- (void) addCenterViewToMainView
{
    self.centerView = [[CenterViewController alloc] initWithNibName:nil bundle:nil];
    self.centerNavController= [[UINavigationController alloc] initWithRootViewController:self.centerView];
    self.centerNavController.view.tag = CENTER_VIEW_TAG;
    
    //[[UINavigationBar appearance] setBarTintColor:[Utility getDarkBackGroundColor]];
    [[UINavigationBar appearance] setTintColor:[Utility getActionableFontColor]];
    //[[UINavigationBar appearance]  setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[Utility getActionableFontColor],NSForegroundColorAttributeName, nil]];
    
    [[UITextField appearance] setTextColor:[Utility getActionableFontColor]];
    
    self.centerNavController.title=@"shoplite";
    
    self.centerView.delegate = self;
    [self.view addSubview:self.centerNavController.view];
    [self addChildViewController:self.centerNavController];
    [self.centerNavController didMoveToParentViewController:self];
    
}

- (UIView *) getLeftPanelView
{
   /* if(self.leftView == nil)
    {
        self.leftView = [[SCartLeftViewController alloc] initWithNibName:nil bundle:nil];
        self.leftView.view.tag = 2;
        [self.view addSubview:self.leftView.view];
        
        [self addChildViewController:self.leftView];
        [self.leftView didMoveToParentViewController:self];
        [self.leftView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-60, self.view.frame.size.height)];

    }
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftView.view;
    return view;
    */
    if(self.leftNavController == nil)
    {
        self.leftView = [[LeftViewController alloc] initWithNibName:nil bundle:nil];
        self.leftNavController = [[UINavigationController alloc] initWithRootViewController:self.leftView];
        [self.view addSubview:self.leftNavController.view];
        [self addChildViewController:self.leftNavController];
        [self.leftNavController didMoveToParentViewController:self];
        [self.leftNavController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-60, self.view.frame.size.height)];
        
    }
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftNavController.view;
    return view;
}


- (void)movePanelRight
{
    UIView *leftController =[self getLeftPanelView];
    [self.view sendSubviewToBack:leftController];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                          self.centerNavController.view.frame = CGRectMake(self.view.frame.size.width - 60, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.centerView = [self.centerNavController.viewControllers objectAtIndex:0];
                             self.centerView.leftButton.tag = 0;
                         }
                     }];
}

- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                        self.centerNavController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                         }
                     }];

}

- (void) resetMainView
{
    if (self.leftNavController != nil)
    {
       // [self.leftView.view removeFromSuperview];
       // self.leftView = nil;
        
        [self.leftNavController.view removeFromSuperview];
        self.leftNavController = nil;
        
        self.centerView = [self.centerNavController.viewControllers objectAtIndex:0];
        self.centerView.leftButton.tag = 1;
    }
    [self showCenterViewWithShadow:NO withOffset:0];

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
