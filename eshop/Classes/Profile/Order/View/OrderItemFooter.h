//
//  OrderItemFooter.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemFooter : UITableViewHeaderFooterView<UITextFieldDelegate,MsgHandler>


@property (nonatomic) IBOutlet UILabel *lbCouponName; //优惠券名字
@property (weak, nonatomic) IBOutlet UIButton *btnCouponName;
@property (nonatomic) IBOutlet UILabel *lbFreight; //运费
@property (weak, nonatomic) IBOutlet UIButton *btnFreight;
@property (weak, nonatomic) IBOutlet UITextField *txtBuyerMessage; //买家留言
@property (weak, nonatomic) IBOutlet UILabel *lblItemTotal;

@property (weak, nonatomic) IBOutlet UIView *payMentView;
@property (weak, nonatomic) IBOutlet UIView *invoiceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentViewTopMarginConstraint;

//支付方式
@property (nonatomic) IBOutlet UILabel *lbPaymentMethod;
//发票
@property (nonatomic) IBOutlet UILabel *lbInvoice;

@property id<MsgHandler> msgHandler;
@property NSInteger section;
@end
