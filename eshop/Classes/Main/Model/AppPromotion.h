//
//  AppPromotion.h
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppPromotion : BaseModel


@property int id;

/** 名称 */
@property NSString* name;

/** 标题 */
@property NSString* title;

/** 起始日期 */
@property NSDate* beginDate;

/** 结束日期 */
@property NSDate* endDate;

/** 介绍 */
@property NSString* introduction;

/** 展示图片 */
@property NSString* image;

/** 横幅图片 */
@property NSString* bannerImage;

/*价格文字*/
@property NSString* priceWord;

@property NSString* promotionType;

@property NSString* promotionModeName;
@property NSNumber * cartDiscountAmount;
@property NSString * titleOnCart;

@end
