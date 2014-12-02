//
//  OrderDetailCell.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 24/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.mainTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width/2-20, self.frame.size.height/2)];
        self.subTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height/2, self.frame.size.width/2-20, self.frame.size.height/2)];
        self.rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-110, 0, 80, self.frame.size.height)];
        
        
        self.mainTitle.font = [Utility getFontWithSize:14];
        self.subTitle.font = [Utility getFontWithSize:12];
        self.rightTitle.font = [Utility getFontWithSize:12];
        
        self.rightTitle.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.mainTitle];
        [self addSubview:self.subTitle];
        [self addSubview:self.rightTitle];
        
    }
    
    return self;
}

@end
