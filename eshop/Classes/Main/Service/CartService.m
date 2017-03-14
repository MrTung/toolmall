//
//  CartService.m
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import "CartService.h"

#import "InformationService.h"

static CartResponse *cartResponse;


@implementation CartService

+ (void)setCartResponse:(CartResponse*)cartResp{
    cartResponse =cartResp;
}

- (void) getCartList:(Boolean)showLoading{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[SESSION getSession] toJsonString] forKeyedSubscript:@"json"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_cart_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = nil;
    if (showLoading){
         hud= [[MBProgressHUD alloc] initWithView:super.parentView];
        // @"正在加载"
        NSString *cartService_showHUD_getCartList = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartService_showHUD_getCartList"];
        [CommonUtils showHUD:cartService_showHUD_getCartList andView:super.parentView andHUD:hud];
    }
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_cart_list parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            CartResponse * respobj = [[CartResponse alloc] initWithDictionary:jj];
            if (respobj.status.succeed == 1){
                [[Config Instance] saveCartId:respobj.data.cartId];
                [[Config Instance] saveCartToken:respobj.data.cartToken];
                [SESSION getSession].cartId = respobj.data.cartId;
                [SESSION getSession].cartToken = respobj.data.cartToken;
                [AppStatic setCART_ITEM_QUANTITIES:[respobj.data getQuantities]];
                cartResponse = respobj;
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_cart_list response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_list];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_list time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_list time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_list];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_list time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_list time:currentDate error:error];
            }
        }];
    [operation start];
}

- (void) addCartItem:(int) productId quantity:(int)quantity{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    CartItemRequest *cartItemRequest = [CartItemRequest alloc];
    cartItemRequest.productId = productId;
//    cartItemRequest.productId = 3949;
    cartItemRequest.quantity = quantity;
    cartItemRequest.session = [SESSION getSession];
    [params setObject:[cartItemRequest toJsonString] forKeyedSubscript:@"json"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_cart_item_add];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *cartService_showHUD_addCartItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartService_showHUD_addCartItem"];
    [CommonUtils showHUD:cartService_showHUD_addCartItem andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_cart_item_add parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            CartResponse * respobj = [[CartResponse alloc] initWithDictionary:jj];
            if (respobj.status.succeed == 1){
                [[Config Instance] saveCartId:respobj.data.cartId];
                [[Config Instance] saveCartToken:respobj.data.cartToken];
                [SESSION getSession].cartId = respobj.data.cartId;
                [SESSION getSession].cartToken = respobj.data.cartToken;
                [AppStatic setCART_ITEM_QUANTITIES:[respobj.data getQuantities]];
                cartResponse = respobj;
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_cart_item_add response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_item_add];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_item_add time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_item_add time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_item_add];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_item_add time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_item_add time:currentDate error:error];
            }
        }];
    [operation start];
}

#pragma mark - 多条商品加入购物车

- (void)addCartItems:(NSArray *)productIds quantities:(NSArray *)quantities{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    CartItemsRequest * cartItems = [[CartItemsRequest alloc] init];
    cartItems.session = [SESSION getSession];
    cartItems.productIds = productIds;
    cartItems.quantities = quantities;
    [params setObject:[cartItems toJsonString] forKeyedSubscript:@"json"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_cart_addmultiple];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *cartService_showHUD_addCartItems = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartService_showHUD_addCartItems"];
    [CommonUtils showHUD:cartService_showHUD_addCartItems andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_cart_addmultiple parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
         NSDictionary * jj = (NSDictionary *)JSON;
         CartResponse * respobj = [[CartResponse alloc] initWithDictionary:jj];
        if (respobj.status.succeed == 1){
            [[Config Instance] saveCartId:respobj.data.cartId];
            [[Config Instance] saveCartToken:respobj.data.cartToken];
            [SESSION getSession].cartId = respobj.data.cartId;
            [SESSION getSession].cartToken = respobj.data.cartToken;
            [AppStatic setCART_ITEM_QUANTITIES:[respobj.data getQuantities]];
            cartResponse = respobj;
            
            if (super.delegate) {
                
                [super.delegate loadResponse:api_cart_addmultiple response:respobj];
            }
        } else {
            if (super.parentView) {
                
                [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
            }
        }
          [hud hideAnimated:YES];
          [hud removeFromSuperview];
          
        NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_addmultiple];
        if (beginTime) {
            
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            
            NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
            [informationService getPerformMessageWithtab:api_cart_addmultiple time:time param:params];
            [informationService getPerformMessageWithtab:api_cart_addmultiple time:currentDate obj:jj];
        }
                                                        
                                                        
     }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
         [hud hideAnimated:YES];
         [hud removeFromSuperview];
         if (super.parentView) {
             
             [CommonUtils alertUnExpectedError:error view:super.parentView];
         }
         
         NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_addmultiple];
         if (beginTime) {
             
             NSDate *currentDate = [NSDate date];//获取当前时间，日期
             
             NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
             [informationService getPerformMessageWithtab:api_cart_addmultiple time:time param:params];
             [informationService getPerformMessageWithtab:api_cart_addmultiple time:currentDate error:error];
         }
     }];
    [operation start];

}

