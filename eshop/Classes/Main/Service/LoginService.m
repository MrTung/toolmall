//
//  LoginService.m
//  toolmall
//
//  Created by mc on 15/10/18.
//
//

#import "LoginService.h"

#import "InformationService.h"

@implementation LoginService

//正常用户名和密码登录
- (void) loginWithName:(NSString *)name password:(NSString *)password captchaId:(NSString *)captchaId captcha:(NSString *)captcha {
    
    UIDevice *myDevice = [[UIDevice alloc]init];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", password, @"password", captchaId, @"captchaId", captcha, @"captcha", [myDevice uniqueAppInstanceIdentifier], @"imei", nil];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_login];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    // @"正在登录"
    NSString *loginService_showHUD_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"loginService_showHUD_title"];
    [CommonUtils showHUD:loginService_showHUD_title andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_login parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSDictionary * jj = (NSDictionary *)JSON;
                UserSignInResponse * respobj = [[UserSignInResponse alloc] initWithDictionary:jj];
//                NSString * log = [[NSString alloc] initWithFormat:@"login succeed:%d", respobj.status.succeed];
//                NSLog(@"%@",log);
//                NSString * log2 = [[NSString alloc] initWithFormat:respobj.status.error_desc];
//                NSLog(@"%@",log2);
                if (respobj.status.succeed == 1){
                    [CartService setCartResponse:nil];
                    
                    if (super.delegate) {
                        
                        [super.delegate loadResponse:api_host response:respobj];
                    }
                } else {
                    if (super.parentView) {
                        
                        [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
                    }
                }
                [hud hideAnimated:YES];
                [hud removeFromSuperview];
                NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_login];
                if (beginTime) {
                    
                    NSDate *currentDate = [NSDate date];//获取当前时间，日期
                    
                    NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                    [informationService getPerformMessageWithtab:api_login time:time param:params];
                    [informationService getPerformMessageWithtab:api_login time:currentDate obj:jj];
                }
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [hud hideAnimated:YES];
                [hud removeFromSuperview];
                if (super.parentView) {
                    
                    [CommonUtils alertUnExpectedError:error view:super.parentView];
                }

                NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_login];
                if (beginTime) {
                    
                    NSDate *currentDate = [NSDate date];//获取当前时间，日期
                    
                    NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
                    [informationService getPerformMessageWithtab:api_login time:time param:params];
                    [informationService getPerformMessageWithtab:api_login time:currentDate error:error];
                }
            }];
    
    [operation start];
}

//qq登录
- (void)loginWithQQ:(NSString *)openId nickName:(NSString *)nickName cartId:(long)cartId{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    UIDevice *myDevice = [[UIDevice alloc]init];
    NSString *imei = [myDevice uniqueAppInstanceIdentifier];
    [CommonUtils fillStrToDictionary:params key:@"openId" value:openId];
    [CommonUtils fillStrToDictionary:params key:@"nickName" value:nickName];
    [CommonUtils fillIntToDictionary:params key:@"cartId" value:cartId];
    [CommonUtils fillStrToDictionary:params key:@"imei" value:imei];
    [CommonUtils fillStrToDictionary:params key:@"registerChannel" value:@"iphone"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    UserSignInResponse * respobj = [[UserSignInResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_qqlogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_qqlogin params:params responseObj:respobj showLoading:YES];

}

//WX登录
- (void)loginWithWX:(NSString *)openId nickName:(NSString *)nickName cartId:(long)cartId accessToken:(NSString *)accessToken {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    UIDevice *myDevice = [[UIDevice alloc]init];
    NSString *imei = [myDevice uniqueAppInstanceIdentifier];
    [CommonUtils fillStrToDictionary:params key:@"openId" value:openId];
    [CommonUtils fillStrToDictionary:params key:@"nickName" value:nickName];
    [CommonUtils fillIntToDictionary:params key:@"cartId" value:cartId];
    [CommonUtils fillStrToDictionary:params key:@"accessToken" value:accessToken];
    [CommonUtils fillStrToDictionary:params key:@"imei" value:imei];
    [CommonUtils fillStrToDictionary:params key:@"registerChannel" value:@"iphone"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    UserSignInResponse * respobj = [[UserSignInResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_wxlogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_wxlogin params:params responseObj:respobj showLoading:YES];
    
}



@end
