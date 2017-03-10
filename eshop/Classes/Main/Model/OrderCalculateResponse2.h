//
//  OrderCalculateResponse2.h
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseModel.h"
#import "Address.h"
#import "AppOrderInfo.h"

@interface OrderCalculateResponse2 : BaseModel
@property (nonatomic) Status * status;
@property (nonatomic) NSMutableArray * orders;
@property (nonatomic) NSNumber * balanceAmt;
@property (nonatomic) NSMutableArray * paymentMethods;
@property (nonatomic) int totalPoint;
@property (nonatomic) Address *defaultAddress;

+ (Class) orders_class;
+ (Class) paymentMethods_class;

- (NSNumber*) getTotalAmount;

- (NSNumber*) getTotalPayableAmount;
@end
