//
//  PaymentPluginCell.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPaymentPlugin.h"

@interface PaymentPluginCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *lbName;

- (void)setPlugin:(AppPaymentPlugin*)plugin;
@end
