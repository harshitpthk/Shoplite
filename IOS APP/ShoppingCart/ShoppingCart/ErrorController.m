//
//  ErrorController.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 26/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "ErrorController.h"

@interface ErrorController ()

@end

@implementation ErrorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[Utility getThemeContrastColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height-40), self.view.frame.size.width, 40)];
    
    
    [label setFont:[Utility getFontWithSize:18.0]];
    [label setText:@"Error"];
    
    label.textColor = [Utility getLightColor];
    
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
