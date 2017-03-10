//
//  MyTextField.m
//  TextField左右视图位置重写
//
//  Created by mc on 16/3/30.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "LXFTextField.h"

@implementation LXFTextField


//- (CGRect)borderRectForBounds:(CGRect)bounds;
//- (CGRect)textRectForBounds:(CGRect)bounds;
//- (CGRect)placeholderRectForBounds:(CGRect)bounds;
//- (CGRect)editingRectForBounds:(CGRect)bounds;
//- (CGRect)clearButtonRectForBounds:(CGRect)bounds;

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect = CGRectMake(rect.origin.x + _leftBlank, rect.origin.y, rect.size.width, rect.size.height);
    return rect;
}


- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect = CGRectMake(rect.origin.x + _rightBlank, rect.origin.y, rect.size.width, rect.size.height);
    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect rect = [super textRectForBounds:bounds];
    rect = CGRectMake(rect.origin.x + _textBlank, rect.origin.y, rect.size.width, rect.size.height);
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect = [super textRectForBounds:bounds];
    rect = CGRectMake(rect.origin.x + _textBlank, rect.origin.y, rect.size.width, rect.size.height);
    return rect;
}

//- (void)drawTextInRect:(CGRect)rect;
//- (void)drawPlaceholderInRect:(CGRect)rect;



@end
