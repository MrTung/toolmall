//
//  CouponService.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "CouponService.h"

@implementation CouponService


- (void) getCouponCodeList:(Pagination*)pagination {
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    CouponCodeListResponse *respObj = [[CouponCodeListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_couponcode_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_couponcode_list params:params responseObj:respObj];

}

- (void)getCouponCodeInfo:(int)couponId{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"id" value:couponId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    CouponCodeInfoResponse *respObj = [[CouponCodeInfoResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_couponcode_view];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_couponcode_view params:params responseObj:respObj];
}

- (void) getCouponList:(Pagination*)pagination {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    CouponListResponse *respObj = [[CouponListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_coupon_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_coupon_list params:params responseObj:respObj];
    
}

- (void) exchange:(int) couponId {
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillIntToDictionary:params key:@"couponId" value:couponId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    MapResponse *respObj = [[MapResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_coupon_exchange];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_coupon_exchange params:params responseObj:respObj];
}

- (void) exchangebycode:(NSString *) exchangeCode{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:@"exchangeCode" value:exchangeCode];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    MapResponse *respObj = [[MapResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_coupon_exchangebycode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_coupon_exchangebycode params:params responseObj:respObj];
}

- (void) getCouponInfoByCode:(NSString *) exchangeCode {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"exchangeCode" value:exchangeCode];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    CouponInfoResponse *respObj = [[CouponInfoResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_coupon_info_bycode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_coupon_info_bycode params:params responseObj:respObj];
}

- (void) getCouponInfo:(int ) couponId {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"id" value:couponId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    CouponInfoResponse *respObj = [[CouponInfoResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_coupon_info];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_coupon_info params:params responseObj:respObj];
}


/** 点击链接获取优惠券 */
- (void) getExchange:(int) couponId {
    
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillIntToDictionary:params key:@"couponId" value:couponId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
    
    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_coupon_getCoupon];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_coupon_getCoupon params:params responseObj:respObj];
    
}

/** 点击链接获取优惠券/JSView */
- (void)getJSViewExchange:(int)couponId {
    
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillIntToDictionary:params key:@"couponId" value:couponId];
//    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
//    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
    
    StatusResponse *respObj = [[StatusResponse alloc] init];
    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_coupon_getCoupon];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [self request:api_coupon_getCoupon params:params responseObj:respObj];
    
}

- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj{
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.parentView];
    // @"正在加载"
    NSString *baseService_showHUD_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"baseService_showHUD_title"];
    if (!baseService_showHUD_title.length) {
        baseService_showHUD_title = @"正在加载";
    }
    [CommonUtils showHUD:baseService_showHUD_title andView:self.parentView andHUD:hud];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_url parameters:params];
    
    //    NSLog(@"api_url --- %@",api_url);
    
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
        NSDictionary * jj = (NSDictionary *)JSON;
        [responseObj initWithDictionary:jj];

        if (self.delegate) {
            [self.delegate loadResponse:api_url response:responseObj];
        }
        [hud hideAnimated:YES];
        [hud removeFromSuperview];
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [hud hideAnimated:YES];
        [hud removeFromSuperview];
        
        if (self.parentView) {
            
            [CommonUtils alertUnExpectedError:error view:self.parentView];
        }
    }];
    [operation start];
}

@end
