//
//  DepositListResponse.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "AppDeposit.h"
@interface DepositListResponse : BaseModel
@property Status *status;
@property NSMutableArray *data;
@property NSNumber *balanceAmt;
@property Paginated *paginated;

+ (Class)data_class;
@end
