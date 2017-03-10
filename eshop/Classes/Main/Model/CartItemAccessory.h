//
//  CartItemAccessory.h
//  eshop
//
//  Created by mc on 16/6/27.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CartItemAccessory : BaseModel

@property(nonatomic,strong) NSString *accessoryHtml; //优惠描述
@property(nonatomic,strong) NSString *accessoryType; //优惠类型
@property(nonatomic,strong) NSNumber *discAmount; //折扣



@end
