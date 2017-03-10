//
//  OrderListItemFooter.m
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderListItemFooter.h"

@implementation OrderListItemFooter
@synthesize lnFooterDesc;
@synthesize containerView;

- (CGFloat)displayButtons:(AppOrderInfo*)orderInfo{
    
    // @"立即付款"
    NSString *orderListItemFooter_btn1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListItemFooter_btn1_title"];
    // @"查看物流"
    NSString *orderListItemFooter_btn2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListItemFooter_btn2_title"];
    // @"确认收货"
    NSString *orderListItemFooter_btn3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListItemFooter_btn3_title"];
    // @"提醒发货"
    NSString *orderListItemFooter_btn4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListItemFooter_btn4_title"];
    // @"发表评论"
    NSString *orderListItemFooter_btn5_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListItemFooter_btn5_title"];
    // @"取消订单"
    NSString *orderListItemFooter_btn6_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListItemFooter_btn6_title"];
    // @"我的评价"
    NSString *orderListItemFooter_btn7_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderListItemFooter_btn7_title"];
    
    NSMutableArray *dispButtons = [[NSMutableArray alloc] initWithCapacity:10];
    if (orderInfo.payEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderListItemFooter_btn1_title, @"title", @"red", @"color", @"1", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.expressViewEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderListItemFooter_btn2_title, @"title", @"gary", @"color", @"2", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.confirmReceiveEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderListItemFooter_btn3_title, @"title", @"gary", @"color", @"3", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.remindShippingEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderListItemFooter_btn4_title, @"title", @"red", @"color", @"4", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.reviewEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderListItemFooter_btn5_title, @"title", @"gary", @"color", @"5", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.cancelEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderListItemFooter_btn6_title, @"title", @"gary", @"color", @"6", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.myReviewsEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderListItemFooter_btn7_title, @"title", @"gary", @"color", @"7", @"tag", nil];
        [dispButtons addObject:dic];
    }
//    int buttonWidth = TMScreenW *70/320;
    UILabel *lightLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 33, kWidth, 1))];
    lightLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.containerView addSubview:lightLabel];
    
    int posX = TMScreenW - TMScreenW *80/320;
    for (NSDictionary *btndict in dispButtons){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect frame = CGRectMake(posX, 33 + TMScreenH *5/568, TMScreenW *70/320, TMScreenH *25/568);
        button.frame = frame;
        [button setTitle:[btndict objectForKey:@"title"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        if ([[btndict objectForKey:@"color"] isEqualToString:@"red"]){
            button.backgroundColor = redColorSelf;
            [CommonUtils decrateRedButton:button];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor colorWithRed:1/196 green:1/196 blue:1/196 alpha:1.0f] forState:UIControlStateNormal];
            [CommonUtils decrateGaryButton:button];
        }
        button.titleLabel.font = self.lnFooterDesc.font;
        button.tag = [[btndict objectForKey:@"tag"] intValue];
        [button addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:button];
        posX = posX - TMScreenW *76/320;
    }
    CGFloat height;
    if (dispButtons.count) {
        height = 33 + TMScreenH *35/568 +5;
    } else {
        height = 33 +5;
    }
    
    return height;
}

- (void) clickButtons:(UIButton*)button{
    [self.footerDelegate sendMessage:button.tag section:self.section];
}
@end
