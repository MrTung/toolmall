//
//  ProductService.h
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "BaseService.h"
#import "ProductListResponse.h"
#import "AppProduct.h"
#import "Pagination.h"
#import "ProductDetailResponse.h"
#import "ProductDetailRequest.h"
#import "ProductViewHistoryResponse.h"

@interface ProductService : BaseService

// 商品列表
- (void) getProductList:(int)brandId activityId:(int)activityId productCategoryId:(int)productCategoryId promotionId:(int)promotionId tagId:(int)tagId attributes:(NSMutableDictionary*)attributes orderType:(NSString *)orderType pagination:(Pagination *)pagination couponId:(int)couponId;

// 商品详情
- (void) getProductInfo:(int) productId;

// 商品浏览历史
- (void)productViewHistory;

// 商品浏览历史分页
- (void)productViewHistoryWithPagination:(Pagination *)pagination;
@end
