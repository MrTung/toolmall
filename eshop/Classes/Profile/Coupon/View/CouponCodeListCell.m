//
//  CouponCodeListCell.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "CouponCodeListCell.h"

@implementation CouponCodeListCell

- (void)setCouponCode:(AppCouponCode *) couponCode{
    
    // @"使用范围 "
    NSString *couponCodeListCell_lbUseScopeName_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponCodeListCell_lbUseScopeName_title"];
    // @"使用期限 %@ - %@"
    NSString *couponCodeListCell_lbExpireDates_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponCodeListCell_lbExpireDates_title"];
    // @"满%@可用"
    NSString *couponCodeListCell_lbMinPrice_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponCodeListCell_lbMinPrice_title"];
    [self.lbName setText:couponCode.coupon.name];
    [self.lbDecreasePrice setText:[[NSString alloc] initWithFormat:@"¥%@" , couponCode.coupon.decreasePrice]];
    if (couponCode.coupon.useScopeName) {
        
        [self.lbUseScopeName setText:[couponCodeListCell_lbUseScopeName_title stringByAppendingString: couponCode.coupon.useScopeName]];
    }
    NSString *expireDates = [NSString stringWithFormat:couponCodeListCell_lbExpireDates_title, [CommonUtils formatDate:couponCode.coupon.beginDate], [CommonUtils formatDate:couponCode.coupon.endDate]];
    [self.lbExpireDates setText:expireDates];
    NSString *minPrice = [[NSString alloc] initWithFormat:couponCodeListCell_lbMinPrice_title , couponCode.coupon.minimumPrice];
    [self.lbMinPrice setText:minPrice];
}

@end
