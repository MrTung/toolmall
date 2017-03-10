//
//  CouponCodeListCell.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCouponCode.h"

@interface CouponCodeListCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *lbName;
@property (nonatomic,weak) IBOutlet UILabel *lbUseScopeName;
@property (nonatomic,weak) IBOutlet UILabel *lbExpireDates;
@property (nonatomic,weak) IBOutlet UILabel *lbDecreasePrice;
@property (nonatomic,weak) IBOutlet UILabel *lbMinPrice;

- (void)setCouponCode:(AppCouponCode *) couponCode;
@end
