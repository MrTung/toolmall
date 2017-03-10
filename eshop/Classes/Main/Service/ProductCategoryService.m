//
//  ProductCategoryService.m
//  toolmall
//
//  Created by mc on 15/10/20.
//
//

#import "ProductCategoryService.h"

#import "InformationService.h"

@implementation ProductCategoryService
- (void) getRoots{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"1", nil];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_productcat_roots];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *productCategoryService_showHUD_getRoots = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productCategoryService_showHUD_getRoots"];
    [CommonUtils showHUD:productCategoryService_showHUD_getRoots andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_productcat_roots parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            ProductCategoryListResponse * respobj = [[ProductCategoryListResponse alloc] initWithDictionary:jj];
            if (respobj.status.succeed == 1){
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_productcat_roots response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_productcat_roots];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_productcat_roots time:time param:params];
                [informationService getPerformMessageWithtab:api_productcat_roots time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }

            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_productcat_roots];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_productcat_roots time:time param:params];
                [informationService getPerformMessageWithtab:api_productcat_roots time:currentDate error:error];
            }
        }];
    [operation start];
}

- (void) getRoots_v2{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"1", nil];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_productcat_roots_v2];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *productCategoryService_showHUD_getRoots_v2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productCategoryService_showHUD_getRoots_v2"];
    [CommonUtils showHUD:productCategoryService_showHUD_getRoots_v2 andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_productcat_roots_v2 parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            ProductCategoryListResponse * respobj = [[ProductCategoryListResponse alloc] initWithDictionary:jj];
            if (respobj.status.succeed == 1){
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_productcat_roots_v2 response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_productcat_roots_v2];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_productcat_roots_v2 time:time param:params];
                [informationService getPerformMessageWithtab:api_productcat_roots_v2 time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_productcat_roots_v2];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_productcat_roots_v2 time:time param:params];
                [informationService getPerformMessageWithtab:api_productcat_roots_v2 time:currentDate error:error];
            }
        }];
    [operation start];
}
- (void) getChildren:(NSString *)parentId{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:parentId, @"parentId", nil];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_productcat_children];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *productCategoryService_showHUD_getChildren = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productCategoryService_showHUD_getChildren"];
    [CommonUtils showHUD:productCategoryService_showHUD_getChildren andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_productcat_children parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            ProductCategoryListResponse * respobj = [[ProductCategoryListResponse alloc] initWithDictionary:jj];
            if (respobj.status.succeed == 1){
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_productcat_children response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_productcat_children];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_productcat_children time:time param:params];
                [informationService getPerformMessageWithtab:api_productcat_children time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }

            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_productcat_children];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_productcat_children time:time param:params];
                [informationService getPerformMessageWithtab:api_productcat_children time:currentDate error:error];
            }
        }];
    [operation start];
}

@end
