//
//  ProductService.m
//  toolmall
//
//  Created by mc on 15/10/25.
//
//

#import "ProductService.h"

#import "InformationService.h"

@implementation ProductService

/** 获取优惠券适用商品 **/
- (void) getProductList:(int)brandId activityId:(int)activityId productCategoryId:(int)productCategoryId promotionId:(int)promotionId tagId:(int)tagId attributes:(NSMutableDictionary*)attributes orderType:(NSString *)orderType pagination:(Pagination *)pagination couponId:(int)couponId{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"orderType" value:orderType];
    [CommonUtils fillIntToDictionary:params key:@"promotionId" value:promotionId];
    [CommonUtils fillIntToDictionary:params key:@"activityId" value:activityId];
    [CommonUtils fillIntToDictionary:params key:@"tagId" value:tagId];
    [CommonUtils fillIntToDictionary:params key:@"brandId" value:brandId];
    [CommonUtils fillIntToDictionary:params key:@"productCategoryId" value:productCategoryId];
    [CommonUtils fillIntToDictionary:params key:@"couponId" value:couponId];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    NSEnumerator *keys = [attributes keyEnumerator];
    for (NSString *key in keys) {
        [CommonUtils fillStrToDictionary:params key:key value:[attributes objectForKey:key]];
    }
    [params setObject:[pagination toJsonString] forKeyedSubscript:@"pagination"];
    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_product_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *productService_showHUD_getProductList = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productService_showHUD_getProductList"];
    [CommonUtils showHUD:productService_showHUD_getProductList andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_product_list parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            ProductListResponse * respobj = [[ProductListResponse alloc] initWithDictionary:jj];
//            NSString * log = [[NSString alloc] initWithFormat:@"login succeed:%d", respobj.status.succeed];
//            NSLog(log);
            if (respobj.status.succeed == 1){
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_product_list response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_product_list];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_product_list time:time param:params];
                [informationService getPerformMessageWithtab:api_product_list time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }

            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_product_list];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_product_list time:time param:params];
                [informationService getPerformMessageWithtab:api_product_list time:currentDate error:error];
            }
        }];
    [operation start];
}


- (void)getProductInfo:(NSInteger) productId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    ProductDetailRequest *requestParam = [[ProductDetailRequest alloc] init];
    requestParam.productId = productId;
    requestParam.session = [SESSION getSession];
    [CommonUtils fillStrToDictionary:params key:@"json" value:requestParam.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_product_info];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *productService_showHUD_getProductInfo = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productService_showHUD_getProductInfo"];
    [CommonUtils showHUD:productService_showHUD_getProductInfo andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_product_info parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            ProductDetailResponse * respobj = [[ProductDetailResponse alloc] initWithDictionary:jj];
            if (respobj.status.succeed == 1){
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_product_info response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_product_info];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_product_info time:time param:params];
                [informationService getPerformMessageWithtab:api_product_info time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }

            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_product_info];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_product_info time:time param:params];
                [informationService getPerformMessageWithtab:api_product_info time:currentDate error:error];
            }
        }];
    [operation start];
}

// 商品浏览历史
- (void)productViewHistory{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:[SESSION getSession].toJsonString forKey:@"session"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    ProductViewHistoryResponse *respObj = [[ProductViewHistoryResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_member_productviewhistory];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_member_productviewhistory params:params responseObj:respObj showLoading:NO];
}

// 商品浏览历史-page分页
- (void)productViewHistoryWithPagination:(Pagination *)pagination{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:10];
    [params setObject:[SESSION getSession].toJsonString forKey:@"session"];
    [params setObject:pagination.toJsonString forKey:@"pagination"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    ProductViewHistoryResponse *respObj = [[ProductViewHistoryResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_member_productviewhist_page];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_member_productviewhist_page params:params responseObj:respObj showLoading:YES];
}

@end
