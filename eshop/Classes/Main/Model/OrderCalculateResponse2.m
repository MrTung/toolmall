//
//  OrderCalculateResponse2.m
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderCalculateResponse2.h"

@implementation OrderCalculateResponse2
@synthesize orders;

+ (Class) orders_class{
    return [AppOrderInfo class];
}
+ (Class) paymentMethods_class{
    return [AppPaymentMethod class];
}

- (NSNumber*) getTotalAmount{
    float fAmount = 0;
    for (AppOrderInfo *order in orders){
        fAmount = fAmount + [order.amount floatValue];
    }
    return [[NSNumber alloc] initWithFloat:fAmount];
}

- (NSNumber*) getTotalPayableAmount{
    float fAmount = 0;
    for (AppOrderInfo *order in orders){
        fAmount = fAmount + [order.amountPayable floatValue];
    }
    return [[NSNumber alloc] initWithFloat:fAmount];
}
@end