- (void) updateCartItem:(int) cartItemId quantity:(int)quantity selected:(Boolean)selected{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    CartItemRequest *cartItemRequest = [CartItemRequest alloc];
    cartItemRequest.cartItemId = cartItemId;
    cartItemRequest.quantity = quantity;
    cartItemRequest.selected = selected;
    cartItemRequest.session = [SESSION getSession];
    [params setObject:[cartItemRequest toJsonString] forKeyedSubscript:@"json"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_cart_update];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *cartService_showHUD_updateCartItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartService_showHUD_updateCartItem"];
    [CommonUtils showHUD:cartService_showHUD_updateCartItem andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_cart_update parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            CartResponse * respobj = [[CartResponse alloc] initWithDictionary:jj];
            if (respobj.status.succeed == 1){
                [[Config Instance] saveCartId:respobj.data.cartId];
                [[Config Instance] saveCartToken:respobj.data.cartToken];
                [SESSION getSession].cartId = respobj.data.cartId;
                [SESSION getSession].cartToken = respobj.data.cartToken;
                [AppStatic setCART_ITEM_QUANTITIES:[respobj.data getQuantities]];
                cartResponse = respobj;
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_cart_update response:respobj];
                }
            } else {
                
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_update];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_update time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_update time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_update];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_update time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_update time:currentDate error:error];
            }
        }];
    [operation start];
}

- (void) updateMultiplyCartItem:(NSMutableArray*) cartItemIds selected:(Boolean)selected {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[CommonUtils ArrayToJson:cartItemIds] forKeyedSubscript:@"cartItemIds"];
    [CommonUtils fillBooleanToDictionary:params key:@"selected" value:selected];
    [params setObject:[[SESSION getSession] toJsonString] forKeyedSubscript:@"session"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_cart_updatemult];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在加载"
    NSString *cartService_showHUD_updateMultiplyCartItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartService_showHUD_updateMultiplyCartItem"];
    [CommonUtils showHUD:cartService_showHUD_updateMultiplyCartItem andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_cart_updatemult parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            CartResponse * respobj = [[CartResponse alloc] initWithDictionary:jj];
            if (respobj.status.succeed == 1){
                [[Config Instance] saveCartId:respobj.data.cartId];
                [[Config Instance] saveCartToken:respobj.data.cartToken];
                [SESSION getSession].cartId = respobj.data.cartId;
                [SESSION getSession].cartToken = respobj.data.cartToken;
                [AppStatic setCART_ITEM_QUANTITIES:[respobj.data getQuantities]];
                cartResponse = respobj;
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_cart_updatemult response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_updatemult];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_updatemult time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_updatemult time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_updatemult];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_updatemult time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_updatemult time:currentDate error:error];
            }
        }];
    [operation start];
}

- (void) deleteCartItem:(NSMutableArray*) cartItemIds {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[CommonUtils ArrayToJson:cartItemIds] forKeyedSubscript:@"id"];
    [params setObject:[[SESSION getSession] toJsonString] forKeyedSubscript:@"session"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_cart_item_delete];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    
    // @"正在加载"
    NSString *cartService_showHUD_deleteCartItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartService_showHUD_deleteCartItem"];
    [CommonUtils showHUD:cartService_showHUD_deleteCartItem andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_cart_item_delete parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary * jj = (NSDictionary *)JSON;
            CartResponse * respobj = [[CartResponse alloc] initWithDictionary:jj];
            if (respobj.status.succeed == 1){
                [[Config Instance] saveCartId:respobj.data.cartId];
                [[Config Instance] saveCartToken:respobj.data.cartToken];
                [SESSION getSession].cartId = respobj.data.cartId;
                [SESSION getSession].cartToken = respobj.data.cartToken;
                [AppStatic setCART_ITEM_QUANTITIES:[respobj.data getQuantities]];
                cartResponse = respobj;
                
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_cart_updatemult response:respobj];
                }
            } else {
                if (super.parentView) {
                    
                    [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                }
            }
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_item_delete];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_item_delete time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_item_delete time:currentDate obj:jj];
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [hud hideAnimated:YES];
            [hud removeFromSuperview];
            if (super.parentView) {
                
                [CommonUtils alertUnExpectedError:error view:super.parentView];
            }
            
            NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_cart_item_delete];
            if (beginTime) {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                
                NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                [informationService getPerformMessageWithtab:api_cart_item_delete time:time param:params];
                [informationService getPerformMessageWithtab:api_cart_item_delete time:currentDate error:error];
            }
        }];
    [operation start];
}

- (void)getIsFreeInfoOfFirstOrder{
    SESSION * session = [SESSION getSession];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    SignalDataResponse * respobj = [[SignalDataResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_member_ismemberfirstorder];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_member_ismemberfirstorder params:params responseObj:respobj showLoading:NO];
    
}


@end
