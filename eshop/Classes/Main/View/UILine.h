//
//  UILine.h
//  eshop
//
//  Created by mc on 15/11/4.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILine : UIView
{
    float width;
    UIColor *lineColor;
}
- (void)setWidth:(float)w;
- (void) setColor:(UIColor*)color;

@end
