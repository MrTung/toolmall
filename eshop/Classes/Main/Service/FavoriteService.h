//
//  FavoriteService.h
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "FavoriteListRequest.h"
#import "FavoriteListResponse.h"
#import "FavoriteDeleteRequest.h"
#import "StatusResponse.h"
#import "FavoritesDeleteRequest.h"
#import "Pagination.h"
@interface FavoriteService : BaseService


- (void)getFavoriteList:(Pagination *)pagination;

- (void)delFavorite:(int)productId;


- (void)addFavorite:(int)productId;


//多个
- (void)delFavorites:(NSArray *)productIds;
@end
