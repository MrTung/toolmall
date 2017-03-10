//
//  OrderInfoHeader.h
//  eshop
//
//  Created by mc on 15/12/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppOrderInfo.h"
#import "MyWebView.h"
@interface OrderInfoHeader : UIView{
    UILabel *lbOrderStatus;
    UILabel *lbCreateTime;
    UILabel *lbOrderId;
    UILabel *lbReceiverName;
    UILabel *lbReceiverPhone;
    UILabel *lbReceiverAddress;
    UIView *bgView1;
    UIView *bgView2;
    UIView *expressView; //物流信息白色背景
    UILabel * line;
    UIImageView * expressArrow;
    UIImageView * imgDitu;
    UILabel *lbExpressContent;
    UILabel *lbExpressTime;
    
    AppOrderInfo * appOrderInfo;
}
@property UINavigationController *navigationController;

- (void)setOrderInfo:(AppOrderInfo*)orderInfo;
//点击快递详情信息,跳转到快递详情页
- (void)clickOnButtonToDetailInfoOfExpression:(UIButton *)button;
@end
