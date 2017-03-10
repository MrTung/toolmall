//
//  SearchService.h
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "BaseService.h"
#import "ProductListResponse.h"
#import "HotSearchKeyListResponse.h"

@interface SearchService : BaseService


- (void) getProductSearchResult:(NSString*)keyword orderType:(NSString*)orderType pagination:(Pagination*)pagination;


- (void)getProductWithFetchSearchHistory:(Boolean)fetchSearchHistory andSearchCookieUUID:(NSString *)UUID andSession:(SESSION *)session andPagination:(Pagination *)pagination;


- (void)deleteHistoryKeyWordWithSearchCookieUUID:(NSString *)UUID andSession:(SESSION *)session;

@end
