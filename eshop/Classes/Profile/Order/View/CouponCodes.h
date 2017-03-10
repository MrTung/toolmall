//
//  CouponCodes.h
//  eshop
//
//  Created by mc on 15/11/9.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCouponCode.h"
#import "CouponCodeCell.h"
#import "OrderController.h"

@interface CouponCodes : UIBaseController

@property (nonatomic) IBOutlet UITableView *tableList;
@property NSMutableArray *couponCodes;
@property NSInteger section;
@end
