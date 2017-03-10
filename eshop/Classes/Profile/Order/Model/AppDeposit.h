//
//  AppDeposit.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface AppDeposit : BaseModel
/** 类型 */
@property NSString* type;

/** 类型 */
@property NSString* typename;

/** 收入金额 */
@property NSNumber* credit;

/** 支出金额 */
@property NSNumber* debit;

/** 当前余额 */
@property NSNumber* balance;

/** 备注 */
@property NSString* memo;

@property NSDate* createDate;
@end
