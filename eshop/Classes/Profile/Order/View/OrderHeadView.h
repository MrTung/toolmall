//
//  OrderHeadView.h
//  eshop
//
//  Created by mc on 16/8/25.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHeadView : UIView
{
    UILabel * lblName;
    UILabel * lblPhone;
    UILabel * lblAddress;
    UIImageView * imgAddress;
}

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * address;
- (instancetype)initWithFrame:(CGRect)frame Name:(NSString *)name phone:(NSString *)phone address:(NSString *)address;


@end
