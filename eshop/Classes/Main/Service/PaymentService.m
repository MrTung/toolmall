//
//  PaymentService.m
//  eshop
//
//  Created by mc on 15/11/8.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "PaymentService.h"

@implementation PaymentService

- (void) onlinePay:(NSString*)type paymentPluginId:(NSString*) paymentPluginId sn:(NSString*)sn  amount:(NSNumber*) amount {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:[SESSION getSession].toJsonString];
    [CommonUtils fillStrToDictionary:params key:@"type" value:type];
    [CommonUtils fillStrToDictionary:params key:@"paymentPluginId" value:paymentPluginId];
    [CommonUtils fillStrToDictionary:params key:@"sn" value:sn];
    [params setObject:amount forKey:@"amount"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    OnlinePayResponse *respObj = [[OnlinePayResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_online_pay];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_online_pay params:params responseObj:respObj];
    
}




@end
