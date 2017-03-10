//
//  CouponInfoResponse.h
//  eshop
//
//  Created by mc on 16/3/17.
//  Copyright (c) 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppCoupon.h"

@interface CouponInfoResponse : BaseModel
@property (nonatomic) Status * status;
@property (nonatomic) AppCoupon *data;
@end
