//
//  OrderInfoHeader.m
//  eshop
//
//  Created by mc on 15/12/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderInfoHeader.h"

#import "UIFont+Fit.h"

@implementation OrderInfoHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) initLayout{
    if (lbOrderStatus != nil){
        return;
    }
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float labelHeight = TMScreenH *15/568;
    
    
    // @"订单编号: "
    NSString *orderInfoHeader_lbOrderId_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbOrderId_title"];
    // @"创建时间: "
    NSString *orderInfoHeader_lbCreateTime_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbCreateTime_title"];
    // @"订单状态: "
    NSString *orderInfoHeader_lbOrderStatus_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbOrderStatus_title"];
    // @"收件人: "
    NSString *orderInfoHeader_lbReceiverName_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbReceiverName_title"];
    // @"收货地址: "
    NSString *orderInfoHeader_lbReceiverAddress_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbReceiverAddress_title"];
    
    
    bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, TMScreenH *5/568, screenWidth, TMScreenH *65/568)];
    bgView1.backgroundColor = [UIColor whiteColor];
    
    lbOrderId = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *10/320, TMScreenH *5/568, TMScreenW *300/320, labelHeight)];
    [lbOrderId setText:orderInfoHeader_lbOrderId_title];
    [lbOrderId setFont:[UIFont systemFontWithSize:12]];
    [lbOrderId setTextColor:[UIColor darkGrayColor]];
    [bgView1 addSubview:lbOrderId];
    
    lbCreateTime = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *10/320, CGRectGetMaxY(lbOrderId.frame) + TMScreenH *5/568, TMScreenW *300/320, labelHeight)];
    [lbCreateTime setText:orderInfoHeader_lbCreateTime_title];
    [lbCreateTime setFont:[UIFont systemFontWithSize:12]];
    [lbCreateTime setTextColor:[UIColor darkGrayColor]];
    [bgView1 addSubview:lbCreateTime];
    
    lbOrderStatus = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *10/320, CGRectGetMaxY(lbCreateTime.frame) + TMScreenH *5/568, TMScreenW *300/320, labelHeight)];
    [lbOrderStatus setText:orderInfoHeader_lbOrderStatus_title];
    [lbOrderStatus setTextColor:[UIColor darkGrayColor]];
    [lbOrderStatus setFont:[UIFont systemFontWithSize:12]];
    [bgView1 addSubview:lbOrderStatus];
    
    
    
#pragma mark - 物流信息模块
    expressView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView1.frame)+ TMScreenH *5/568, screenWidth, TMScreenH *65/568)];
    expressView.backgroundColor = [UIColor whiteColor];
    expressView.userInteractionEnabled = YES;
    
    UIImageView * ima = [[UIImageView alloc] initWithFrame:CGRectMake(TMScreenW *10/320, TMScreenW *25/320, TMScreenH *20/568, TMScreenH *16/568)];
    ima.image = [UIImage imageNamed:@"red_car.png"];
    [expressView addSubview:ima];
    
    lbExpressContent = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *40/320, TMScreenH *5/568, TMScreenW *250/320, TMScreenH *30/568)];
    lbExpressContent.numberOfLines = 2;
    lbExpressContent.lineBreakMode = NSLineBreakByCharWrapping;
    [lbExpressContent setText:orderInfoHeader_lbOrderStatus_title];
    [lbExpressContent setTextColor:TMRedColor];
    [lbExpressContent setFont:[UIFont systemFontWithSize:12]];
    [expressView addSubview:lbExpressContent];
    
    lbExpressTime = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *40/320, CGRectGetMaxY(lbExpressContent.frame), TMScreenW *250/320, TMScreenH *30/568)];
    [lbExpressTime setText:orderInfoHeader_lbCreateTime_title];
    [lbExpressTime setTextColor:[UIColor darkGrayColor]];
    [lbExpressTime setFont:[UIFont systemFontWithSize:12]];
    [expressView addSubview:lbExpressTime];
    
    expressArrow = [[UIImageView alloc] initWithFrame:CGRectMake(expressView.frame.size.width - TMScreenW *20/320, TMScreenH *20/568, TMScreenW *10/320, TMScreenH *15/568 )];
    expressArrow.image = [UIImage imageNamed:@"gray_right_arrow"];
    [expressView addSubview:expressArrow];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *10/320, expressView.frame.size.height - TMScreenH *5/568, expressView.frame.size.width - TMScreenW *20/320, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [expressView addSubview:line];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, expressView.frame.size.width, expressView.frame.size.height);
    [btn addTarget:self action:@selector(clickOnButtonToDetailInfoOfExpression:) forControlEvents:UIControlEventTouchUpInside];
    [expressView addSubview:btn];
    
    
    bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView1.frame)+ TMScreenH *5/568, screenWidth, TMScreenH *65/568)];
    bgView2.backgroundColor = [UIColor whiteColor];

    imgDitu = [[UIImageView alloc] initWithFrame:CGRectMake(TMScreenW *10/320, TMScreenH *25/568, TMScreenW *16/320, TMScreenH *16/568)];
    imgDitu.image = [UIImage imageNamed:@"address.png"];
    [bgView2 addSubview:imgDitu];
    
    lbReceiverName = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *40/320, TMScreenH *5/568, TMScreenW *200/320, labelHeight)];
    [lbReceiverName setText:orderInfoHeader_lbReceiverName_title];
    [lbReceiverName setTextColor:[UIColor darkGrayColor]];
    [lbReceiverName setFont:[UIFont systemFontWithSize:12]];
    [bgView2 addSubview:lbReceiverName];
    
    lbReceiverPhone = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - TMScreenW *90/320, TMScreenH *5/568, TMScreenW *80/320, labelHeight)];
    [lbReceiverPhone setText:@""];
    lbReceiverPhone.textAlignment = NSTextAlignmentRight;
    [lbReceiverPhone setTextColor:[UIColor darkGrayColor]];
    [lbReceiverPhone setFont:[UIFont systemFontWithSize:12]];
    [bgView2 addSubview:lbReceiverPhone];

    lbReceiverAddress = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *40/320, TMScreenH *25/568, screenWidth - TMScreenW *80/320, labelHeight*2)];
    [lbReceiverAddress setFont:[UIFont systemFontWithSize:12]];
    [lbReceiverAddress setTextColor:[UIColor darkGrayColor]];
    lbReceiverAddress.numberOfLines = 0;
    [bgView2 addSubview:lbReceiverAddress];
    
    
    [self addSubview:bgView1];
    [self addSubview:expressView];
    [self addSubview:bgView2];
}

