//
//  PaymentPluginCell.m
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "PaymentPluginCell.h"

@implementation PaymentPluginCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setPlugin:(AppPaymentPlugin*)plugin{
    _lbName.text = plugin.name;
}
@end
