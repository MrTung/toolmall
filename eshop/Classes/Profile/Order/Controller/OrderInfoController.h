//
//  OrderInfoController.h
//  eshop
//
//  Created by mc on 15/11/30.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderService.h"
#import "PullTableView.h"
#import "OrderInfoHeader.h"
#import "OrderInfoFooter.h"
#import "AppOrderInfo.h"
#import "CancelOrder.h"

@interface OrderInfoController : UIBaseController<ServiceResponselDelegate, UITableViewDataSource, UITableViewDelegate, CancelOrderDelegate, UIAlertViewDelegate>{
    OrderService *orderService;
    OrderInfoHeader *orderInfoHeader;
    OrderInfoFooter *orderInfoFooter;
    AppOrderInfo *orderInfo;
}

@property (nonatomic) IBOutlet PullTableView *tableOrder;
@property (nonatomic) IBOutlet UIView *buttonsView;

@property NSString *orderSn;
@end
