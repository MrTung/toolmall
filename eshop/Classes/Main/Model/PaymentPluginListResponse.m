//
//  PaymentPluginListResponse.m
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "PaymentPluginListResponse.h"

@implementation PaymentPluginListResponse

+ (Class)data_class{
    return [AppPaymentPlugin class];
}
@end
