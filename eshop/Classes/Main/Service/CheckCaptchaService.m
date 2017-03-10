//
//  CheckCaptchaService.m
//  eshop
//
//  Created by sh on 17/1/4.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "CheckCaptchaService.h"

@implementation CheckCaptchaService

- (void)chackImgByCaptchaId:(NSString *)captchaId captcha:(NSString *)captcha {
    
    StatusResponse *response = [[StatusResponse alloc] init];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [CommonUtils fillStrToDictionary:params key:@"captchaId" value:captchaId];
    [CommonUtils fillStrToDictionary:params key:@"captcha" value:captcha];
    [CommonUtils fillStrToDictionary:params key:iOSAppVersion value:[CommonUtils returnVersion]];
    [CommonUtils fillStrToDictionary:params key:iOSApiVersion value:@"iOS_1.1.1"];

    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:api_check_captcha];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super request:api_check_captcha params:params responseObj:response showLoading:NO];
}
@end
