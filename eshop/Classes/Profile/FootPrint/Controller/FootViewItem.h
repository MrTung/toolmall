//
//  FootViewItem.h
//  eshop
//
//  Created by mc on 16/4/1.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FootViewItem : UIView

@property NSString * image;
@property NSString * title;
@property NSString * price;

@property EGOImageView * imageview;
@property UILabel * lblName;
@property UILabel * lblPrice;

#pragma mark - 订单页-足迹
/*
 我的订单页——足迹
 */

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image title:(NSString *)title price:(NSNumber *)price;


@end
