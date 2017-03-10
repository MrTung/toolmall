//
//  MsgService.m
//  eshop
//
//  Created by mc on 15-11-4.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "MsgService.h"

@implementation MsgService
- (void)getMsgList:(Pagination *)pagination{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    MsgListResponse *respObj = [[MsgListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_msg_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_msg_list params:params responseObj:respObj];
}


- (void) viewMsg:(int)msgId {
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillIntToDictionary:params key:@"id" value:msgId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    MsgListResponse *respObj = [[MsgListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_msg_view];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_msg_view params:params responseObj:respObj];
}

- (void) reply:(int)msgId content:(NSString*)content{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillIntToDictionary:params key:@"id" value:msgId];
    [CommonUtils fillStrToDictionary:params key:@"content" value:content];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    MsgListResponse *respObj = [[MsgListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_msg_reply];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_msg_reply params:params responseObj:respObj];
    
}

- (void) send:(NSString*)title  content:(NSString*)content{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:@"title" value:title];
    [CommonUtils fillStrToDictionary:params key:@"content" value:content];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_msg_send];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_msg_send params:params responseObj:respObj];
}

@end
