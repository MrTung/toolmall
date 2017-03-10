//
//  SecondProductInfo.h
//  eshop
//
//  Created by gs_sh on 17/2/22.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface SecondProductInfo : BaseModel

/**
 * 活动开始时间
 */
@property(nonatomic, strong) NSString *activityBegin;

/**
 * 活动结束时间
 */
@property(nonatomic, strong) NSString *activityEnd;

/**
 * 预热时间
 */
@property(nonatomic, strong) NSString *preheatDate;


/**
 * 秒杀价
 */
@property(nonatomic, strong) NSNumber *secondPrice;

/**
 * 是否已售罄
 */
@property int isSaleOut;


/**
 * 是否还有机会参与秒杀
 */
@property int hasChance;

/**
 * 是否可加入购物车
 */
@property int addCartEnable;



@end
