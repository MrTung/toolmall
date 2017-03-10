//
//  OrderInfoFooter.m
//  eshop
//
//  Created by mc on 15/12/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderInfoFooter.h"

@interface OrderInfoFooter ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;


@end

@implementation OrderInfoFooter

- (void)awakeFromNib {

    [super awakeFromNib];
    
    // 运费:
    NSString *orderInfoFooter_lable1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lable1_title"];
    // 优惠券:
    NSString *orderInfoFooter_lable2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lable2_title"];
    // 实付金额:
    NSString *orderInfoFooter_lable3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lable3_title"];
    // 支付方式
    NSString *orderInfoFooter_lable4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lable4_title"];
    // 配送方式
    NSString *orderInfoFooter_lable5_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lable5_title"];
    // 优惠
    NSString *orderInfoFooter_lable6_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lable6_title"];
    // 发票信息
    NSString *orderInfoFooter_lable7_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lable7_title"];
    // 买家留言:
    NSString *orderInfoFooter_lable8_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lable8_title"];
    self.label1.text = orderInfoFooter_lable1_title;
    self.label2.text = orderInfoFooter_lable2_title;
    self.label3.text = orderInfoFooter_lable3_title;
    self.label4.text = orderInfoFooter_lable4_title;
    self.label5.text = orderInfoFooter_lable5_title;
    self.label6.text = orderInfoFooter_lable6_title;
    self.label7.text = orderInfoFooter_lable7_title;
    self.label8.text = orderInfoFooter_lable8_title;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setOrderInfo:(AppOrderInfo *)orderInfo{

    self.lbTotalMoney.text = [@"" stringByAppendingString:[CommonUtils formatCurrency:orderInfo.price]];
    self.lbFreight.text = [@"" stringByAppendingString: [CommonUtils formatCurrency:orderInfo.freight]];
    self.lbDiscount.text = [@"" stringByAppendingString:[CommonUtils formatCurrency:orderInfo.couponDiscount]];
        self.lbAmount.text = [@"" stringByAppendingString: [CommonUtils formatCurrency:orderInfo.amount]];
//    付费
    if (orderInfo.paymentMethodName) {
        self.lbPayMethod.text = orderInfo.paymentMethodName;
    }
//    快递方式
    if (orderInfo.shippingMethodName) {
        self.lbShippingMethod.text = orderInfo.shippingMethodName;
    }
//    优惠券
    if (orderInfo.couponCode.coupon.name) {
        self.lbOrderCoupon.text = orderInfo.couponCode.coupon.name;
    }
    
    // @"不需要发票"
    NSString *orderInfoFooter_lbOrderInvoice_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lbOrderInvoice_title"];
    
//    发票信息
    if ([orderInfo.invoiceType isEqualToString:@"REG"]) {
        
        self.lbOrderInvoice.text = orderInfo.invoiceTitle;
    }
    else if ([orderInfo.invoiceType isEqualToString:@"VAT"]) {
        
        self.lbOrderInvoice.text = orderInfo.invoiceCompanyName;
    }
    else{
        self.lbOrderInvoice.text = orderInfoFooter_lbOrderInvoice_title;
    }
//    买家留言
    
    // 买家留言:
    NSString *orderInfoFooter_lable8_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lable8_title"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.lbOrderMessage.font forKey:NSFontAttributeName];
    CGSize size = [orderInfoFooter_lable8_title sizeWithAttributes:dic];
    
    CGRect frame = self.lbOrderMessage.frame;
    frame.origin.x = size.width+10;
    self.lbOrderMessage.frame = frame;
    
    if (orderInfo.memo) {
        self.lbOrderMessage.text = orderInfo.memo;
    }
    //组合优惠省
    if (orderInfo.promotionDiscount.floatValue > 0){
//        NSString *promAmount =@"(组合优惠省";
//        promAmount = [[promAmount stringByAppendingString:[CommonUtils formatCurrency:orderInfo.promotionDiscount]] stringByAppendingString:@")"];
        
        // @"(组合优惠省%@)"
        NSString *orderInfoFooter_lbPromAmount_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoFooter_lbPromAmount_title"];
        NSString *promAmount = [NSString stringWithFormat:orderInfoFooter_lbPromAmount_title, [CommonUtils formatCurrency:orderInfo.promotionDiscount]];
        self.lbPromAmount.text = promAmount;
    } else {
        self.lbPromAmount.hidden = YES;
    }
    CGRect hframe = [self frame];
    hframe.size.height = 275.0;
    [self setFrame:hframe];
}
@end
