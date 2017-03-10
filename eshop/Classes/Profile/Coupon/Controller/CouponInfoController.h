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

@interface CouponInfoController : UIBaseController{
}


@property (weak, nonatomic) IBOutlet UIImageView *imageviewBG;

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbMinPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblCouponCount;
@property (weak, nonatomic) IBOutlet UILabel *lblUsingLimitedDate;

@property (weak, nonatomic) IBOutlet UILabel *lblCouponName;
@property (weak, nonatomic) IBOutlet UILabel *lblFitProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblUsingDesc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewDescTop;

@property (weak, nonatomic) IBOutlet UIView *viewPro;
@property (assign, nonatomic)int couponId;
@property (weak, nonatomic) IBOutlet UILabel *lblUsingDescLimitOne;
@property (weak, nonatomic) IBOutlet UILabel *lblUsingRange;
@property (weak, nonatomic) IBOutlet UILabel *lblUsinPlatform;

@end
