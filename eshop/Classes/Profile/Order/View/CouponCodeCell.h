//
//  CouponCodeCell.h
//  eshop
//
//  Created by mc on 15/11/9.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCodeCell : UITableViewCell

@property (nonatomic) IBOutlet EGOImageView *image;
@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *beginDate;
@property (nonatomic) IBOutlet UILabel *endDate;

@end
