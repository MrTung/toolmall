 //
//  ActivityService.m
//  eshop
//
//  Created by mc on 16/4/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "ActivityService.h"

@implementation ActivityService

//获取活动信息
- (void)getActivityInfoWithId:(long)activityId{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"id" value:activityId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    Response * respobj = [[Response alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_activity_content];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_activity_content params:params responseObj:respobj showLoading:YES];
}

//获取活动产品列表
- (void)getActivityListWithId:(long)activityId pagination:(Pagination *)pagination{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"id" value:activityId];
    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    ListResponse * respobj = [[ListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_activity_productlist];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_activity_productlist params:params responseObj:respobj];
}

@end
