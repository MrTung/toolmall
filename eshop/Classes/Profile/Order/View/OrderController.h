//
//  OrderController.h
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderBuildResponse2.h"
#import "OrderService.h"
//#import "OrderHeader.h"
#import "OrderFooter.h"
#import "OrderItemHeader.h"
#import "AppOrderInfo.h"
#import "AppOrderItem.h"
#import "OrderItemCell.h"
#import "OrderItemFooter.h"
#import "OrderCreateRequest2.h"
#import "Address.h"
#import "AppPaymentMethod.h"
#import "OrderCreateResponse2.h"
#import "PaymentPlugins.h"
#import "AddressList.h"
#import "ShippingMethods.h"
#import "PaymentInfo.h"
#import "PaymentMethods.h"
#import "OrderInvoice.h"
#import "OrderCalculateResponse2.h"
#import "OrderCalculateRequest2.h"
#import "CartController.h"
#import "CouponCodes.h"
#import "OrderHeadView.h"
#import "ProductInfoViewController.h"
@interface OrderController : UIBaseController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, MsgHandler,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    OrderService *orderService;
    
    NSMutableArray *orders;
    Address *receiver;
    AppPaymentMethod *paymentMethod;
    AppInvoice *invoice;
    NSMutableArray *valiablePaymentMethods;
    
    OrderItemFooter *footerView;
    OrderFooter *orderFooter;
    Boolean blnOrderBuilded;
    OrderHeadView * orderHeaderView;
    
    OrderBuildResponse2 * orderBuildResponseBegin;
}

@property (nonatomic) IBOutlet UITableView *tableOrders;

- (void)setReceiver:(Address*)address;
- (void)setShippingMethod:(NSInteger)section shippingMethod:(AppShippingMethod*)shippingMethod;

- (void)setPaymentMethod:(AppPaymentMethod*)pPaymentMethod;
- (void)setCouponCode:(NSInteger)section couponCode:(AppCouponCode*)pCouponCode;
- (void)setInvoice:(AppInvoice*)pInvoice;

- (void)setOrderBuildResponse:(OrderBuildResponse2*)orderBuildResp;
@end
