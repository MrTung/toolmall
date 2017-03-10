//
//  CouponCodeInfoResponse.h
//  eshop
//
//  Created by mc on 16/8/31.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppCouponCode.h"
@interface CouponCodeInfoResponse : BaseModel
@property (nonatomic) Status * status;
@property (nonatomic) AppCouponCode *data;
@end
