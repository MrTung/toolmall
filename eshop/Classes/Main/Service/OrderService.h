
//
//  OrderService.h
//  toolmall
//
//  Created by mc on 15/10/19.
//
//

#import "BaseService.h"
#import "OrderListResponse.h"
#import "Pagination.h"
#import "OrderCreateResponse2.h"
#import "OrderCreateRequest2.h"
#import "OrderBuildResponse2.h"
#import "OrderPayRequest.h"
#import "StatusResponse.h"
#import "OrderExpressResponse.h"
#import "MapResponse.h"
#import "OrderCalculateRequest2.h"
#import "ListResponse.h"
#import "OpinionListResponse.h"

@interface OrderService : BaseService

//订单关键词搜索
- (void)getOrderListByKeyword:(NSString *)keyword;

- (void) getOrderList:(NSString *) type pagination:(Pagination *)pagination keyword:(NSString *)keyword;

- (void) buildOrder2:(Boolean) useBalance;

- (void)createOrder2:(OrderCreateRequest2*)request;
/** 立即购买 */
- (void)buildOrderAtOnceWithProductId:(int )productId quantity:(int )quantity;

// 取消订单
- (void) orderCancle:(NSString*) sn cancelReason:(int) cancelReason ;
// 确认收货
- (void) confirmReceived:(NSString*) sn;
/**
 * 提醒发货
 * @param sn
 */
- (void) remindShipping:(NSString*) sn;
// 查物流
- (void) orderExpress:(NSString*) ordersn;
//计算订单
- (void) calculateOrders:(OrderCalculateRequest2*) request;
/**
 * 计算运费
 */
- (void) calculateFreight:(AppShippingMethod*) shippingMethod areaId:(int) areaId ;
- (void) getOrderInfo:(NSString*) sn;

//订单搜索历史
- (void)orderSearchHistory;
//清空订单搜索历史
- (void)clearOrderSearchHistory;
//获取订单的评价列表
- (void)getOrderOpinionList:(long)orderId;


@end