//点击快递详情信息,跳转到快递详情页
- (void)clickOnButtonToDetailInfoOfExpression:(UIButton *)button{
    
    // @"物流信息"
    NSString *orderInfoHeader_webView_navTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_webView_navTitle"];
    MyWebView *myWebView = [[MyWebView alloc] init];
    myWebView.navTitle = orderInfoHeader_webView_navTitle;
    SESSION *session = [SESSION getSession];
    NSString *url = [NSString stringWithFormat:@"%@/app/order/delivery_query.jhtm?sn=%@&sessionId=%@&key=%@&userId=%@", website_url, self->appOrderInfo.sn, session.sid, session.key, [session getStringUId]];
   
    
    myWebView.loadUrl = url;
    [self.navigationController pushViewController:myWebView animated:YES];
}


- (void)setOrderInfo:(AppOrderInfo*)orderInfo{
    self->appOrderInfo = orderInfo;
    [self initLayout];
    
    CGRect frame = [self frame];
    
    // @"订单编号: "
    NSString *orderInfoHeader_lbOrderId_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbOrderId_title"];
    // @"创建时间: "
    NSString *orderInfoHeader_lbCreateTime_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbCreateTime_title"];
    // @"订单状态: "
    NSString *orderInfoHeader_lbOrderStatus_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbOrderStatus_title"];
    // @"收件人: "
    NSString *orderInfoHeader_lbReceiverName_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbReceiverName_title"];
    // @"收货地址: "
    NSString *orderInfoHeader_lbReceiverAddress_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoHeader_lbReceiverAddress_title"];
    
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [lbOrderId setText:[orderInfoHeader_lbOrderId_title stringByAppendingString:[NSString stringWithFormat:@"%@",orderInfo.sn]]];
    [lbCreateTime setText:[orderInfoHeader_lbCreateTime_title  stringByAppendingString:[CommonUtils formatDateTime:orderInfo.createDate]]];
    [lbOrderStatus setText:[orderInfoHeader_lbOrderStatus_title  stringByAppendingString:orderInfo.orderStatusName]];
    
    [lbReceiverName setText:[orderInfoHeader_lbReceiverName_title stringByAppendingString:orderInfo.consignee]];
    [lbReceiverPhone setText:orderInfo.phone];
    [lbReceiverAddress setText:[orderInfoHeader_lbReceiverAddress_title stringByAppendingString:orderInfo.address]];
    [lbReceiverAddress sizeToFit];

    CGSize size = CGSizeMake(screenWidth - TMScreenW *80/320, 1000);
    CGSize labelSize = [lbReceiverAddress.text sizeWithFont:lbReceiverAddress.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    lbReceiverAddress.frame = CGRectMake(TMScreenW *40/320, CGRectGetMaxY(lbReceiverName.frame)+ TMScreenH *5/568, labelSize.width, labelSize.height);
    
//  有物流信息的时候 显示最新的物流信息，并且更行UI
    if (orderInfo.lastExpressInfo) {
        lbExpressContent.text = orderInfo.lastExpressInfo.context;
        [lbExpressContent sizeToFit];
        lbExpressTime.text = orderInfo.lastExpressInfo.time;
        [lbExpressTime setFrame:CGRectMake(CGRectGetMinX(lbExpressContent.frame), CGRectGetMaxY(lbExpressContent.frame) + TMScreenH *6/568, TMScreenW *200/320, TMScreenH *30/568)];
        [lbExpressTime sizeToFit];
        [expressView setFrame:CGRectMake(expressView.frame.origin.x, expressView.frame.origin.y, expressView.frame.size.width, CGRectGetMaxY(lbExpressTime.frame) + TMScreenH *20/568)];
        
        [line setFrame:CGRectMake(TMScreenW *10/320, expressView.frame.size.height - TMScreenH *5/568, expressView.frame.size.width - TMScreenW *10/320, 0.5)];
        [expressArrow setFrame:CGRectMake(expressView.frame.size.width - TMScreenW *20/320, TMScreenH *20/568, TMScreenW *10/320, TMScreenH *15/568)];
//        CGRect frameBgView2 = bgView2.frame;
        bgView2.frame = CGRectMake(0, CGRectGetMaxY(expressView.frame), bgView2.frame.size.width, CGRectGetMaxY(lbReceiverAddress.frame) + TMScreenH *10/568);
        
        expressView.hidden = NO;
        frame.size.height = bgView1.frame.size.height + bgView2.frame.size.height +expressView.frame.size.height + TMScreenH *17/568;
    }else{
//        没有物流信息
        CGRect frameBgView2 = expressView.frame;
        expressView.hidden = YES;
        [expressView removeFromSuperview];
        frameBgView2.size.height = labelSize.height + TMScreenH *30/568;
        bgView2.frame = frameBgView2;
        frame.size.height = bgView1.frame.size.height + bgView2.frame.size.height + TMScreenH *15/568;
        
    }
    
    [self setFrame:frame];
}
@end
