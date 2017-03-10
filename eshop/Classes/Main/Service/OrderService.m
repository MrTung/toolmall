//
//  OrderService.m
//  toolmall
//
//  Created by mc on 15/10/19.
//
//

#import "OrderService.h"

#import "InformationService.h"
#import "OrderCalculateRequest2.h"
#import "OrderCalculateResponse2.h"
#import "OrderInfoResponse.h"

@implementation OrderService

- (void) getOrderList:(NSString *) type pagination:(Pagination *)pagination keyword:(NSString *)keyword{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:session.toJsonString, @"session", pagination.toJsonString, @"pagination",type, @"type", nil];
    [CommonUtils fillStrToDictionary:params key:@"keyword" value:keyword];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *orderService_showHUD_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderService_showHUD_title"];
    [CommonUtils showHUD:orderService_showHUD_title andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_order_list parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            OrderListResponse * respobj = [[OrderListResponse alloc] initWithDictionary:jj];
//            NSString * log = [[NSString alloc] initWithFormat:@"login succeed:%d", respobj.status.succeed];
//            NSLog(log);
            if (respobj.status.succeed == 1){
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_order_list response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_order_list];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_order_list time:time param:params];
                [informationService getPerformMessageWithtab:api_order_list time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }

            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_order_list];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_order_list time:time param:params];
                [informationService getPerformMessageWithtab:api_order_list time:currentDate error:error];
            }
        }];
    [operation start];
}

//创建订单
- (void) buildOrder2:(Boolean) useBalance {
    
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:session.toJsonString, @"json", nil];
    [CommonUtils fillBooleanToDictionary:params key:@"useBalance" value:useBalance];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    OrderBuildResponse2 *respObj = [[OrderBuildResponse2 alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_build2];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_build2 params:params responseObj:respObj];
}

//立即购买
- (void)buildOrderAtOnceWithProductId:(int)productId quantity:(int)quantity{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"productId" value:productId];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillIntToDictionary:params key:@"quantity" value:quantity];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    OrderBuildResponse2 *respObj = [[OrderBuildResponse2 alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_build_buyatonce];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_build_buyatonce params:params responseObj:respObj];
}

// 订单生成
- (void)createOrder2:(OrderCreateRequest2*)request{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:request.toJsonString, @"json", nil];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    OrderCreateResponse2 *respObj = [[OrderCreateResponse2 alloc] init];
    
    [CartService setCartResponse:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_create2];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_create2 params:params responseObj:respObj];
    
}

// 取消订单
- (void) orderCancle:(NSString*) sn cancelReason:(int) cancelReason {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:[SESSION getSession].toJsonString forKey:@"session"];
    [CommonUtils fillStrToDictionary:params key:@"sn" value:sn];
    [CommonUtils fillIntToDictionary:params key:@"cancelReason" value:cancelReason];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_cancel];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_cancel params:params responseObj:respObj];
}


// 确认收货
- (void) confirmReceived:(NSString*) sn {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:[SESSION getSession].toJsonString forKey:@"session"];
    [CommonUtils fillStrToDictionary:params key:@"sn" value:sn];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_confirmreceived];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_confirmreceived params:params responseObj:respObj];
}

/**
 * 提醒发货
 * @param sn
 */
- (void) remindShipping:(NSString*) sn{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:[SESSION getSession].toJsonString forKey:@"session"];
    [CommonUtils fillStrToDictionary:params key:@"sn" value:sn];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_remindshipping];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_remindshipping params:params responseObj:respObj];
}

// 查看物流
- (void) orderExpress:(NSString*) ordersn {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:[SESSION getSession].toJsonString forKey:@"session"];
    [CommonUtils fillStrToDictionary:params key:@"sn" value:ordersn];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    OrderExpressResponse *respObj = [[OrderExpressResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_express];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_express params:params responseObj:respObj];
}

// 计算订单
- (void) calculateOrders:(OrderCalculateRequest2*) request {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:request.toJsonString forKey:@"json"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    OrderCalculateResponse2 *respObj = [[OrderCalculateResponse2 alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_calculate];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_calculate params:params responseObj:respObj];
}



/**
 * 计算运费
 */
- (void) calculateFreight:(AppShippingMethod*) shippingMethod areaId:(int) areaId {
    NSMutableDictionary *request = [[NSMutableDictionary alloc] initWithCapacity:10];
    SESSION *session = [SESSION getSession];
    [CommonUtils fillIntToDictionary:request key:@"shippingMethod" value:shippingMethod.id];
    [CommonUtils fillIntToDictionary:request key:@"areaId" value:areaId];
    [CommonUtils fillIntToDictionary:request key:@"cartId" value:session.cartId];
    [CommonUtils fillStrToDictionary:request key:@"cartToken" value:session.cartToken];
    NSString *json = [CommonUtils DictionaryToJsonString:request];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [CommonUtils fillStrToDictionary:params key:@"json" value:json];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    MapResponse *respObj = [[MapResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_calculate_freight];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_calculate_freight params:params responseObj:respObj];
}

- (void) getOrderInfo:(NSString*) sn {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];

    [CommonUtils fillStrToDictionary:params key:@"sn" value:sn];
    [params setObject:[SESSION getSession].toJsonString forKey:@"session"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    OrderInfoResponse *respObj = [[OrderInfoResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_view];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_view params:params responseObj:respObj];
}


//订单搜索历史
- (void)orderSearchHistory{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:[SESSION getSession].toJsonString forKey:@"session"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    ListResponse *respObj = [[ListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_search_history];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_search_history params:params responseObj:respObj];
}

//清空订单搜索历史
- (void)clearOrderSearchHistory{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:[SESSION getSession].toJsonString forKey:@"session"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_order_clear_history];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_order_clear_history params:params responseObj:respObj];
}

//获取订单的评价列表
- (void)getOrderOpinionList:(long)orderId{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [CommonUtils fillIntToDictionary:params key:@"orderId" value:orderId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    OpinionListResponse *respObj = [[OpinionListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_review_listoforder];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_review_listoforder params:params responseObj:respObj];
}

@end
