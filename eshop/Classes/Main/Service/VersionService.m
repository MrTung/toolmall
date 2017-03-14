//
//  VersionService.m
//  eshop
//
//  Created by mc on 15-11-12.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "VersionService.h"

@implementation VersionService

- (void) getUpgradePolicy:(NSString*) appVersion{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"appType" value:@"iPhone"];
    [CommonUtils fillStrToDictionary:params key:@"appVersion" value:appVersion];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    AppUpdate *appUpdate = [[AppUpdate alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_app_update];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_app_update params:params responseObj:appUpdate showLoading:NO];
}

- (void)getUpgradePolicy:(NSString*) appVersion success:(void (^)(BaseModel*responseObj))success{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"appType" value:@"iPhone"];
    [CommonUtils fillStrToDictionary:params key:@"appVersion" value:appVersion];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
    
    AppUpdate *appUpdate = [[AppUpdate alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_app_update];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_app_update params:params responseObj:appUpdate showLoading:NO success:success];
}
@end
