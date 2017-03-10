//
//  OrderSearchHistoryItem.m
//  图片处理
//
//  Created by mc on 16/3/30.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "OrderSearchHistoryItem.h"

#import "UIFont+Fit.h"
@implementation OrderSearchHistoryItem
@synthesize titleColor = _titleColor;


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        _lblName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-10, self.frame.size.height - 20)];
        _lblName.textAlignment = NSTextAlignmentLeft;
        _lblName.font = [UIFont systemFontWithSize:15];
        _lblName.textColor = [UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1];
        _lblName.text = title;
        [self addSubview:_lblName];
        
        UIView * viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        viewLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:viewLine];
    }
    
    return self;
}

@end
