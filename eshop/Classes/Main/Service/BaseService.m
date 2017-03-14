//
//  BaseService.m
//  toolmall
//
//  Created by mc on 15/10/18.
//
//

#import "BaseService.h"

#import "InformationService.h"

@implementation BaseService

- (id)initWithDelegate:(id)delegate parentView:(UIView *)view{
    
    self.delegate = delegate;
    
    if (view) {
        
        self.parentView = view;
    } else {
        self.parentView = [UIApplication sharedApplication].keyWindow;
    }
    return self;
}

#pragma mark dxw

- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj success:(void (^)(BaseModel*responseObj))success{
    InformationService *informationService = [[InformationService alloc] init];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.parentView];
    
    // @"正在加载"
    NSString *baseService_showHUD_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"baseService_showHUD_title"];
    if (!baseService_showHUD_title.length) {
        baseService_showHUD_title = @"正在加载";
    }
    [CommonUtils showHUD:baseService_showHUD_title andView:self.parentView andHUD:hud];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_url parameters:params];
    
    
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSDictionary * dict = (NSDictionary *)JSON;
                                                        [responseObj initWithDictionary:dict];
                                                        responseObj.paymentPluginId = params[@"paymentPluginId"];
                                                        NSDictionary *status = [dict objectForKey:@"status"];
                                                        NSNumber *succeed = [status objectForKey:@"succeed"];
                                                        
                                                        if (status != nil && [succeed intValue] == 0 && self.parentView){
                                                            
                                                            [CommonUtils ToastNotification:[status objectForKey:@"error_desc"] andView:self.parentView andLoading:NO andIsBottom:YES];
                                                        }
                                                        if (success) {
                                                            success(responseObj);
                                                        }
                                                        [hud hideAnimated:YES];
                                                        [hud removeFromSuperview];
                                                        
                                                        NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_url];
                                                        if (beginTime) {
                                                            
                                                            NSDate *currentDate = [NSDate date];//获取当前时间，日期
                                                            
                                                            NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                                                            [informationService getPerformMessageWithtab:api_url time:time param:params];
                                                            [informationService getPerformMessageWithtab:api_url time:currentDate obj:dict];
                                                        }
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        
                                                        [hud hideAnimated:YES];
                                                        [hud removeFromSuperview];
                                                        
                                                        if (self.parentView) {
                                                            
                                                            [CommonUtils alertUnExpectedError:error view:self.parentView];
                                                        }
                                                        
                                                        NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_url];
                                                        if (beginTime) {
                                                            
                                                            NSDate *currentDate = [NSDate date];//获取当前时间，日期
                                                            
                                                            NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                                                            [informationService getPerformMessageWithtab:api_url time:time param:params];
                                                            [informationService getPerformMessageWithtab:api_url time:currentDate error:error];
                                                        }
                                                    }];
    [operation start];
}

- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj{
    
    
    InformationService *informationService = [[InformationService alloc] init];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.parentView];

    // @"正在加载"
    NSString *baseService_showHUD_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"baseService_showHUD_title"];
    if (!baseService_showHUD_title.length) {
        baseService_showHUD_title = @"正在加载";
    }
    [CommonUtils showHUD:baseService_showHUD_title andView:self.parentView andHUD:hud];
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_url parameters:params];
    
    
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSDictionary * dict = (NSDictionary *)JSON;
            [responseObj initWithDictionary:dict];
            responseObj.paymentPluginId = params[@"paymentPluginId"];
            NSDictionary *status = [dict objectForKey:@"status"];
            NSNumber *succeed = [status objectForKey:@"succeed"];

            if (status != nil && [succeed intValue] == 0 && self.parentView){
                
                [CommonUtils ToastNotification:[status objectForKey:@"error_desc"] andView:self.parentView andLoading:NO andIsBottom:YES];
            }
            if (self.delegate) {
//                [self.delegate respondToSelector:@selector(loadResponse:response:)];
                [self.delegate loadResponse:api_url response:responseObj];
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_url];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_url time:time param:params];
                [informationService getPerformMessageWithtab:api_url time:currentDate obj:dict];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            if (self.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:self.parentView];
            }
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_url];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_url time:time param:params];
                [informationService getPerformMessageWithtab:api_url time:currentDate error:error];
            }
        }];
    [operation start];
}
#pragma mark dxw

- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj showLoading:(Boolean)showLoading{
    [self request:api_url params:params responseObj:responseObj showLoading:showLoading method:@"POST"];
}


- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj showLoading:(Boolean)showLoading success:(void (^)(BaseModel*responseObj))success{
    [self request:api_url params:params responseObj:responseObj showLoading:showLoading method:@"POST" success:success];
}

#pragma mark dxw

- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj showLoading:(Boolean)showLoading method:(NSString*)method{
    
    InformationService *informationService = [[InformationService alloc] init];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = nil;
    if (showLoading){
         hud = [[MBProgressHUD alloc] initWithView:self.parentView];
        // @"正在加载"
        NSString *baseService_showHUD_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"baseService_showHUD_title"];
        if (!baseService_showHUD_title.length) {
            baseService_showHUD_title = @"正在加载";
        }
        [CommonUtils showHUD:baseService_showHUD_title andView:self.parentView andHUD:hud];
    }
    NSURLRequest *request = [client requestWithMethod:method path:api_url parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSDictionary * dict = (NSDictionary *)JSON;
            [responseObj initWithDictionary:dict];
            NSDictionary *status = [dict objectForKey:@"status"];
            NSNumber *succeed = [status objectForKey:@"succeed"];
            
            if (status != nil && [succeed intValue] == 0 && self.parentView){
                [CommonUtils ToastNotification:[status objectForKey:@"error_desc"] andView:self.parentView andLoading:NO andIsBottom:YES];
            }
            if (self.delegate) {
                
                [self.delegate loadResponse:api_url response:responseObj];
            }
            if (showLoading){
                [hud hideAnimated:YES];
                [hud removeFromSuperview];
            }
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_url];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_url time:time param:params];
                [informationService getPerformMessageWithtab:api_url time:currentDate obj:dict];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            if (showLoading){
                [hud hideAnimated:YES];
                [hud removeFromSuperview];
            }
            
            if (self.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:self.parentView];
            }
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_url];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_url time:time param:params];
                [informationService getPerformMessageWithtab:api_url time:currentDate error:error];
            }
        }];
    [operation start];
}

- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj showLoading:(Boolean)showLoading method:(NSString*)method success:(void (^)(BaseModel*responseObj))success{
    
    InformationService *informationService = [[InformationService alloc] init];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = nil;
    if (showLoading){
        hud = [[MBProgressHUD alloc] initWithView:self.parentView];
        // @"正在加载"
        NSString *baseService_showHUD_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"baseService_showHUD_title"];
        if (!baseService_showHUD_title.length) {
            baseService_showHUD_title = @"正在加载";
        }
        [CommonUtils showHUD:baseService_showHUD_title andView:self.parentView andHUD:hud];
    }
    NSURLRequest *request = [client requestWithMethod:method path:api_url parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        
                                                        NSDictionary * dict = (NSDictionary *)JSON;
                                                        [responseObj initWithDictionary:dict];
                                                        NSDictionary *status = [dict objectForKey:@"status"];
                                                        NSNumber *succeed = [status objectForKey:@"succeed"];
                                                        
                                                        if (status != nil && [succeed intValue] == 0 && self.parentView){
                                                            [CommonUtils ToastNotification:[status objectForKey:@"error_desc"] andView:self.parentView andLoading:NO andIsBottom:YES];
                                                        }
                                                        if (success) {
                                                            success(responseObj);
                                                        }
                                                        if (showLoading){
                                                            [hud hideAnimated:YES];
                                                            [hud removeFromSuperview];
                                                        }
                                                        
                                                        NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_url];
                                                        if (beginTime) {
                                                            
                                                            NSDate *currentDate = [NSDate date];//获取当前时间，日期
                                                            
                                                            NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                                                            [informationService getPerformMessageWithtab:api_url time:time param:params];
                                                            [informationService getPerformMessageWithtab:api_url time:currentDate obj:dict];
                                                        }
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        if (showLoading){
                                                            [hud hideAnimated:YES];
                                                            [hud removeFromSuperview];
                                                        }
                                                        
                                                        if (self.parentView) {
                                                            
                                                            [CommonUtils alertUnExpectedError:error view:self.parentView];
                                                        }
                                                        
                                                        NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_url];
                                                        if (beginTime) {
                                                            
                                                            NSDate *currentDate = [NSDate date];//获取当前时间，日期
                                                            
                                                            NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                                                            [informationService getPerformMessageWithtab:api_url time:time param:params];
                                                            [informationService getPerformMessageWithtab:api_url time:currentDate error:error];
                                                        }
                                                    }];
    [operation start];
}

@end
