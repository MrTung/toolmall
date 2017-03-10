//
//  OrderInfoFooter.h
//  eshop
//
//  Created by mc on 15/12/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOrderInfo.h"

@interface OrderInfoFooter : UIView
@property (weak, nonatomic) IBOutlet UILabel *lbTotalMoney; //商品总额
@property (weak, nonatomic) IBOutlet UILabel *lbFreight; //运费
@property (weak, nonatomic) IBOutlet UILabel *lbDiscount; //优惠券折扣
@property (weak, nonatomic) IBOutlet UILabel *lbAmount; //实付金额
@property (weak, nonatomic) IBOutlet UILabel *lbPromAmount; //

@property (weak, nonatomic) IBOutlet UILabel *lbPayMethod; //支付方式
@property (weak, nonatomic) IBOutlet UILabel *lbShippingMethod; //配送方式
@property (weak, nonatomic) IBOutlet UILabel *lbOrderCoupon; //优惠券
@property (weak, nonatomic) IBOutlet UILabel *lbOrderInvoice; //发票
@property (weak, nonatomic) IBOutlet UILabel *lbOrderMessage; //买家留言


- (void)setOrderInfo:(AppOrderInfo *)orderInfo;
@end
