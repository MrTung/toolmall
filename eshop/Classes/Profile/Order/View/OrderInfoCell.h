//
//  OrderInfoCell.h
//  eshop
//
//  Created by mc on 15/11/30.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOrderItem.h"
#import "UILabel+Vertical.h"

@interface OrderInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *prodImage;
@property (weak, nonatomic) IBOutlet UILabel *lbProdName;
@property (weak, nonatomic) IBOutlet UILabel *lbQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lbProdSpec;
@property (weak, nonatomic) IBOutlet UILabel *lbProdPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbMarketPrice;
//@property (weak, nonatomic) IBOutlet UILabel *lbGiftInfo;
//@property (weak, nonatomic) IBOutlet UILabel *lbProdBrand;

- (void)setOrderItem:(AppOrderItem*)orderItem;

@end
