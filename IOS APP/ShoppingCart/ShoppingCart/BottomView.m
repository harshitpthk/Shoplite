//
//  BottomView.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 22/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(10,0, self.frame.size.width-20, 1)];
        [divider setBackgroundColor:[Utility getThemeColor]];
        divider.layer.opacity =0.3;
        [self addSubview:divider];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.leftButton setFrame:CGRectMake(20,7,self.frame.size.width/2-40, 35)];
        self.leftButton.layer.cornerRadius = 4;
        self.leftButton.layer.borderWidth = 1.0;
        self.leftButton.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.rightButton setFrame:CGRectMake(self.frame.size.width/2+20,7,self.frame.size.width/2-40, 35)];
        self.rightButton.layer.cornerRadius = 4;
        self.rightButton.layer.borderWidth = 1.0;
        self.rightButton.layer.borderColor = [Utility getThemeContrastColor].CGColor;
        
        [self setBackgroundColor:[Utility getLightColor]];
        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
    }
    
    return self;
    
}

@end
