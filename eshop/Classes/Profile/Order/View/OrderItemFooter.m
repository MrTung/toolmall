//
//  OrderItemFooter.m
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderItemFooter.h"

@interface OrderItemFooter ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;

@end

@implementation OrderItemFooter

@synthesize lbCouponName;
@synthesize lbFreight;
@synthesize lbPaymentMethod;
@synthesize lbInvoice;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {

    [super awakeFromNib];
    
    // 优惠
    NSString *orderItemFooter_label1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderItemFooter_label1_title"];
    // 运费
    NSString *orderItemFooter_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderItemFooter_label2_title"];
    // 买家留言:
    NSString *orderItemFooter_label3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderItemFooter_label3_title"];
    // 支付方式
    NSString *orderItemFooter_label4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderItemFooter_label4_title"];
    // 发票信息
    NSString *orderItemFooter_label5_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderItemFooter_label5_title"];
    // 选填，可填写您和卖家达成一致的要求
    NSString *orderItemFooter_txtBuyerMessage_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderItemFooter_txtBuyerMessage_plaTitle"];
    
    self.label1.text = orderItemFooter_label1_title;
    self.label2.text = orderItemFooter_label2_title;
    self.label3.text = orderItemFooter_label3_title;
    self.label4.text = orderItemFooter_label4_title;
    self.label5.text = orderItemFooter_label5_title;
    self.txtBuyerMessage.placeholder = orderItemFooter_txtBuyerMessage_plaTitle;
    
}

// 运费
- (IBAction)clickButtons:(UIButton *)sender{
    Message *msg = [[Message alloc] init];
//    msg.what = sender.tag;
    msg.what = 1;
    msg.int1 = _section;
    [_msgHandler sendMessage:msg];
}

// 优惠券
- (IBAction)clickOnSelectCouponButton:(id)sender {
    Message *msg = [[Message alloc] init];
    msg.what = 6;
    msg.int1 = _section;
    [_msgHandler sendMessage:msg];
}

// 留言
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 0) {
        Message * msg = [[Message alloc] init];
        msg.what = 7;
        msg.int1 = _section;
        msg.obj = textField;
        [_msgHandler sendMessage:msg];
    }
}

//选择支付方式
- (IBAction)clickPaymentMethod:(id)sender{
    Message *msg = [[Message alloc] init];
    msg.what = 2;
    [_msgHandler sendMessage:msg];
}

//选择发票信息
- (IBAction)clickInvoice:(id)sender{
    Message *msg = [[Message alloc] init];
    msg.what = 4;
    [_msgHandler sendMessage:msg];
}

@end
