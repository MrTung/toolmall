//
//  AppOrderInfo.m
//  toolmall
//
//  Created by mc on 15/10/19.
//
//

#import "AppOrderInfo.h"

@implementation AppOrderInfo
+ (Class)appOrderItems_class{
    return [AppOrderItem class];
}
+ (Class)deposits_class{
    return [AppDeposit class];
}
+ (Class)validCouponCodes_class{
    return [AppCouponCode class];
}
+ (Class)shippingMethods_class{
    return [AppShippingMethod class];
}
@end
