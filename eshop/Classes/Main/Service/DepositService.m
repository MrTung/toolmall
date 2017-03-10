//
//  DepositService.m
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "DepositService.h"

@implementation DepositService

- (void) getDepositList:(Pagination *)pagination{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:session.toJsonString forKey:@"session"];
    [params setObject:pagination.toJsonString forKey:@"pagination"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    DepositListResponse *respObj = [[DepositListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_deposit_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_deposit_list params:params responseObj:respObj];

}
@end
