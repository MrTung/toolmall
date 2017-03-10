//
//  AppCouponCode.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppCoupon.h"

@interface AppCouponCode : BaseModel

@property(nonatomic,assign) int id;
/** 号码 */
@property(nonatomic,copy) NSString* code;

/** 是否已使用 */
@property Boolean isUsed;

/** 使用日期 */
@property(nonatomic,strong)  NSDate* usedDate;

/** 优惠券 */
@property(nonatomic,strong) AppCoupon* coupon;

/** 状态 **/
@property(nonatomic,copy)  NSString* statusDesc;

/** 份数 **/
@property(nonatomic,strong) NSNumber * ownNumber;

/** 使用日期 */
@property(nonatomic,strong)  NSDate* beginUseDate;

/** 使用日期 */
@property(nonatomic,strong)  NSDate* endUseDate;

@end
