//
//  OrderSearchHistoryItem.h
//  图片处理
//
//  Created by mc on 16/3/30.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSearchHistoryItem : UIView

@property NSString * name;
@property UILabel * lblName;
@property CGFloat font;
@property UIColor * titleColor;
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

@end
