//
//  AppCoupon.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppCoupon : BaseModel

@property int id;

/** 名称 */
@property(nonatomic,copy) NSString* name;

/** 前缀 */
@property(nonatomic,copy) NSString* prefix;

/** 使用起始日期 */
@property(nonatomic,strong) NSDate* beginDate;

/** 使用结束日期 */
@property(nonatomic,strong) NSDate* endDate;

/** 积分兑换数 */
@property(nonatomic,assign) int point;

/** 介绍 */
@property(nonatomic,copy) NSString* introduction;

/** 展示图片 */
@property(nonatomic,copy) NSString* image;

/** 最小商品价格 */
@property(nonatomic,strong)  NSNumber *minimumPrice;

/** 减少金额 */
@property(nonatomic,strong)  NSNumber *decreasePrice;

/** 适用范围 */
@property(nonatomic,copy)  NSString *useScopeName;

/** 使用平台 */
@property(nonatomic,copy)  NSString *usePlatformName;

@property(nonatomic,copy)  NSString *subTitle;

@property(nonatomic,copy)  NSString *subTitleBrief;

@property  Boolean isExpired;



@end
