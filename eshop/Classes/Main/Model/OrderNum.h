//
//  OrderNum.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"

@interface OrderNum : BaseModel

@property int   shipped;
@property int await_ship;
@property int await_pay;
@property int await_review;
@property int allOrders;

@end
