//
//  AppProduct.m
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "AppProduct.h"

@implementation AppProduct

+ (Class)appParameters_class{
    return [AppParameter class];
}

+ (Class)appProductImages_class{
    return [AppProductImage class];
}

+ (Class)validPromotions_class{
    return [AppPromotion class];
}

+ (Class)validCoupons_class{
    return [AppCoupon class];
}


@end
