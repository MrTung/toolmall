//
//  PluginService.m
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "PluginService.h"

@implementation PluginService

// 获取支付插件
- (void)getPaymentPlugins{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:session.toJsonString, @"session", nil];
    [CommonUtils fillStrToDictionary:params key:@"os" value:@"ios"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    PaymentPluginListResponse *respObj = [[PaymentPluginListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_payment_plugins];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_payment_plugins params:params responseObj:respObj];
    
}

@end
