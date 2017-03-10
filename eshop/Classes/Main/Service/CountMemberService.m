//
//  CountMemberService.m
//  eshop
//
//  Created by mc on 16/3/14.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CountMemberService.h"

#import "InformationService.h"

@implementation CountMemberService

- (void) increaseActive:(CountMemberRequest *) request{
    request.source = @"ios";
    request.sourceItem = @"b00000";
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    StatusResponse *response = [[StatusResponse alloc] init];
    InformationService *informationService = [[InformationService alloc] init];
    [informationService getIsCheckEnabled];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_count_active];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_count_active params:params responseObj:response showLoading:NO];
}

- (void) heatBeatRequest:(NSString *) imei{
    NSString *url = [[@"heartbeat/" stringByAppendingString:imei] stringByAppendingString:@".jhtm"];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *response = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:url];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:url params:params responseObj:response showLoading:NO method:@"GET"];
}



@end
