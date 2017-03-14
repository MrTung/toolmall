//
//  FavoriteService.m
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "FavoriteService.h"

@implementation FavoriteService

- (void)getFavoriteList:(Pagination *)pagination success:(void (^)(BaseModel*responseObj))success{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    FavoriteListRequest *request = [[FavoriteListRequest alloc] init];
    request.session = session;
    request.pagination = pagination;
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    FavoriteListResponse *respObj = [[FavoriteListResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_favorite_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_favorite_list params:params responseObj:respObj success:success];
}

- (void)delFavorite:(int)productId success:(void (^)(BaseModel*responseObj))success{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    FavoriteDeleteRequest *request = [[FavoriteDeleteRequest alloc] init];
    request.session = session;
    request.ProductId = productId;
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_favorite_delete];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_favorite_delete params:params responseObj:respObj success:success];
}

- (void)addFavorite:(int)productId success:(void (^)(BaseModel*responseObj))success{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillIntToDictionary:params key:@"productId" value:productId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_favorite_add];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_favorite_add params:params responseObj:respObj success:success];
}

//移除多个收藏
- (void)delFavorites:(NSArray *)productIds success:(void (^)(BaseModel*responseObj))success{
    SESSION *session = [SESSION getSession];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    FavoritesDeleteRequest *request = [[FavoritesDeleteRequest alloc] init];
    request.session = session;
    request.productIds = productIds;
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_favorite_deleteFavorites];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_favorite_deleteFavorites params:params responseObj:respObj success:success];
}


@end
