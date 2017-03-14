//
//  SearchService.m
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "SearchService.h"

@implementation SearchService

//- (void) getProductSearchResult:(NSString*)keyword orderType:(NSString*)orderType pagination:(Pagination*)pagination {
//    SESSION *session = [SESSION getSession];
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
//    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
//    [CommonUtils fillStrToDictionary:params key:@"keyword" value:keyword];
//    [CommonUtils fillStrToDictionary:params key:@"orderType" value:orderType];
//    [CommonUtils fillStrToDictionary:params key:@"searchCookieUUID" value:[[UIDevice currentDevice] uniqueAppInstanceIdentifier]];
//    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
//    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
//
//    
//    ProductListResponse *respObj = [[ProductListResponse alloc] init];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_product_search_list];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [super request:api_product_search_list params:params responseObj:respObj];
//}

- (void) getProductSearchResult:(NSString*)keyword orderType:(NSString*)orderType pagination:(Pagination*)pagination success:(void (^)(BaseModel*responseObj))success{
    SESSION *session = [SESSION getSession] ;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
    [CommonUtils fillStrToDictionary:params key:@"keyword" value:keyword];
    [CommonUtils fillStrToDictionary:params key:@"orderType" value:orderType];
    [CommonUtils fillStrToDictionary:params key:@"searchCookieUUID" value:[[UIDevice currentDevice] uniqueAppInstanceIdentifier]];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];


    ProductListResponse *respObj = [[ProductListResponse alloc] init];

    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_product_search_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_product_search_list params:params responseObj:respObj success:success];
}

//- (void)getProductWithFetchSearchHistory:(Boolean)fetchSearchHistory andSearchCookieUUID:(NSString *)UUID andSession:(SESSION *)session andPagination:(Pagination *)pagination{
//    
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    [CommonUtils fillBooleanToDictionary:params key:@"fetchSearchHistory" value:fetchSearchHistory];
//    [CommonUtils fillStrToDictionary:params key:@"searchCookieUUID" value:UUID];
//    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
//    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
//    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
//    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
//
//    
//    HotSearchKeyListResponse * respObj = [[HotSearchKeyListResponse alloc] init];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_hotsearchkeylist];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [super request:api_hotsearchkeylist params:params responseObj:respObj];
//    
//}

- (void)getProductWithFetchSearchHistory:(Boolean)fetchSearchHistory andPagination:(Pagination *)pagination success:(void (^)(BaseModel*responseObj))success{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillBooleanToDictionary:params key:@"fetchSearchHistory" value:fetchSearchHistory];
    [CommonUtils fillStrToDictionary:params key:@"searchCookieUUID" value:[CommonUtils uuid]];
    [CommonUtils fillStrToDictionary:params key:@"session" value:[SESSION getSession].toJsonString];
    [CommonUtils fillStrToDictionary:params key:@"pagination" value:pagination.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
    
    HotSearchKeyListResponse * respObj = [[HotSearchKeyListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_hotsearchkeylist];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [super request:api_hotsearchkeylist params:params responseObj:respObj success:success];
}

//- (void)deleteHistoryKeyWordWithSearchCookieUUID:(NSString *)UUID andSession:(SESSION *)session{
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//
//    [CommonUtils fillStrToDictionary:params key:@"searchCookieUUID" value:UUID];
//    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
//    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
//    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
//    
//    StatusResponse * respObj = [[StatusResponse alloc] init];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_productsearchkey_clear_search_history];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [super request:api_productsearchkey_clear_search_history params:params responseObj:respObj];
//}
//

- (void)deleteHistoryKeyWordWithSuccess:(void (^)(BaseModel*responseObj))success{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    [CommonUtils fillStrToDictionary:params key:@"searchCookieUUID" value:[CommonUtils uuid]];
    [CommonUtils fillStrToDictionary:params key:@"session" value:[SESSION getSession].toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];
    StatusResponse * respObj = [[StatusResponse alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_productsearchkey_clear_search_history];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_productsearchkey_clear_search_history params:params responseObj:respObj success:success];
}

@end
