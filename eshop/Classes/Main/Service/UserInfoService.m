//
//  UserInfoService.m
//  toolmall
//
//  Created by mc on 15/10/18.
//
//

#import "UserInfoService.h"
#import "InformationService.h"

@implementation UserInfoService

- (void) getUserInfo{
    
    SESSION *session = [SESSION getSession];
    if (session == nil){
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:session.uname, @"userName", session.sid, @"sessionId",session.getStringUId, @"memberId", session.key, @"key", nil];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    InformationService *informationService = [[InformationService alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_userinfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:api_host]];
    MBProgressHUD * hud;
    if (super.parentView != nil){
        hud = [[MBProgressHUD alloc] initWithView:super.parentView];
    }
    //[CommonUtils showHUD:@"正在加载" andView:super.parentView andHUD:hud];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:api_userinfo parameters:params];
    AFJSONRequestOperation * operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                

        NSDictionary * jj = (NSDictionary *)JSON;
        UserInfoResponse * respobj = [[UserInfoResponse alloc] initWithDictionary:jj];
        
        if (respobj.status.succeed == 1){
            [SESSION setMobileNo:respobj.data.mobile];
            [SESSION setIsUserNameChanged:respobj.data.userNameChanged];
//            if (super.delegate != nil){
                if (super.delegate) {
                    
                    [super.delegate loadResponse:api_userinfo response:respobj];
                }
//            }
        } else {
            if (super.parentView) {
                
                [CommonUtils ToastNotification:respobj.status.error_desc andView:super.parentView andLoading:NO andIsBottom:YES];
            }
        }
        
        [hud hideAnimated:YES];
        [hud removeFromSuperview];
                
        NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_userinfo];
        if (beginTime) {
            
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            
            NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
            [informationService getPerformMessageWithtab:api_userinfo time:time param:params];
            [informationService getPerformMessageWithtab:api_userinfo time:currentDate obj:jj];
        }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [hud hideAnimated:YES];
        [hud removeFromSuperview];
        if (super.parentView) {
            
            [CommonUtils alertUnExpectedError:error view:super.parentView];
        }
        
        NSDate *beginTime = [[NSUserDefaults standardUserDefaults] objectForKey:api_userinfo];
        if (beginTime) {
            
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            
            NSTimeInterval time = [informationService getMarginTimeWithbeginTime:beginTime];
            [informationService getPerformMessageWithtab:api_userinfo time:time param:params];
            [informationService getPerformMessageWithtab:api_userinfo time:currentDate error:error];
        }

    }];
    [operation start];
}



//获取短信验证
- (void)getSmsAuthCode:(NSString *)mobileNo chkMobileExist:(NSString *)chkMobileExist{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"mobileNo" value:mobileNo];
    if (![chkMobileExist isEqualToString:@"N"]) {
        chkMobileExist = @"Y";
    }
    [CommonUtils fillStrToDictionary:params key:@"chkMobileExist" value:chkMobileExist];
    [CommonUtils fillStrToDictionary:params key:@"channel" value:@"iphone"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    SmsAuthCodeResponse *respObj = [[SmsAuthCodeResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_getSmsAuthCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [super request:api_getSmsAuthCode params:params responseObj:respObj];
}


//以前的版本
- (void)userRegiste:(NSString*)name password:(NSString*)password email:(NSString*)email mobileNo:(NSString*)mobileNo{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"name" value:name];
    [CommonUtils fillStrToDictionary:params key:@"password" value:password];
    [CommonUtils fillStrToDictionary:params key:@"email" value:email];
    [CommonUtils fillStrToDictionary:params key:@"mobileNo" value:mobileNo];
    [CommonUtils fillStrToDictionary:params key:@"registerChannel" value:@"iphone"];
    [CommonUtils fillStrToDictionary:params key:@"phoneManfacturer" value:@"apple"];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    UserSignInResponse *respObj = [[UserSignInResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_member_register];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_member_register params:params responseObj:respObj];
    
}



//手机号注册
- (void)userRegisteMobileNo:(NSString *)mobileNo smsAuthCode:(NSString *)smsAuthCode password:(NSString *)password{
    UIDevice *myDevice = [[UIDevice alloc]init];
    NSString *imei = [myDevice uniqueAppInstanceIdentifier];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"mobileNo" value:mobileNo];
    [CommonUtils fillStrToDictionary:params key:@"smsAuthCode" value:smsAuthCode];
    [CommonUtils fillStrToDictionary:params key:@"password" value:password];
    [CommonUtils fillStrToDictionary:params key:@"registerChannel" value:@"iphone"];
    [CommonUtils fillStrToDictionary:params key:@"phoneManfacturer" value:@"apple"];
    [CommonUtils fillStrToDictionary:params key:@"imei" value:imei];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    UserSignInResponse *respObj = [[UserSignInResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_mobileregister];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_mobileregister params:params responseObj:respObj];
}

