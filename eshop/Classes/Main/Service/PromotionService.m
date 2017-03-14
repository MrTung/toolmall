//
//  PromotionService.m
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "PromotionService.h"

@implementation PromotionService

- (void) getPromotionList:(NSString*) promotionType pagination:(Pagination*) pagination {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"promotionType" value:promotionType];
    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    PromotionListResponse *respObj = [[PromotionListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_promotion_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_promotion_list params:params responseObj:respObj];
}

- (void) getPromotionList:(NSString*) promotionType pagination:(Pagination*) pagination success:(void (^)(BaseModel*responseObj))success{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"promotionType" value:promotionType];
    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
    
    PromotionListResponse *respObj = [[PromotionListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_promotion_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_promotion_list params:params responseObj:respObj success:success];
}

@end
