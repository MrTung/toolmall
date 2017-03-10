//
//  CouponCodeList.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponService.h"
#import "CouponCodeListResponse.h"
#import "CouponCodeListCell.h"
#import "AppCoupon.h"
#import "AppCouponCode.h"
#import "PullTableView.h"
#import "CouponExchangeByCodeViewController.h"
#import "ImproveInfoViewController.h"
#import "MyAccountViewController.h"
#import "CouponInfoController.h"
@interface CouponCodeList : UIBaseController<UITableViewDataSource,UITableViewDelegate, ServiceResponselDelegate>{


}

@property(nonatomic,weak) IBOutlet PullTableView *tableCouponCodeList;
@property(nonatomic,copy) NSMutableArray *couponCodeList;
@end