//手机号绑定
- (void)userBondMobileNo:(NSString *)mobileNo authCode:(NSString *)authCode password:(NSString *)password session:(SESSION *)session{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"mobileNo" value:mobileNo];
    [CommonUtils fillStrToDictionary:params key:@"authCode" value:authCode];
    [CommonUtils fillStrToDictionary:params key:@"password" value:password];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];


    UserSignInResponse *respObj = [[UserSignInResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_bandmobile];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_bandmobile params:params responseObj:respObj];

}
//修改会员用户名
- (void)userChangeUserName:(NSString *)userName{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    SESSION *session = [SESSION getSession];
    [CommonUtils fillStrToDictionary:params key:@"username" value:userName];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_member_change_username];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_member_change_username params:params responseObj:respObj];
}

//修改会员用户字段
- (void)userChangeUserFieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    SESSION *session = [SESSION getSession];
    [CommonUtils fillStrToDictionary:params key:@"fieldName" value:fieldName];
    [CommonUtils fillStrToDictionary:params key:@"fieldValue" value:fieldValue];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_member_change_userfield];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_member_change_userfield params:params responseObj:respObj];
}

//修改手机号
- (void)userChangeMobileNo:(NSString *)newMobileNo oldMobileNo:(NSString *)oldMobileNo{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    SESSION *session = [SESSION getSession];
    [CommonUtils fillStrToDictionary:params key:@"newMobileNo" value:newMobileNo];
    [CommonUtils fillStrToDictionary:params key:@"oldMobileNo" value:oldMobileNo];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_member_changemobileno];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_member_changemobileno params:params responseObj:respObj];
}

//重置密码
- (void)userChangePassword:(NSString *)newPassword{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    SESSION *session = [SESSION getSession];
    [CommonUtils fillStrToDictionary:params key:@"newPassword" value:newPassword];
    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_password_resetviaapp];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_password_resetviaapp params:params responseObj:respObj];
}

//验证短信验证码
- (void)userVerifySmsAuthCode:(NSString *)smsAuthCode mobileNo:(NSString *)mobileNo{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    SESSION *session = [SESSION getSession];
    [CommonUtils fillStrToDictionary:params key:@"smsAuthCode" value:smsAuthCode];
    [CommonUtils fillStrToDictionary:params key:@"mobileNo" value:mobileNo];
    //    [CommonUtils fillStrToDictionary:params key:@"session" value:session.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    StatusResponse *respObj = [[StatusResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_smsauthcode_verifySmsAuthCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_smsauthcode_verifySmsAuthCode params:params responseObj:respObj];
}

- (void)updateMore:(AppMemberMoreUpdateRequest *)request{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"json" value:request.toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    UserSignInResponse *respObj = [[UserSignInResponse alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_member_update_more];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_member_update_more params:params responseObj:respObj];
    
}

#pragma mark - 关键信息收集-上传用户头像-未收集

- (void)uploadHeadImage:(UIImage *)image{

    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"session" value:[SESSION getSession].toJsonString];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    NSURL *url = [NSURL URLWithString:api_host];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:api_member_upload_headimage parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation start];
}
@end
