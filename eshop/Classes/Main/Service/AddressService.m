//
//  AddressService.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "AddressService.h"

@implementation AddressService

// 获取地址列表
- (void) getAddressList {
    SESSION *session = [SESSION getSession];
    AddressListRequest *request = [[AddressListRequest alloc] init];
    request.session = session;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:request.toJsonString forKey:@"json"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    AddressListResponse *respObj = [[AddressListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_address_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_address_list params:params responseObj:respObj];
}

// 添加地址
- (void) addAddress:(NSString*) consignee tel:(NSString*) tel mobile:(NSString*) mobile zipcode:(NSString*) zipcode address:(NSString*) addr area:(int) area {
    AddressAddRequest *request=[[AddressAddRequest alloc] init];
    request.session = [SESSION getSession];
    Address *address = [[Address alloc] init];
    address.consignee = consignee;
    address.tel = tel;
    address.mobile = mobile;
    address.address = addr;
    address.area = area;
    request.address = address;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:request.toJsonString forKey:@"json"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    Status *respObj = [[Status alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_address_add];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_address_add params:params responseObj:respObj];
}

// 获取地区城市
- (void) region:(int)regionId {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillIntToDictionary:params key:@"regionId" value:regionId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    RegionResponse *respObj = [[RegionResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_region];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_region params:params responseObj:respObj];
    
}


// 获取地址详细信息
- (void) getAddressInfo:(NSString*) address_id {
    AddressInfoRequest *request= [[AddressInfoRequest alloc] init];
    request.addressId=address_id;
    request.session=[SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    AddressInfoResponse *respObj = [[AddressInfoResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_address_info];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_address_info params:params responseObj:respObj];
}

// 设置默认地址
- (void) addressDefault:(NSString*)address_id {
    
    AddressSetDefaultRequest *request= [[AddressSetDefaultRequest alloc] init];
    request.address_id=address_id;
    request.session=[SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    Status *respObj = [[Status alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_address_setdefault];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_address_setdefault params:params responseObj:respObj];
}

// 删除地址
- (void) addressDelete:(NSString*) address_id {
    AddressDeleteRequest *request= [[AddressDeleteRequest alloc] init];
    request.address_id=address_id;
    request.session=[SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_address_delete];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_address_delete params:params responseObj:respObj];
    
}

// 修改地址
- (void) addressUpdate:(NSString*) address_id consignee:(NSString*) consignee tel:(NSString*) tel mobile:(NSString*) mobile zipcode:(NSString*) zipcode address:(NSString*) address area:(int) area {
    
    AddressUpdateRequest *request= [[AddressUpdateRequest alloc] init];
    Address *add = [[Address alloc] init];
    add.consignee = consignee;
    add.tel = tel;
    add.mobile = mobile;
    add.zipcode = zipcode;
    add.address = address;
    add.area = area;
    request.address=add;
    request.session=[SESSION getSession];
    request.address_id=address_id;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    Status *respObj = [[Status alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_address_update];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_address_update params:params responseObj:respObj];
}
@end
