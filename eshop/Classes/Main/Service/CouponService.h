//
//  CouponService.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "CouponCodeListResponse.h"
#import "CouponListResponse.h"
#import "MapResponse.h"
#import "CouponInfoResponse.h"
#import "CouponCodeInfoResponse.h"
@interface CouponService : BaseService


- (void) getCouponCodeList:(Pagination*)pagination;

- (void) getCouponCodeInfo:(int)couponId;

- (void) getCouponList:(Pagination*)pagination ;

- (void) exchange:(int) couponId;

- (void) exchangebycode:(NSString *) exchangeCode;

- (void) getCouponInfoByCode:(NSString *) exchangeCode;

- (void) getCouponInfo:(int ) couponId;

/** 点击链接获取优惠券 */
- (void) getExchange:(int) couponId;

/** 点击链接获取优惠券/JSView */
- (void)getJSViewExchange:(int)couponId;


@end
