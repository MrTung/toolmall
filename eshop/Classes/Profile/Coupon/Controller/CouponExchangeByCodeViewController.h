//
//  CouponExchangeByCodeViewController.h
//  eshop
//
//  Created by mc on 16/3/17.
//  Copyright (c) 2016年 hzlg. All rights reserved.
//

#import "UIBaseController.h"
#import "CouponService.h"
//#import "CodeScan.h"
#import "LBXScanViewController.h"
#import "SubLBXScanViewController.h"

@interface CouponExchangeByCodeViewController : UIBaseController{
    CouponService *couponService;
}

@property (nonatomic) IBOutlet UITextField *tf_exchangeCode;
- (IBAction)clickButtons:(UIButton*)sender;
@end
