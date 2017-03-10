//
//  OrderBuildResponse2.m
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderBuildResponse2.h"

@implementation OrderBuildResponse2
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
@end
