//
//  UILine.m
//  eshop
//
//  Created by mc on 15/11/4.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "UILine.h"

@implementation UILine

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setWidth:(float)w{
    width = w;
}
-(void) setColor:(UIColor*)color{
    lineColor = color;
}

- (void)drawRect:(CGRect)rect{
    if (lineColor == nil){
        lineColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0f];
        //lineColor = [UIColor darkGrayColor];
    }
    if (width == 0){
        width = 0.5;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    CGContextStrokePath(context);
}

@end
