//
//  PaymentPlugins.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentPlugins.h"
#import "PluginService.h"
#import "PaymentPluginCell.h"
#import "AppOrderInfo.h"
#import "AppDeposit.h"
#import "PaymentService.h"
#import "PaymentInfo.h"
#import "OnlinePayResponse.h"
#import "CartController.h"
#import "OrderList.h"

@interface PaymentPlugins : UIBaseController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    PluginService *pluginService;
    PaymentService *paymentService;
    NSMutableArray *pluginList;
    PaymentInfo *paymentInfo;
}
@property (nonatomic) IBOutlet UITableView *tablePlugins;
@property Boolean isFromOrderCreateScreen;
- (void)setPaymentInfo:(PaymentInfo*)ppaymentInfo;

@property (nonatomic, copy) NSString *orderValidMsg;

@end
