//
//  CouponDetailViewController.h
//  eshop
//
//  Created by mc on 16/3/17.
//  Copyright (c) 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"
#import "AppCoupon.h"
#import "CouponService.h"
#import "CouponCodeList.h"

@interface CouponDetailViewController : UIBaseController{
    CouponService *couponService;
    AppCoupon *coupon;
}

@property (nonatomic,weak) IBOutlet UILabel *lbName;
@property (nonatomic,weak) IBOutlet UILabel *lbUseScopeName;
@property (nonatomic,weak) IBOutlet UILabel *lbDecreasePrice;
@property (nonatomic,weak) IBOutlet UILabel *lbMinPrice;
@property (nonatomic,weak) IBOutlet UILabel *lbSubTitle;

@property(nonatomic,copy) NSString *exchangeCode;
@property(nonatomic) NSInteger couponId;

- (IBAction)clickButtons:(UIButton*)sender;
@end
