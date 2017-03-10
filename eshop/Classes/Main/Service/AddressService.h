//
//  AddressService.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "AddressListRequest.h"
#import "AddressListResponse.h"
#import "AddressAddRequest.h"
#import "StatusResponse.h"
#import "RegionResponse.h"
#import "AddressInfoRequest.h"
#import "AddressInfoResponse.h"
#import "AddressSetDefaultRequest.h"
#import "AddressDeleteRequest.h"
#import "AddressUpdateRequest.h"

@interface AddressService : BaseService

// 获取地址列表
- (void) getAddressList ;

// 添加地址
- (void) addAddress:(NSString*) consignee tel:(NSString*) tel mobile:(NSString*) mobile zipcode:(NSString*) zipcode address:(NSString*) addr area:(int) area ;
// 获取地区城市
- (void) region:(int)regionId;


// 获取地址详细信息
- (void) getAddressInfo:(NSString*) address_id ;

// 设置默认地址
- (void) addressDefault:(NSString*)address_id ;

// 删除地址
- (void) addressDelete:(NSString*) address_id ;

// 修改地址
- (void) addressUpdate:(NSString*) address_id consignee:(NSString*) consignee tel:(NSString*) tel mobile:(NSString*) mobile zipcode:(NSString*) zipcode address:(NSString*) address area:(int) area;

@end
