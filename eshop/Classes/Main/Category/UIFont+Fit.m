//
//  UIFont+Fit.m
//  FontFitDemo
//
//  Created by wuqh on 16/6/3.
//  Copyright © 2016年 吴启晗. All rights reserved.
//

#import "UIFont+Fit.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_HEIGHT < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_HEIGHT == 736.0)

@implementation UIFont (Fit)

+ (UIFont *)systemFontWithSize:(CGFloat)fontSize {
//    if (IS_IPHONE_6P) {
        return [UIFont systemFontOfSize:fontSize*([UIScreen mainScreen].bounds.size.width/320)];
//    }else {
//        return [UIFont systemFontOfSize:fontSize];
//    }
}

+ (UIFont *)boldSystemFontWithSize:(CGFloat)fontSize {
    
    return [UIFont boldSystemFontOfSize:fontSize*([UIScreen mainScreen].bounds.size.width/320)];
}

@end
