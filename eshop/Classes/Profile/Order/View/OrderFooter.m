//
//  OrderFooter.m
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderFooter.h"

@interface OrderFooter ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation OrderFooter
@synthesize lbAmount;
@synthesize btnSubmit;

- (void)awakeFromNib {

    [super awakeFromNib];
    
    // 含运送费
    NSString *orderFooter_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderFooter_label_title"];
    // 立即购买
    NSString *orderFooter_btn_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderFooter_btn_title"];
    
    self.label.text = orderFooter_label_title;
    [self.btnSubmit setTitle:orderFooter_btn_title forState:(UIControlStateNormal)];
}

- (void)myinit{
}

//提交订单
- (IBAction)clickSubmit:(id)sender{
    Message *msg = [[Message alloc] init];
    msg.what = 3;
    [_msgHandler sendMessage:msg];
}

//选择快递方式
//- (IBAction)clickExpressionMethod:(id)sender {
//    Message *msg = [[Message alloc] init];
//    msg.what = 1;
//    [_msgHandler sendMessage:msg];
//}


@end
