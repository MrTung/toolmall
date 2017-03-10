//
//  OrderListItemHeader.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOrderInfo.h"

@interface OrderListItemHeader : UITableViewHeaderFooterView

@property (nonatomic) IBOutlet UILabel *orderSn;
@property (nonatomic) IBOutlet UILabel *orderStatus;
@end
