//
//  CartHeadView1.m
//  eshop
//
//  Created by mc on 16/8/23.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CartHeadView1.h"

@implementation CartHeadView1


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:218/255.0 alpha:1];
        [self setup];
    }
    return self;
}

- (void)setup{
    self.lblContent = [[UILabel alloc] init];
//    self.lblContent.text = @"新用户首单免运费。";
    self.lblContent.textColor = [UIColor colorWithRed:212/255.0 green:2/255.0 blue:27/255.0 alpha:1];
    self.lblContent.frame = CGRectMake(35, 0, self.frame.size.width - 75, self.frame.size.height);
    self.lblContent.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.lblContent];
    
    self.btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnClose.frame = CGRectMake(CGRectGetMaxX(self.lblContent.frame), 7, 20, 20);
    [self.btnClose setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
//    [self.btnClose setTitle:@"x" forState:UIControlStateNormal];
    [self.btnClose setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self addSubview:self.btnClose];
    
}

@end
