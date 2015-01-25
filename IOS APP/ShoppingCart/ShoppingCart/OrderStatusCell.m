//
//  OrderStatusCellTableViewCell.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 22/11/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "OrderStatusCell.h"
#define index 56

@implementation OrderStatusCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withStatusArray:(NSArray *)array
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.mainTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width/2, self.frame.size.height/2)];
        self.rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-110, 0, 90, self.frame.size.height/2)];
        
        
        self.mainTitle.font = [Utility getFontWithSize:16];
        self.rightTitle.font = [Utility getFontWithSize:14];
        
        self.rightTitle.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.mainTitle];
        [self addSubview:self.rightTitle];
        
        CGFloat imageWidth = (self.frame.size.width-40)/array.count;
        CGFloat imageGap = (imageWidth-36)/2;
        
        for (int i=0;i<array.count; i++) {
            
            UIImageView *image= [[UIImageView alloc] initWithFrame:CGRectMake(20+i*imageWidth+imageGap, self.frame.size.height/2, 36, self.frame.size.height/2-20)];
            
            [image setImage:[UIImage imageNamed:@"sample.png"]];
            image.image = [image.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(20+i*imageWidth, self.frame.size.height-20, imageWidth, 20)];
            
            NSString *string = [array objectAtIndex:i];
            label.text = string;
            [label setFont:[Utility getFontWithSize:10]];
            label.textAlignment = NSTextAlignmentCenter;
            
            image.tag = index+(i)*2;
            label.tag = index+(i)*2+1;
            
            [self addSubview:image];
            [self addSubview:label];
            
        }
        
        self.statusArray =array;
        
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)layoutSubviews
{
    [self.mainTitle setFrame:CGRectMake(20, 0, self.frame.size.width/2, self.frame.size.height/2)];
    [self.rightTitle setFrame:CGRectMake(self.frame.size.width-110, 0, 90, self.frame.size.height/2)];
    
    CGFloat imageWidth = (self.frame.size.width-20)/self.statusArray.count;
    CGFloat imageGap = (imageWidth-36)/2;
    
    for (int i=0;i<self.statusArray.count; i++) {
        
        UIImageView *image= (UIImageView *)[self viewWithTag:(index+i*2)];
        UILabel *label= (UILabel *)[self viewWithTag:(index+i*2+1)];
        
        [image setFrame:CGRectMake(10+i*imageWidth+imageGap, self.frame.size.height/2, 36,self.frame.size.height/2-20)];
        [label setFrame:CGRectMake(10+i*imageWidth, self.frame.size.height-20, imageWidth, 20)];

    }
    
}

-(void)highlightStatus:(NSString *)status
{
    for (int i=0;i<self.statusArray.count; i++) {
        
        UIImageView *image= (UIImageView *)[self viewWithTag:(index+i*2)];
        
        UILabel *label= (UILabel *)[self viewWithTag:(index+i*2+1)];
        
        NSString *string = [self.statusArray objectAtIndex:i];
        
        if([string caseInsensitiveCompare:status]==NSOrderedSame)
        {
            [image setTintColor:[Utility getThemeColor]];
            [label setTintColor:[Utility getThemeColor]];
            
        }else{
            [image setTintColor:[Utility getNeutralColor]];
            [label setTintColor:[Utility getNeutralColor]];
        }
        
    }
}

@end
